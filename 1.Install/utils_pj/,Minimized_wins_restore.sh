#!/usr/bin/env bash

# /usr/local/sbin/_restore_minimized_wins.sh

# Restore mimimized windows in workspace
# depends on xdotool (apt install xdotool) and wmctrl (apt install wmctrl)

WORKSPACE=$(xdotool get_desktop)
WINDOWS=$(wmctrl -l | awk "/ $WORKSPACE /" | cut -f1 -d' ')
for i in $WINDOWS; do wmctrl -ia "$i"; done

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
