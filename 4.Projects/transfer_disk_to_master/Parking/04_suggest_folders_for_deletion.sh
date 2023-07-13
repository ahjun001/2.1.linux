#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

[[ $(pgrep -f nemo) ]] && pkill -f nemo

# select destination folder, make sure it exists
DEST="$DISK"/Documents/9.Lire/aaaa_lectures_en_vrac/staged/
[[ -d $DEST ]] || mkdir -p "$DEST"

# move all epubs to $DEST
find "$DISK" -type d -iname "*WeChat*" |
    while read -r d; do
        find "$d" -type f -iname '*.epub*' -exec mv {} "$DEST" \;
    done

nemo "$DEST"

# under selected dir d1, open each sub-dir d2 that contains at leat one epub
find "$DISK" -type d -iname "*WeChat*" |
    while read -r d; do
        find "$d" -type f -iname '*.pdf' -exec gio trash {} \;
    done

# shellcheck source=/dev/null
# . ./01_clean_trash.sh
Clean_trash
