#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

# find "$DISK" -type d -iname 'WeChat?Files'
readarray -t wc_l < <(find "$DISK" -type d -iname 'WeChat?Files')

for wc in "${wc_l[@]}"; do
    # Find FileStorage, usually a sub/sub directory with path being hard to predict
    read -r fs < <(find "$wc" -type d -name FileStorage)
    find "$fs"/File -type f -exec rsync -a --remove-source-files {} "$VRAC" \;
done

for wc in "${wc_l[@]}"; do
    find "$wc" -type f \( -name '*.epub' -o -name '*.pdf' \)
done
