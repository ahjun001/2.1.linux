#!/usr/bin/env bash

# 02_tldr.sh
# display short info and use cases about bash commands

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if command is already installed
if command -v tldr >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

pipx install tldr >"$INSTALL_LOG" 2>&1