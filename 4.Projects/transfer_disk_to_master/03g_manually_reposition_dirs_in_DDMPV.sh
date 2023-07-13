#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

# delete all empty files and directories that would have resulted from previous operations
find "$DISK" -type f -empty -delete -print
find "$DISK" -type d -empty -delete -print

# manually reposition other folders
while read -r DIR; do ! [[ $DIR == "$DISK" ]] && nemo "$DIR"; done < <(
    find "$DISK" -maxdepth 1 -type d |
        sed '/Documents/d' |
        sed '/Downloads/d' |
        sed '/Music/d' |
        sed '/Pictures/d' |
        sed '/Videos/d'
)
