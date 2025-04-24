#!/usr/bin/env bash

# /usr/local/bin/_restore_minimized_wins.sh

# Restore mimimized windows in workspace
# depends on xdotool (apt install xdotool) and wmctrl (apt install wmctrl)

WORKSPACE=$(xdotool get_desktop)
WINDOWS=$(wmctrl -l | awk "/ $WORKSPACE /" | cut -f1 -d' ')
for i in $WINDOWS; do wmctrl -ia "$i"; done

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
