#!/usr/bin/env bash

wl-paste |
    sed 's/{{c.:://g' |
    sed 's/:://g' |
    sed 's/}}//g' |
    wl-copy

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
