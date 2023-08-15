#!/usr/bin/env bash


[[ "$SHELL" == '/bin/bash' ]] && set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.linux/4.Projects/transfer_disk_to_master/00_commons.sh

$DBG $'\n'"$(basename "${BASH_SOURCE[0]}")"$'\n'

del_dirs=(
    .git
    .idea
    *venv*
    go
    nvm
    __pycache__
)

for del_dir in "${del_dirs[@]}"; do
    find "$DISK" -type d -name "$del_dir" -print0 | xargs -0r sudo rm -r
done
# for del_dir in "${del_dirs[@]}"; do
#     find "$DISK" -type d -empty -delete
# done
