#!/usr/bin/env bash

# 02_install_printer_driver.sh
# if run from bash, install printer driver at TST
# if sourced and if not installed, then will installed

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG now in "$0"

if [[ "$0" == "${BASH_SOURCE[0]}" ]] ||
    ! dpkg-query -s printer-driver-fujixerox >"$INSTALL_LOG" ||
    ! dpkg-query -s printer-driver-cups-pdf >"$INSTALL_LOG"; then

    case $ID in
    fedora)
        echo "Not implemented on $ID"
        ;;
    linuxmint | ubuntu)
        sudo apt install printer-driver-cups-pdf printer-driver-fujixerox
        ;;
    *)
        echo "Distribution $ID not recognized, exiting ..."
        exit 1
        ;;
    esac
fi
