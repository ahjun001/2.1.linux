#!/usr/bin/env bash

# 02_shellspec.sh
# Install shellspec for testing

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

program=shellspec
# Exit if command is already installed
if command -v "$program" >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

if ! command -v "$program"; then
    cd /tmp || exit
    if ! wget -O - https://git.io/shellspec | sh; then exit 1; fi
    cd "$SOURCE_DIR" || exit
fi
