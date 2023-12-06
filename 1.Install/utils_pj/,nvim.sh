#!/usr/bin/env bash
# shellcheck disable=SC1087,SC2046
gnome-terminal --maximize -- nvim -c 'bro ol'
# terminator -mx nvim -c 'bro ol'
# konsole --fullscreen -e nvim -c 'bro ol'

LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
