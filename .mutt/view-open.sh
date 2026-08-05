#!/bin/sh
# Copy a mail part to a stable temp file and open it with the macOS default app.
#
# mutt deletes its own temp file as soon as the viewer command returns, and `open`
# returns immediately — so we copy to a file mutt won't reap before the app reads
# it. mutt also strips the attachment's real name, so `open` has no extension to
# route on; we rebuild one from the MIME type ($2, passed via mailcap's %t) so the
# right app launches (Calendar for .ics, Preview for images, etc.).
#
# Usage: view-open.sh <tmpfile> <mime/type>
src="$1"
mime="$2"

case "$mime" in
  image/jpeg)                    ext=jpg ;;
  image/svg+xml)                 ext=svg ;;
  text/calendar)                 ext=ics ;;
  text/plain)                    ext=txt ;;
  application/msword)            ext=doc ;;
  application/vnd.openxmlformats-officedocument.wordprocessingml.document) ext=docx ;;
  application/vnd.ms-excel)      ext=xls ;;
  application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)       ext=xlsx ;;
  application/vnd.ms-powerpoint) ext=ppt ;;
  application/vnd.openxmlformats-officedocument.presentationml.presentation) ext=pptx ;;
  application/zip)               ext=zip ;;
  application/octet-stream|"")   ext="" ;;  # unknown — open extension-less, best effort
  */*)                           ext="${mime##*/}" ;;  # e.g. application/pdf -> pdf, image/png -> png
  *)                             ext="" ;;
esac

if [ -n "$ext" ]; then
  tmp="$(mktemp -t mutt-open-XXXXXX).$ext"
else
  tmp="$(mktemp -t mutt-open-XXXXXX)"
fi
cat "$src" > "$tmp"
exec open "$tmp"
