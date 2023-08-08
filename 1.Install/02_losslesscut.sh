#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.linux/1.Install/01_set_env_variables.sh

$DBG now in "${BASH_SOURCE[0]}"

# Exit if program is already installed
PROGRAM=loselesscut
if command -v "$PROGRAM" >/dev/null; then
    $DBG "$0" "$PROGRAM" is already installed
    [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0
fi

case $ID in
fedora)
    $DBG -e "\n$PROGRAM not implemented in $ID\n"
    ;;
linuxmint | ubuntu)
    FILE=LosslessCut-linux-x64.tar.bz2
    TARFILE=/tmp/"$FILE"
    ICON=/opt/LosslessCut-linux-x64/losslesscut.svg
    set -x
    [[ -f $TARFILE ]] ||
        wget https://github.com/mifi/lossless-cut/releases/latest/download/"$FILE" -O "$TARFILE"

    # sudo tar -xvf "$TARFILE" -C /opt/

    [[ -f $ICON ]] ||
        sudo wget https://static.mifi.no/losslesscut.svg -O "$ICON"

    cat <<. | sed 's/^[[:blank:]]*//' >/home/perubu/Desktop/losslesscut.desktop
        [Desktop Entry]
        Name=losslesscut
        Exec=/opt/LosslessCut-linux-x64/losslesscut
        Comment=losslesscut
        Terminal=false
        Icon=/opt/LosslessCut-linux-x64/losslesscut.svg
        Type=Application
.

    $RUN /opt/LosslessCut-linux-x64/losslesscut
    ;;

*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac

# $RUN "$PROGRAM"
