#!/usr/bin/env bash
# ,sync_TPad_USB.sh

set -euo pipefail

Usage() {
    cat <<.

    Usage: ${0##*/} mimi / safe

.
}

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
    *) Usage && exit ;;
    esac

    mount | grep "on $HD type" >/dev/null || (echo -e $"$HD" $'cannot be reached\nExiting ...\n' && return 1)
    mount | grep "on $UD type" >/dev/null || (echo -e $"$UD" $'cannot be reached\nExiting ...\n' && return 1)
}

Diff() {
    read -rsn 1 -p $'Diff disks [Yy] or press any other key to bypass \n'
    case $REPLY in
    y | Y)
        set -x
        diff -r $HD/ $UD/ || :
        set +x
        ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

Meld() {
    read -rsn 1 -p $'Meld disks [Yy] or press any other key to bypass \n'
    case $REPLY in
    y | Y) meld $HD/ $UD/ ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

Kompare() {
    read -rsn 1 -p $'Kompare disks [Yy] or press any other key to bypass \n'
    case $REPLY in
    y | Y) kompare $HD/ $UD/ ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

Rsync() {
    read -rsn 1 -p $'Rsync disks [Yy] or press any other key to bypass \n'
    case $REPLY in
    y | Y)
        set -x
        rsync -avu $HD/ $UD
        rsync -avu $UD/ $HD
        set +x
        ;;
    *)
        echo 'bypassed'
        return
        ;;
    esac
}

Setup "$@"
Diff
Meld
Kompare
Rsync
Diff
