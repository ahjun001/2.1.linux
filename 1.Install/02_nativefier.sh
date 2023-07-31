#!/usr/bin/env bash

# 02_nativefier.sh
# install nativefier, transforms websites into web apps

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

# Exit if command is already installed
if command -v nativefier >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; else return 0; fi
fi

sudo npm install nativefier -g

$RUN  (cd /tmp || exit) && nativefier -p linux -a x64 \
    -u 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Brave Chrome/89.0.4389.72 Safari/537.36' \
    https://youtube.com

$RUN  /tmp/YouTube-linux-x64/YouTube
