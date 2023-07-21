#!/usr/bin/env bash

# 00_calibre.sh
# install calibre

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if program is already installed
PROGRAM=calibre
# if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi
if command -v $PROGRAM >>"$INSTALL_LOG"; then exit 0; fi

sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
