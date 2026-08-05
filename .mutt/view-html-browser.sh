#!/bin/sh
# Read a full raw mail message on stdin, extract its HTML part, inline every
# cid:-referenced image as a base64 data: URI, write a self-contained .html to a
# stable temp file and open it in the default browser.
#
# Fed the WHOLE message (via mutt's <pipe-message>) rather than just the HTML
# part, because inline images live in sibling MIME parts and the HTML refers to
# them with cid: URLs that a browser can't resolve on its own.
#
# `open` returns immediately and mutt reaps its own temp files as soon as the
# viewer returns, so we write to a temp file mutt won't touch.
exec python3 "$(dirname "$0")/view-html-browser.py" "$@"
