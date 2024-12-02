#!/usr/bin/env bash
# ,sync_TPad_USB.sh

set -euo pipefail

# Hardcoded flags, see Usage
# if [ "$#" -eq 0 ]; then set -- home; fi

Usage() {
    cat <<.

    Usage: ${0##*/} mimi / safe / home

.
}

FOLDERS=(Documents Downloads Music Pictures Videos Public Templates)

Setup() {
    [[ $# == 1 ]] || {
        Usage && exit
    }

    case $1 in
    'mimi')
        HD=/mnt/TPad_mimi
        UD=/run/media/perubu/USB_mimi
        ;;
    'safe')
        HD=/mnt/TPad_safe
        UD=/run/media/perubu/USB_safe
        ;;
    'home')
        HD=/home/perubu
        UD=/run/media/perubu/USB_home
        ;;
    *) Usage && exit ;;
    esac

    # Check if HD exists for desktop case
    if [[ "$1" == "home" ]]; then
        for f in "${FOLDERS[@]}"; do
            [[ -d "${HD}/${f}" ]] || { echo -e "${HD}/${f} cannot be reached\nExiting ...\n" && return 1; }
            if mount | grep "on $UD type" >/dev/null; then
                mkdir -p "$UD/$f"
            else
                echo -e "$UD cannot be reached\nExiting ...\n" && return 1
            fi
        done
    else
        mount | grep "on $HD type" >/dev/null || { echo -e "$HD cannot be reached\nExiting ...\n" && return 1; }
        mount | grep "on $UD type" >/dev/null || { echo -e "$UD cannot be reached\nExiting ...\n" && return 1; }
    fi

}

Diff() {
    # read -rp "Diff disks? [Yy] "
    local REPLY=y
    case $REPLY in
    y | Y)
        if [[ "$1" == 'home' ]]; then
            for f in "${FOLDERS[@]}"; do
                set -x
                diff -r "${HD}/${f}"/ "$UD/$f"/ || :
                set +x
            done
        else
            set -x
            diff -r "$HD"/ "$UD"/ || :
            set +x
        fi
        ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

Meld() {
    read -rp "Meld disks? [Yy] "
    case $REPLY in
    y | Y)
        if [[ "$1" == 'home' ]]; then
            for f in "${FOLDERS[@]}"; do
                meld "${HD}/${f}"/ "$UD/$f"/
            done
        else
            meld "$HD"/ "$UD"/
        fi
        ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

Rsync() {
    read -rp "Rsync disks? [Yy] "
    case $REPLY in
    y | Y)
        if [[ "$1" == 'home' ]]; then
            for f in "${FOLDERS[@]}"; do
                printf "\n\n"
                set -x
                ls "${HD}/${f}"/
                set +x
                printf "\n"
                read -rp "Rsync ${f}? [Yy]"
                case $REPLY in
                y | Y)
                    rsync -avu --progress "${HD}/${f}"/ "$UD/$f"
                    rsync -avu --progress "${HD}/${f}"/ "$UD/$f"
                    ;;
                *)
                    echo 'next folder'
                    ;;
                esac
            done
        else
            rsync -avu --progress --exclude='.Trash-1000/' "$HD"/ "$UD"
            rsync -avu --progress --exclude='.Trash-1000/' "$UD/" "$HD/"
        fi
        ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

Setup "$@"
Diff "$@"
Meld "$@"
Rsync "$@"
Diff "$@"

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
