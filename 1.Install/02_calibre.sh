#!/usr/bin/env bash

# 00_calibre.sh
# install calibre

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

# Exit if APP is already installed
APP=calibre
# if command -v $APP >>"$INSTALL_LOG"; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi
if command -v $APP >>"$INSTALL_LOG"; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi

sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
