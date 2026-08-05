#!/bin/sh
# Launch the vim mail viewer (mail-view.vim) on a raw message from mutt.
#
# Bound in muttrc as:
#   macro index <return> "<pipe-message>~/.mutt/mail-view.sh<enter>"
#
# mutt's <pipe-message> feeds the WHOLE raw message on stdin (pipe_decode unset,
# the default), which is what the viewer needs: the full MIME tree lets it decode
# parts, toggle text/plain <-> text/html, and inline cid: images for the browser.
#
# We stash stdin to a temp .eml first (so vim's stdin is free for the terminal),
# reconnect vim to the controlling tty for its interactive UI, then clean up.
dir="$(dirname "$0")"
raw="$(mktemp -t mutt-mail-XXXXXX).eml"
trap 'rm -f "$raw"' EXIT INT TERM
cat > "$raw"

vim -R \
    -c "source $dir/mail-view.vim" \
    -c "call MailViewOpen('$raw')" \
    < /dev/tty > /dev/tty
