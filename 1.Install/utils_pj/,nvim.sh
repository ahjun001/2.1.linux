#!/usr/bin/env bash
# shellcheck disable=SC1087,SC2046
gnome-terminal --maximize -- nvim -c 'bro ol'
# terminator -mx nvim -c 'bro ol'
# konsole --fullscreen -e nvim -c 'bro ol'

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
