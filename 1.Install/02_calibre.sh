#!/usr/bin/env bash

# 00_calibre.sh
# install calibre

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG now in "${BASH_SOURCE[0]}" 

# Exit if program is already installed
PROGRAM=calibre
# if command -v $PROGRAM >>"$INSTALL_LOG"; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi
if command -v $PROGRAM >>"$INSTALL_LOG"; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi

sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
