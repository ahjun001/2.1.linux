#!/usr/bin/env bash

# 02_nativefier.sh
# install nativefier, transforms websites into web apps

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if command is already installed
if command -v nativefier >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

sudo npm install nativefier -g

[[ $LAUNCH_APP = true ]] && (cd /tmp || exit) && nativefier -p linux -a x64 \
    -u 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Brave Chrome/89.0.4389.72 Safari/537.36' \
    https://youtube.com

[[ $LAUNCH_APP = true ]] && /tmp/YouTube-linux-x64/YouTube
