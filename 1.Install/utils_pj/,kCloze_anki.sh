#!/usr/bin/env bash

wl-paste |
    sed '/\[sound:/{
    N
    N
    s/\(.*\)\[sound:\(.*\]\)\n\(.*\)\n\(.*\)/{{c::\1::[sound:\2\n\3\n\4}}/
}' |
    wl-copy

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
