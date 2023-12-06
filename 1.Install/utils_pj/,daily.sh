#!/usr/bin/env bash

set -euo pipefail
clear

ping -q -c 1 -w 1 google.com || echo Ping google.com unsuccessful
cat <<.


.
,width_reduce.sh &
cat <<.


.

# set environment: ID
# shellcheck source=/dev/null
[[ -n ${ID+foo} ]] || . /etc/os-release

case $ID in
fedora) sudo dnf -y update ;;
linuxmint | ubuntu) sudo apt update -y && sudo apt upgrade -y ;;
*) echo "Should not happen" && exit 1 ;;
esac
cat <<.


.
case $ID in
linuxmint | ubuntu) sudo yt-dlp -U ;;
fedora) ;;
*) echo "Should not happen" && exit 1 ;;
esac

LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
