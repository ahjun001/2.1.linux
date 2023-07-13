#!/usr/bin/env bash

# 00_model.sh
# script short presentation

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if program is already installed
PROGRAM=foo
# if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi
if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi

case $ID in
fedora)
    echo "$PROGRAM not implemented in $ID"
    ;;
linuxmint | ubuntu)
    echo "$PROGRAM not implemented in $ID"
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac
