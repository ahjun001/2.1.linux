#!/usr/bin/env bash

# 00_telegram.sh
# script short presentation

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

# Exit if APP is already installed
APP=foo
# if command -v $APP; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi
if command -v $APP; then [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0; fi

wget "https://telegram.org/dl/desktop/linux" -O /tmp/telegram.tar.xz
sudo tar -xvf /tmp/telegram.tar.xz -C /opt/
/opt/Telegram/Telegram
