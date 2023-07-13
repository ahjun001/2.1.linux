#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh

$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

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

# sudo find "$DISK" -type d -name '.git' -print0 | xargs -0 rm -r 
# sudo find "$DISK" -type d -name '.idea' -print0 | xargs -0 rm -r 

# First was confirming before deletion, .git dirs require supersuser priviledges
# find all dirs and put in a list
# my_l=()

# for dir in "${delDirs[@]}"; do
#     while IFS= read -r -d '' f; do
#         my_l+=("$f")
#     done < <(find "$DISK" -type d -name "$dir" -print0)
# done

# Erase_my_l_or_exit 'non_canonically_installed_dirs'
