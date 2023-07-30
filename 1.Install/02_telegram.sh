#!/usr/bin/env bash

# 00_telegram.sh
# script short presentation

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG now in "${BASH_SOURCE[0]}" 

# Exit if program is already installed
PROGRAM=foo
# if command -v $PROGRAM >>"$INSTALL_LOG"; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi
if command -v $PROGRAM >>"$INSTALL_LOG"; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi

wget "https://telegram.org/dl/desktop/linux" -O /tmp/telegram.tar.xz
tar -xvf /tmp/telegram.tar.xz -C /tmp
sudo mv /tmp/Telegram /opt/
/opt/Telegram/Telegram
