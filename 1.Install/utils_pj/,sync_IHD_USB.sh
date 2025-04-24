#!/usr/bin/env bash
# ,sync_TPad_USB.sh
set -euo pipefail

# Skip normal execution if we're being sourced for tests
[[ "${BASH_SOURCE[0]}" != "$0" ]] && return

# Hardcoded flags, see Usage
# if [ "$#" -eq 0 ]; then set -- home; fi

Usage() {
    cat <<EOF
    Usage: ${0##*/} mimi / safe / home
EOF
}

FOLDERS=(Desktop Documents Downloads Music Pictures Videos Public Templates)

Setup() {
    [[ $# == 1 ]] || {
        Usage && return 1
    }

    case $1 in
    'mimi')
        HD=$HOME/Documents/IHD_mimi
        UD=/run/media/$USER/USB_mimi
        ;;
    'safe')
        HD=$HOME/Documents/IHD_safe
        UD=/run/media/$USER/USB_safe
        ;;
    'home')
        HD=$HOME
        UD=/run/media/$USER/USB_home
        ;;
    *) Usage && return 1 ;;
    esac

    # Check if HD exists for desktop case
    if [[ "$1" == "home" ]]; then
        for f in "${FOLDERS[@]}"; do
            [[ -d "${HD}/${f}" ]] || { echo -e "${HD}/${f} cannot be reached\nExiting ...\n" && return 1; }
            mkdir -p "$UD/$f"
        done
    else
        [[ -d "${HD}" ]] || { echo -e "${HD} cannot be reached\nExiting ...\n" && return 1; }
        [[ -d "${UD}" ]] || { echo -e "${UD} cannot be reached\nExiting ...\n" && return 1; }
    fi
}

Diff() {
    set -x
    diff -r "$HD"/ "$UD"/ || :
    set +x
}

Compare() {
    if [[ "$1" == 'home' ]]; then
        for f in "${FOLDERS[@]}"; do
            dolphin --new-window --split --select "${UD}/${f}" "${HD}/${f}"
        done
    else
        meld "$HD"/ "$UD"/
    fi
}

Rsync() {
    while true; do
        read -rsn 1 -p $'\nDry run or just rsync & exit? [Dd]\n'
        set -x
        case $REPLY in
        d | D)
            rsync -anvuP --exclude='.Trash-1000/' "$HD"/ "$UD"
            echo
            rsync -anvuP --exclude='.Trash-1000/' "$UD/" "$HD/"
            ;;
        *)
            rsync -avuP --exclude='.Trash-1000/' "$HD"/ "$UD"
            echo
            rsync -avuP --exclude='.Trash-1000/' "$UD/" "$HD/"
            break
            ;;
        esac
        set -x
    done
}

# Main
Setup "$@"
if [[ ! "$1" == 'home' ]]; then Diff "$@"; fi
Compare "$@"
if [[ ! "$1" == 'home' ]]; then
    Rsync "$@"
    Diff "$@"
fi

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
