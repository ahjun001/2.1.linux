#!/usr/bin/env bash

set -euo pipefail

# LC_All=zh_CN.UTF8 WINEPREFIX="/home/perubu/.wine" wine "/home/perubu/.wine/drive_c/Program Files/Tencent/WeChat/WeChat.exe"
LC_All=zh_CN.UTF8 wine "/home/perubu/.wine/drive_c/Program Files/Tencent/WeChat/WeChat.exe"

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
