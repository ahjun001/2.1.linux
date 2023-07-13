#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

[[ $(pgrep -f nemo) ]] && pkill -f nemo

# for dir in Documents Pictures Videos Music; do
#     find "$DISK"/"$dir" -type d -empty |
#         while read -r d2; do
#             # echo "$d2" > "$d2"/stub.txt
#             echo "$d2"
#         done
# done

for dir in Documents Downloads Pictures Videos Music; do
    mapfile -t my_l < <(find "$DISK"/"$dir" -type d -empty)
done

echo "${my_l[@]}"
