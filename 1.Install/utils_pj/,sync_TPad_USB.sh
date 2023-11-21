#!/usr/bin/env bash

set -euo pipefail

Usage_exit() {
    cat <<.

Usage: ${0##*/} mimi / safe

.
    exit
}

[[ $# == 1 ]] || Usage_exit

case $1 in
'mimi')
    HD=/mnt/TPad_mimi
    UD=/run/media/perubu/USB_mimi
    ;;
'safe')
    HD=/mnt/TPad_safe
    UD=/run/media/perubu/USB_safe
    ;;
*)
    Usage_exit
    ;;
esac

mount | grep "on $HD type" >/dev/null || (echo -e $"$HD" $'cannot be reached\nExiting ...\n' && exit 1)
mount | grep "on $UD type" >/dev/null || (echo -e $"$UD" $'cannot be reached\nExiting ...\n' && exit 1)

set -x
diff -r $HD/ $UD/ || :
set +x

read -rsn 1 -p "Ctrl-C or press any key to run meld ..."

meld $HD/ $UD/ 

read -rsn 1 -p "Ctrl-C or press any key to run kompare ..."

kompare $HD/ $UD/ 

read -rsn 1 -p "Ctrl-C or press any key to sync disks ..."

set -x
rsync -avu $HD/ $UD
rsync -avu $UD/ $HD
set +x

diff -r $HD/ $UD/ || :
