#!/usr/bin/env bash
# shellcheck disable=SC2209,SC2034,SC2154

set -euo pipefail

DISK=/home/perubu/Desktop/test
# DISK=/media/perubu/Toshiba_4TB
# DISK=/media/perubu/Blueend_BckUp

[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

# use DBG to print runtime infos
DBG=echo
# DBG=:

# use TEST && NOT to run extra commands or functions
# particularly building testing environments
TEST=true
# TEST=false

# use FAST not to run commands that take too long
FAST=true
# FAST=false

# Directory to store all books blindly collected by WeChat
VRAC="$DISK"/Documents/9.Lire/aa_lectures_en_vrac

# identifying and cleaning master disk
# MSTR=/home/perubu/Desktop/test
MSTR=/media/perubu/Toshiba_4TB

# string comparison, ignore case
Icomp() {
    [[ "$(tr '[:upper:]' '[:lower:]' <<<"$1")" == "$(tr '[:upper:]' '[:lower:]' <<<"$2")" ]]
}

# Displaying what is about to be erased
Erase_my_l_or_exit() {
    : "$1 can be:
    symbolic_links
    hard_links
    empty_files
    empty_dirs
    "

    # if list non empty, suggest to delete the whole list
    if [[ ${#my_l[@]} != 0 ]]; then
        IFS=$'\n'
        echo "${my_l[*]}"
        read -rsn 1 -p $'\nPress \'n\' not to erase these '"$1"$'\n'

        if [[ $REPLY != 'n' ]]; then
            for d in "${my_l[@]}"; do rm -rv "$d"; done
        else
            echo 'Copying list in /tmp/'"$1"'.txt'
            IFS=$'\n'
            echo "${my_l[*]}" >'/tmp/'"$1"'.txt'
            echo $'Removing should be performed outside this script. Exiting ...\n'
            nemo '/tmp/'"$1"'.txt' &
            exit 1
        fi
    fi
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
