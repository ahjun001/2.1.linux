#!/usr/bin/env bash

# 02_shellspec.sh
# Install shellspec for testing

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

APP=shellspec
# Exit if command is already installed
if command -v "$APP"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; else return 0; fi
fi

if ! command -v "$APP"; then
    cd /tmp || exit
    if ! wget -O - https://git.io/shellspec | sh; then exit 1; fi
    cd "$SOURCE_DIR" || exit
fi
