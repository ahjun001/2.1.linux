#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh

$DBG $'\n'"$(basename "${BASH_SOURCE[0]}")"$'\n'

delDirs=(
    .git
    .idea
    *venv*
    go
    nvm
    __pycache__
)

for dir in "${delDirs[@]}"; do
    find "$DISK" -type d -name "$dir" -print0 | xargs -0r sudo rm -r 
done