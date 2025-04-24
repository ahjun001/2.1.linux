#!/usr/bin/env bash
# ,nativefier_update.sh

set -euo pipefail

sudo npm update -g nativefier

[[ -L /usr/local/bin/,nativefier_update.sh ]] ||
    sudo ln -fs ~/Documents/Github/2.1.linux/1.Install/utils_pj/,nativefier_update.sh /usr/local/bin/,nativefier_update.sh

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
