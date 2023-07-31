#!/usr/bin/env bash
# shellcheck disable=

# 02_gimp.sh
# install gimp

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

# Exit if command is already installed
if command -v gimp >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; else return 0; fi
fi

case $ID in
fedora)
    sudo dnf install gimp
    ;;
linuxmint | ubuntu)
    sudo apt install gimp
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac
