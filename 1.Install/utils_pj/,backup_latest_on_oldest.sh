#!/usr/bin/env bash

: '
script to identify "latest" version between two externally
identical usb
todo: stat resulting file and identify which of usb1 and usb2 is latest
'

set -euo pipefail

#!/bin/bash

# Set the USB disk paths
usb1=/media/perubu/San_64GB_open1
usb2=/media/perubu/San_64GB_open

rsync -rnv --delete --exclude=lost+found $usb1/ $usb2 >diffs.txt

grep -v 'sending incremental file list' diffs.txt | grep -v 'sent'

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
