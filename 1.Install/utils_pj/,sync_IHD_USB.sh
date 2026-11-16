#!/usr/bin/env bash
# /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,sync_IHD_USB.sh
# This compare files in the HD ~/Documents/2bkup and either SanDisk_work_32G or SanDisk_home_32G
set -euo pipefail

# Skip normal execution if we're being sourced for tests
[[ "${BASH_SOURCE[0]}" != "$0" ]] && return

# Hardcoded flags, see Usage
if [ "$#" -eq 0 ]; then set -- work ; fi

Usage() {
    cat <<EOF
    Usage: ${0##*/} work / home
EOF
}

HD=$HOME/Documents/2bkup
UD=/run/media/$USER/SanDisk_"$1"_32G

[[ $# == 1 ]] || {
    Usage && return 1
}

[[ -d "${HD}" ]] || { echo -e "${HD} cannot be reached\nExiting ...\n" && return 1; }
[[ -d "${UD}" ]] || { echo -e "${UD} cannot be reached\nExiting ...\n" && return 1; }

Diff() {
    echo
    set -x
    diff -r "$HD"/ "$UD"/ | tail || :
    set +x
    echo
}

Rsync() {
    while true; do
        read -rsn 1 -p $'\nDry run or just rsync & exit? [Dd]\n'
        # set -x
        case $REPLY in
        d | D)
            rsync -anuP --exclude='.Trash-1000/' --exclude='lost+found' "$HD"/ "$UD"
            echo
            rsync -anuP --exclude='.Trash-1000/' --exclude='lost+found' "$UD/" "$HD/"
            ;;
        *)
            rsync -auP --exclude='.Trash-1000/' --exclude='lost+found' "$HD"/ "$UD"
            echo
            rsync -auP --exclude='.Trash-1000/' --exclude='lost+found' "$UD/" "$HD/"
            break
            ;;
        esac
        # set -x
    done
}

# Main
Diff
meld "$HD"/ "$UD"/
Rsync
Diff

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
