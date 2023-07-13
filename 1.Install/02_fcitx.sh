#!/usr/bin/env bash

# 02_fcitx.sh
# manages IME for Chinese input

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if command is already installed
if command -v fcitx >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

case $ID in
fedora)
    echo "$0 not implemented in $ID"
    ;;
linuxmint | ubuntu)
    sudo apt install fcitx fcitx-sunpinyin
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac
