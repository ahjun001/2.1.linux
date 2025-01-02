#!/usr/bin/env bash
# ,sync_TPad_USB.sh
# Todo: better meld & rsync for home directories see further todo

set -euo pipefail

# Hardcoded flags, see Usage
# if [ "$#" -eq 0 ]; then set -- safe; fi

Usage() {
    cat <<.

    Usage: ${0##*/} mimi / safe / home
    after invite for sync command Yy yes Dd dry run

.
}

FOLDERS=(Desktop Documents Downloads Music Pictures Videos Public Templates)

Setup() {
    [[ $# == 1 ]] || {
        Usage && exit
    }

    case $1 in
    'mimi')
        HD=/mnt/BTRFS_HEAD/IHD_mimi
        UD=/run/media/perubu/USB_mimi
        ;;
    'safe')
        HD=/mnt/BTRFS_HEAD/IHD_safe
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
        [[ -d "${HD}" ]] || { echo -e "${HD} cannot be reached\nExiting ...\n" && return 1; }
        mount | grep "on $UD type" >/dev/null || { echo -e "$UD cannot be reached\nExiting ...\n" && return 1; }
    fi
}

Diff() {
    # read -rsn 1 -p $'Diff disks? [Yy] '
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
    read -rsn 1 -p $'\nMeld disks? [Yy] '
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
    read -rsn 1 -p $'\nRsync disks? [Yy] \n'
    case $REPLY in
    y | Y)
        if [[ "$1" == 'home' ]]; then
            for f in "${FOLDERS[@]}"; do
                printf "\n\n"
                set -x
                ls "${HD}/${f}"/
                set +x
                printf "\n"
                while true; do
                    echo -e "\nfolder $f:"
                    read -rsn 1 -p $'\nD dry run\nY rsync & next\nbreak & next? [DdYy]\n'
                    set -x
                    case $REPLY in
                    d | D)
                        rsync -anvuP --exclude='WeChat Files' "${HD}/${f}"/ "$UD/${f}"
                        echo
                        rsync -anvuP --exclude='WeChat Files' "${UD}/${f}"/ "$HD/${f}"
                        ;;
                    y | Y)
                        rsync -avuP --exclude='WeChat Files' "${HD}/${f}"/ "$UD/${f}"
                        echo
                        rsync -avuP --exclude='WeChat Files' "${UD}/${f}"/ "$HD/${f}"
                        break
                        ;;
                    *)
                        echo 'next folder'
                        break
                        ;;
                    esac
                    set +x
                done
            done
        else

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
        fi
        ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

# Todo: for homne loop here over Document directories

Setup "$@"
Diff "$@"
Meld "$@"
Rsync "$@"
Diff "$@"

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
