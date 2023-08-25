#!/usr/bin/env bash
# erase_non_canonically_installed_dirs.sh
set -euo pipefail

DISK=${DISK:=/tmp/test_dir} && mkdir -p "$DISK"

DBG=${DBG:=echo}
$DBG $'\n'"$(basename "${BASH_SOURCE[0]}")"$'\n'

del_dirs=(
    .idea
    .git
    *venv*
    go
    nvm
    __pycache__
)

for del_dir in "${del_dirs[@]}"; do
    find "$DISK" -type d -name "$del_dir" -print0 | xargs -0r sudo rm -r
done

    find "$DISK" -type d -empty -delete
