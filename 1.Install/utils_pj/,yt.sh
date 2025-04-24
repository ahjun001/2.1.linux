#!/usr/bin/env bash
#set -euo pipefail
: ' utility to edit youtube link taken from right click in
videos tab and write a yt-dlp command that works '

# todo: test if yt-dlp is installed

MY_L=$1
yt-dlp https://youtu.be/"${MY_L#*=}"

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
