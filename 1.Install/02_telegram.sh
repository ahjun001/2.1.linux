#!/usr/bin/env bash

# 00_telegram.sh
# script short presentation

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if program is already installed
PROGRAM=foo
# if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi
if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi

wget "https://telegram.org/dl/desktop/linux" -O /tmp/telegram.tar.xz
tar -xvf /tmp/telegram.tar.xz -C /tmp
sudo mv /tmp/Telegram /opt/
/opt/Telegram/Telegram
