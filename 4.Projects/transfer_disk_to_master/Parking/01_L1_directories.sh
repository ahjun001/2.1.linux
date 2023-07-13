#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh

# Level 1, L1 directories to remove pdfs whose name contain keywords
# pdfs to be later kept should be moved to DMPV - Documents Downloads Music Pictures Videos
find "$DISK" -maxdepth 1 -type d \
    ! -name 'Documents' \
    ! -name 'Downloads' \
    ! -name 'Music' \
    ! -name 'Pictures' \
    ! -name 'Videos' |
    sed '1d'

# This will return a string with each directory on a new line
# If an array is needed use the following:
# while read -r dir; do dirs_a+=("$dir"); done<<<"$(./01_L1_directories.sh)"
