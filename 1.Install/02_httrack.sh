#!/usr/bin/env bash

# 02_httrack.sh
# install httrack, copy websites to computer & browse locally

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG now in "$0"

# Exit if command is already installed
if command -v httrack >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; else return 0; fi
fi

case $ID in
fedora) sudo dnf install httrack ;;
linuxmint | ubuntu) sudo apt install httrack ;;
*) echo "Distribution $ID not recognized, exiting ..." && exit 1 ;;
esac
