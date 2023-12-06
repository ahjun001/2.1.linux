#!/usr/bin/env bash
# ,nativefier_update.sh

set -euo pipefail

sudo npm update -g nativefier

[[ -L /usr/local/sbin/,nativefier_update.sh ]] ||
    sudo ln -fs ~/Documents/Github/2.1.linux/1.Install/utils_pj/,nativefier_update.sh /usr/local/sbin/,nativefier_update.sh

LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
