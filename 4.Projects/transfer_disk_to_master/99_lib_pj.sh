#!/usr/bin/env bash
# shellcheck disable=SC2209,SC2034,SC2154

set -euo pipefail

# string comparison, ignore case
Icomp() {
    [[ "$(tr '[:upper:]' '[:lower:]' <<<"$1")" == "$(tr '[:upper:]' '[:lower:]' <<<"$2")" ]]
}

# Put del items in trash for review, then restore or delete
Clean_trash() {
    # close opened nemo instances, if any
    [[ $(pgrep -f nemo) ]] && pkill -f nemo

    # review items in Trash, one by one
    while true; do
        read -r t1 t2 < <(gio trash --list) || break
        nemo "$t1" "${t2%/*}"
    done
}

# Find all rogue directories, to empty and then delete
Rogue_dirs() {
    dirs="$(find "$DISK" -maxdepth 1 -type d \
        ! -name 'Documents' \
        ! -name 'Downloads' \
        ! -name 'Music' \
        ! -name 'Pictures' \
        ! -name 'Videos' |
        sed '1d')"
    echo "$dirs"
}
