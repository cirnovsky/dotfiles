#!/bin/sh
# Launch the vim mail viewer (mail-view.vim) on a raw message from mutt.
#
# Bound in muttrc as:
#   macro index,pager e "<pipe-message>~/.mutt/mail-view.sh<enter><enter-command>source ~/.cache/mutt/mail-view-next.rc<enter>"
#
# mutt's <pipe-message> feeds the WHOLE raw message on stdin (pipe_decode unset,
# the default), which is what the viewer needs: the full MIME tree lets it decode
# parts, toggle text/plain <-> text/html, and inline cid: images for the browser.
#
# We stash stdin to a file first (so vim's stdin is free for the terminal) and
# reconnect vim to the controlling tty for its interactive UI.
#
# D/J/K (delete, next, prev) inside vim: vim can't drive mutt itself, so it
# writes the action to the $req fifo and blocks reading $rsp.  We turn the
# action into a `push` of the mutt function plus this macro again in $next,
# which the macro sources after we exit; mutt then pipes the message it lands on
# into a new instance of this script, which finds vim still waiting, overwrites
# $raw and answers on $rsp, and vim re-renders in place.  vim never restarts,
# and it draws on the terminal's main screen (t_ti/t_te emptied) so mutt's
# endwin() in between changes nothing visible.
dir="$(cd "$(dirname "$0")" && pwd)"
next="$HOME/.cache/mutt/mail-view-next.rc"
run="$HOME/.cache/mutt/mail-view/$(basename "$(tty < /dev/tty)")"
raw="$run/msg.eml" req="$run/req" rsp="$run/rsp" pidfile="$run/pid"
mkdir -p "$run"
cat > "$raw"

vpid="$(cat "$pidfile" 2>/dev/null)"
if [ -n "$vpid" ] && kill -0 "$vpid" 2>/dev/null; then
    echo load > "$rsp"                    # wake the vim waiting in MailViewMove()
else
    rm -f "$req" "$rsp"
    mkfifo "$req" "$rsp"
    vim -R --cmd 'set t_ti= t_te=' \
        -c "source $dir/mail-view.vim" \
        -c "let g:mailview_req = '$req' | let g:mailview_rsp = '$rsp'" \
        -c "call MailViewOpen('$raw')" \
        < /dev/tty > /dev/tty &
    echo $! > "$pidfile"
    vpid=$!
fi

read -r action < "$req"                   # until vim asks for something or quits
case "$action" in
    delete) fn=delete-message ;;          # $resolve then moves on to the next undeleted
    next)   fn=next-undeleted ;;
    prev)   fn=previous-undeleted ;;
    *)      rm -f "$pidfile"; : > "$next"
            while kill -0 "$vpid" 2>/dev/null; do sleep 0.01; done  # let vim leave the tty
            exit ;;
esac
printf 'push "<%s><pipe-message>%s<enter><enter-command>source %s<enter>"\n' \
    "$fn" "$dir/mail-view.sh" "$next" > "$next"
