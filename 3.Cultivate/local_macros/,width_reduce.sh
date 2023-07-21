#!/usr/bin/env bash
# shellcheck disable=SC1087,SC2046

set -euo pipefail

DBG=: # : or 'echo'

dpkg -l imagemagick  > /dev/null || (sudo apt update && sudo apt install imagemagick)

cd /home/perubu/.local/share/Anki2/pj/collection.media || exit
for file in *.jpg *.png *.gif *.jpeg *.webp; do
  $DBG "$file"
  width=$(convert "$file[0]" -format '%w' info:)
  $DBG "width =" "$width"
  if [ "$width" -gt 340 ]; then
    mv "$file" "$file.tmp"
    ffmpeg -i "$file.tmp" -v 0 -vf scale=340:-1 "$file"
    echo "$file width ="$(convert "$file[0]" -format '%w' info:)
    rm "$file.tmp"
  fi

done
