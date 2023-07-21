#!/usr/bin/env bash

# 02_httrack.sh
# install httrack, copy websites to computer & browse locally

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if command is already installed
if command -v httrack >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

case $ID in
fedora) sudo dnf install httrack ;;
linuxmint | ubuntu) sudo apt install httrack ;;
*) echo "Distribution $ID not recognized, exiting ..." && exit 1 ;;
esac
