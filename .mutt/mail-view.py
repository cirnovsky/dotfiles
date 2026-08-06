#!/usr/bin/env python3
"""Render a raw MIME email for the vim mail viewer (see mail-view.vim).

Fed the WHOLE raw message as a file path so it has the full MIME tree, this
prints one of several views to stdout:

  mail-view.py parts  <raw.eml>            list available body types, one per
                                           line ("plain" and/or "html"), so vim
                                           knows what it can toggle to
  mail-view.py render <raw.eml> plain      decoded text/plain body (falls back
                                           to a dump of text/html if that is all
                                           the message carries)
  mail-view.py render <raw.eml> html       the text/html body rendered through
                                           the mailcap "copiousoutput" entry
                                           (w3m dump), i.e. "mailcapped" HTML;
                                           each cid: image is tagged so the dump
                                           shows a resolvable "[cid:<id>]" token
  mail-view.py attach <raw.eml> N          extract the Nth attachment (as listed
                                           in the render's "Attachments:" block)
                                           to a temp file and open it with the OS
  mail-view.py attach-cid <raw.eml> CID    same, but locate the part by the cid:
                                           reference under the cursor (the inline
                                           images the body points at with cid:)

Every render is prefixed with a short decoded header block (From/To/Subject/…)
and, when the message carries attachments, followed by an "Attachments:" footer.
The HTML view keeps links: w3m's display_link_number puts numbered [N] markers
inline and a "References:" list of URLs at the foot.
Transfer-encoding (base64, quoted-printable) and charset are both decoded here;
that is the "decoding" half of the feature. Opening cid-replaced HTML in a
browser is delegated to the existing view-html-browser.py.
"""
import email
import email.policy
import mimetypes
import os
import re
import shlex
import subprocess
import sys
import tempfile

MAILCAP = os.path.expanduser("~/.mutt/mailcap")
# Faithful fallback matching the mailcap text/html copiousoutput entry.
DEFAULT_HTML_CMD = "w3m -I %{charset} -T text/html -dump %s"
HEADER_FIELDS = ("Date", "From", "To", "Cc", "Subject")


def load_msg(path):
    with open(path, "rb") as fh:
        return email.message_from_binary_file(fh, policy=email.policy.default)


def body_part(msg, ctype):
    """First non-attachment leaf part of the given content type, or None."""
    for part in msg.walk():
        if part.is_multipart():
            continue
        if part.get_content_type() != ctype:
            continue
        if (part.get_content_disposition() or "") == "attachment":
            continue
        return part
    return None


def decode_text(part):
    payload = part.get_payload(decode=True) or b""
    charset = part.get_content_charset() or "utf-8"
    try:
        return payload.decode(charset, errors="replace")
    except LookupError:
        return payload.decode("utf-8", errors="replace")


def header_block(msg):
    lines = []
    for field in HEADER_FIELDS:
        value = msg[field]
        if value:
            # policy=default already decodes RFC 2047 encoded-words to str.
            lines.append(f"{field}: {' '.join(str(value).split())}")
    lines.append("")  # blank line separating headers from body
    return "\n".join(lines)


def mailcap_html_command():
    """Command string from the text/html mailcap entry that has copiousoutput.

    Parsed leniently: `type; command; flag; flag=value`. We want the dump entry
    (copiousoutput), not the interactive browser one. Falls back to w3m.
    """
    try:
        with open(MAILCAP, encoding="utf-8") as fh:
            raw = fh.read()
    except OSError:
        return DEFAULT_HTML_CMD

    # Join backslash line-continuations, then consider each logical line.
    for line in raw.replace("\\\n", " ").splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        fields = [f.strip() for f in stripped.split(";")]
        if len(fields) < 2:
            continue
        mtype, command, flags = fields[0].lower(), fields[1], fields[2:]
        if mtype not in ("text/html", "text/*", "*/*"):
            continue
        if any(f.split("=")[0].strip() == "copiousoutput" for f in flags):
            return command
    return DEFAULT_HTML_CMD


_IMG_TAG = re.compile(r"<img\b[^>]*>", re.IGNORECASE)
_IMG_SRC_CID = re.compile(r"""src\s*=\s*(["']?)cid:(?P<cid>[^"'>\s]+)\1""",
                          re.IGNORECASE)
_IMG_ALT = re.compile(r"""alt\s*=\s*("(?P<dq>[^"]*)"|'(?P<sq>[^']*)'|(?P<bare>[^\s>]*))""",
                      re.IGNORECASE)


def tag_cid_alt(html):
    """Give every cid: <img> an alt text carrying its cid.

    w3m's -dump renders an image as its alt text, or, when there is no alt, as an
    anonymous '[cid]' (the URL scheme in brackets) that can't be traced back to a
    part. Rewriting each cid: image's alt to '[cid:<id>]' (appended to any caption
    it already has) makes the dump show a resolvable token the viewer's gx opens.
    """
    def rewrite(m):
        tag = m.group(0)
        src = _IMG_SRC_CID.search(tag)
        if not src:
            return tag
        token = "[cid:{}]".format(src.group("cid"))
        alt = _IMG_ALT.search(tag)
        if alt:
            existing = (alt.group("dq") or alt.group("sq")
                        or alt.group("bare") or "").replace('"', "").strip()
            newalt = "{} {}".format(existing, token) if existing else token
            return tag[:alt.start()] + 'alt="{}"'.format(newalt) + tag[alt.end():]
        # No alt attribute at all — insert one right after the opening '<img'.
        return '<img alt="{}"'.format(token) + tag[4:]
    return _IMG_TAG.sub(rewrite, html)


def render_html(msg):
    part = body_part(msg, "text/html")
    if part is None:
        return None
    html = tag_cid_alt(decode_text(part))
    charset = part.get_content_charset() or "utf-8"
    cmd = mailcap_html_command()

    fd, path = tempfile.mkstemp(prefix="mail-view-", suffix=".html")
    try:
        with open(fd, "w", encoding="utf-8") as fh:
            fh.write(html)
        full = cmd.replace("%{charset}", charset).replace("%s", shlex.quote(path))
        proc = subprocess.run(full, shell=True, capture_output=True, text=True)
        out = proc.stdout
        if proc.returncode != 0 and not out:
            out = f"[mail-view: HTML renderer failed]\n{proc.stderr}"
        return out
    finally:
        os.unlink(path)


def render_plain(msg):
    part = body_part(msg, "text/plain")
    if part is not None:
        return decode_text(part)
    # No plain part — fall back to a dump of the HTML so the view isn't empty.
    html = render_html(msg)
    if html is not None:
        return html
    return "[mail-view: no text/plain or text/html body found]"


def attachment_parts(msg):
    """Leaf parts that are attachments rather than the displayed body.

    A part counts as an attachment if it is dispositioned "attachment", carries
    a filename, or is simply not a text body (e.g. an inline image referenced by
    cid). The text/plain and text/html body parts are excluded.
    """
    atts = []
    for part in msg.walk():
        if part.is_multipart():
            continue
        ctype = part.get_content_type()
        disp = part.get_content_disposition() or ""
        filename = part.get_filename()
        is_body = ctype in ("text/plain", "text/html") and disp != "attachment" and not filename
        if is_body:
            continue
        if disp == "attachment" or filename or not ctype.startswith("text/"):
            atts.append(part)
    return atts


def human_size(nbytes):
    size = float(nbytes)
    for unit in ("B", "KB", "MB", "GB", "TB"):
        if size < 1024 or unit == "TB":
            return f"{int(size)} {unit}" if unit == "B" else f"{size:.1f} {unit}"
        size /= 1024


def attachment_name(part, idx):
    name = part.get_filename()
    if name:
        return name
    ext = mimetypes.guess_extension(part.get_content_type()) or ""
    return f"attachment-{idx}{ext}"


def attachment_lines(msg):
    """A footnote block listing the message's attachments, or [] if none."""
    atts = attachment_parts(msg)
    if not atts:
        return []
    lines = ["", "Attachments:"]
    for i, part in enumerate(atts, 1):
        name = attachment_name(part, i)
        size = human_size(len(part.get_payload(decode=True) or b""))
        inline = " inline" if (part.get_content_disposition() == "inline"
                               or part.get("Content-ID")) else ""
        lines.append(f"[{i}] {name}  ({part.get_content_type()}, {size}{inline})")
    return lines


def normalize_cid(value):
    """Strip a cid: reference or a Content-ID header down to its bare id."""
    value = value.strip()
    if value.lower().startswith("cid:"):
        value = value[4:]
    return value.strip().strip("<>").strip()


def find_cid_part(msg, cid):
    """The leaf part whose Content-ID matches the given cid reference, or None."""
    target = normalize_cid(cid)
    if not target:
        return None
    for part in msg.walk():
        if part.is_multipart():
            continue
        raw = part.get("Content-ID")
        if not raw:
            continue
        pid = normalize_cid(raw)
        if pid == target or pid.lower() == target.lower():
            return part
    return None


def open_part(part, idx):
    """Write a part's decoded payload to a temp file and open it with the OS."""
    name = os.path.basename(attachment_name(part, idx)) or f"attachment-{idx}"
    tmpdir = tempfile.mkdtemp(prefix="mail-view-att-")
    path = os.path.join(tmpdir, name)
    with open(path, "wb") as fh:
        fh.write(part.get_payload(decode=True) or b"")
    subprocess.run(["open", path], check=False)


def cmd_attach(msg, n):
    """Extract the nth attachment to a temp file and open it with the OS."""
    atts = attachment_parts(msg)
    if n < 1 or n > len(atts):
        sys.stderr.write(f"mail-view: no attachment {n}\n")
        sys.exit(1)
    open_part(atts[n - 1], n)


def cmd_attach_cid(msg, cid):
    """Extract the inline part a cid: reference points at and open it."""
    part = find_cid_part(msg, cid)
    if part is None:
        sys.stderr.write(f"mail-view: no attachment for cid {cid!r}\n")
        sys.exit(1)
    # Number it as it appears in the Attachments: block, for a sensible fallback
    # filename; cid parts normally carry their own filename anyway.
    atts = attachment_parts(msg)
    idx = atts.index(part) + 1 if part in atts else 0
    open_part(part, idx)


def cmd_parts(msg):
    avail = []
    if body_part(msg, "text/plain") is not None:
        avail.append("plain")
    if body_part(msg, "text/html") is not None:
        avail.append("html")
    return "\n".join(avail)


def main():
    if len(sys.argv) < 3:
        sys.stderr.write(__doc__ or "")
        sys.exit(2)

    action, raw = sys.argv[1], sys.argv[2]
    msg = load_msg(raw)

    if action == "parts":
        sys.stdout.write(cmd_parts(msg) + "\n")
        return

    if action == "render":
        mode = sys.argv[3] if len(sys.argv) > 3 else "plain"
        body = render_html(msg) if mode == "html" else render_plain(msg)
        if body is None:
            body = f"[mail-view: no {mode} part in this message]"
        out = header_block(msg) + "\n" + body
        att = attachment_lines(msg)
        if att:
            out = out.rstrip("\n") + "\n" + "\n".join(att) + "\n"
        sys.stdout.write(out)
        return

    if action == "attach":
        cmd_attach(msg, int(sys.argv[3]) if len(sys.argv) > 3 else 0)
        return

    if action == "attach-cid":
        cmd_attach_cid(msg, sys.argv[3] if len(sys.argv) > 3 else "")
        return

    sys.stderr.write(f"mail-view: unknown action {action!r}\n")
    sys.exit(2)


if __name__ == "__main__":
    main()
