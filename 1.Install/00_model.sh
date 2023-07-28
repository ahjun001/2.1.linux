#!/usr/bin/env bash

# 00_model.sh
# script short presentation

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if program is already installed
PROGRAM=foo
# if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi
if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi

case $ID in
fedora)
    $DBG -e "\n$PROGRAM not implemented in $ID\n"
    ;;
linuxmint | ubuntu)
    $DBG -e "\n$PROGRAM not implemented in $ID\n"
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac
