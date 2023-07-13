#!/usr/bin/env bash

# 02_yt-dlp.sh
# Install pipx: pip Python utility that also takes care of the virtual environment

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if command is already installed
if command -v yt-dlp >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

pipx install yt-dlp >"$INSTALL_LOG" 2>&1
