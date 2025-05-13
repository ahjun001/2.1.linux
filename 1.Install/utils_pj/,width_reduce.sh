#!/usr/bin/env bash
# ,width_reduce.sh
# shellcheck disable=SC1087,SC2046

set -euo pipefail

DBG=: # : or 'echo'

cd /home/"$USER"/.local/share/Anki2/User\ 1/collection.media || exit
for file in *.jpg *.png *.gif *.jpeg *.webp; do
  $DBG "$file"
  # width=$(convert "$file[0]" -format '%w' info:)
  width=$(identify -format "%wx%h" "$file" | awk -F"x" '{print $1}')
  $DBG "width =" "$width"
  if [ "$width" -gt 340 ]; then
    mv "$file" "$file.tmp"
    ffmpeg -i "$file.tmp" -v 0 -vf scale=340:-1 "$file"
    # echo "$file width ="$(convert "$file[0]" -format '%w' info:)
    echo "$file width =" $(identify -format "%wx%h" "$file" | awk -F"x" '{print $1}')
    rm "$file.tmp"
  fi
done

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
