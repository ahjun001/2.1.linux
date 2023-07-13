#!/usr/bin/env bash

# 02_install_printer_driver.sh
# if run from bash, install printer driver at TST
# if sourced and if not installed, then will installed

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

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
