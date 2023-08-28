#!/usr/bin/env bash
# remove_duplicates.sh

# use DBG to print runtime infos
DBG="${DBG:=echo}" # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]##*/}"

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"
[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    return 1
}

# identifying master disk
# MSTR=/media/perubu/Toshiba_4TB
MSTR="${MSTR:=/tmp/mstr_dir}" && mkdir -p "$MSTR"

PGM=${BASH_SOURCE[0]##*/}

Usage() {
    cat <<.
$PGM
    usage: $PGM -d -m -- 
    m scanning both disk and master, automatically keeping file on master
    d scanning only disk, reviewing cases individually
.
}
[[ $# == 0 ]] && Usage && exit 1
while getopts :dm F; do
    case $F in
    d) fdupes "$DISK" && exit 0 ;;
    m) fdupes "$DISK" "$MSTR" && exit 0 ;;
    *) Usage && exit 1 ;;
    esac
done
