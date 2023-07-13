#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

# collect all files 'staged.txt' in $DISK canonical dir tree
declare staged_txts=()
while read -r fullpath; do staged_txts+=("$fullpath"); done < <(find "$DISK" -type f -name 'staged.txt')

tmp_file=/tmp/some_file.txt
# collect all keywords in collected 'staged.txt' files, prepend with keyword length for further sorting
for f in "${staged_txts[@]}"; do
    while read -r k; do
        [[ $k == '' ]] && continue

        echo "${#k}"$'\t'"$k"$'\t'"${f/\/staged.txt/}" >>"$tmp_file"
    done <"$f"
done

# sort keyword dest-dir on decreasing keyword length and put in
sort -t $'\t' -k 1 -rn "$tmp_file" -o "$tmp_file" # n numerical sort

# reposition files from Calibre directory

# check https://stackoverflow.com/questions/29161323/how-to-keep-associative-array-order
