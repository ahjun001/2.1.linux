#!/usr/bin/env bash

# 02_fcitx.sh
# manages IME for Chinese input

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

# Exit if command is already installed
if command -v fcitx >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; else return 0; fi
fi

case $ID in
fedora)
    echo -e "\n$0 not implemented in $ID\n"
    ;;
linuxmint | ubuntu)
    sudo apt install fcitx fcitx-sunpinyin
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac
