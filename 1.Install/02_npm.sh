#!/usr/bin/env bash

# 02_npm.sh
# install nodeJS & npm, pre-requisites for nativefier -- which transforms websites into web apps

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if command is already installed
if command -v npm >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

case $ID in
fedora)
    sudo dnf install npm
    ;;
linuxmint | ubuntu)
    sudo apt install npm
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac

[[ $LAUNCH_APP = true ]] && npm --version
