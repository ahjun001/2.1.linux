#!/usr/bin/env bash

xclip -o |
    sed 's/{{c.:://g' |
    sed 's/:://g' |
    sed 's/}}//g' |
    xclip -i -selection clipboard

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
