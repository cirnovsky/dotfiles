#!/usr/bin/env python3
"""Turn a raw MIME email (on stdin) into a self-contained HTML file and open it.

mutt's browser macro used to hand the viewer only the text/html MIME part, so a
browser saw cid: image references with nothing to resolve them against and drew
broken-image icons. Here we parse the whole message, pull out the HTML part and
every image part, and rewrite each `cid:<id>` reference into a base64 `data:`
URI so the result is a single standalone file that renders inline images.
"""
import base64
import email
import email.policy
import re
import subprocess
import sys
import tempfile


def main():
    # Whole message on stdin (mutt <pipe-message>), or a file path as argv[1]
    # (legacy mailcap %s path — inline images won't resolve there since only the
    # single HTML part is available, but it still opens the HTML).
    if len(sys.argv) > 1:
        with open(sys.argv[1], "rb") as fh:
            msg = email.message_from_binary_file(fh, policy=email.policy.default)
    else:
        msg = email.message_from_binary_file(sys.stdin.buffer, policy=email.policy.default)

    # Collect the HTML body plus any part that carries a Content-ID (inline
    # images) or is an image attachment we might rewrite by cid.
    html = None
    cid_map = {}  # normalized content-id -> (mime_type, raw_bytes)
    for part in msg.walk():
        ctype = part.get_content_type()
        if part.is_multipart():
            continue
        cid = part.get("Content-ID")
        if cid:
            cid_map[cid.strip().strip("<>")] = (ctype, part.get_payload(decode=True))
        if ctype == "text/html" and html is None:
            payload = part.get_payload(decode=True)
            charset = part.get_content_charset() or "utf-8"
            try:
                html = payload.decode(charset, errors="replace")
            except LookupError:
                html = payload.decode("utf-8", errors="replace")

    if html is None:
        sys.stderr.write("view-html-browser: no text/html part found\n")
        sys.exit(1)

    def to_data_uri(cid):
        entry = cid_map.get(cid.strip().strip("<>"))
        if not entry:
            return None
        mime_type, data = entry
        if data is None:
            return None
        b64 = base64.b64encode(data).decode("ascii")
        return f"data:{mime_type};base64,{b64}"

    # Rewrite src="cid:..." / src='cid:...' / bare src=cid:... references.
    def repl(match):
        quote, cid = match.group("quote") or "", match.group("cid")
        uri = to_data_uri(cid)
        if uri is None:
            return match.group(0)
        return f'src={quote}{uri}{quote}'

    html = re.sub(
        r'src\s*=\s*(?P<quote>["\']?)cid:(?P<cid>[^"\'>\s]+)(?P=quote)',
        repl,
        html,
        flags=re.IGNORECASE,
    )
    # Also handle url(cid:...) inside inline CSS / style attributes.
    def repl_url(match):
        quote = match.group("quote") or ""
        uri = to_data_uri(match.group("cid"))
        if uri is None:
            return match.group(0)
        return f'url({quote}{uri}{quote})'

    html = re.sub(
        r'url\((?P<quote>["\']?)cid:(?P<cid>[^"\')\s]+)(?P=quote)\)',
        repl_url,
        html,
        flags=re.IGNORECASE,
    )

    fd, path = tempfile.mkstemp(prefix="mutt-html-", suffix=".html")
    with open(fd, "w", encoding="utf-8") as f:
        f.write(html)
    subprocess.run(["open", path], check=False)


if __name__ == "__main__":
    main()
