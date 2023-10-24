#!/usr/bin/env bash
# standardize_dir_names.sh
set -euo pipefail

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"

[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

DBG="${DBG:=echo}" # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]##*/}"

# Function to replace spaces with underscores in directory names
replace_spaces() {
    find "$DISK" -type d -execdir rename 's/\. /./' {} +
    find "$DISK" -type d -execdir rename 's/ /_/g' {} +
}

# Function to replace dots with dashes in directory names starting with 20[0-9][0-9]
replace_dots_bak() {
    for dir in "$DISK"/20[0-9][0-9]*/; do
        echo dir = "$dir"
        new_dir="${dir/\./-}"
        mv "$dir" "$new_dir"
    done
}
replace_dots() {
    for dir in "$DISK"/20[0-9][0-9]*/; do
        dirname=$(basename "$dir")
        path=$(dirname "$dir")
        if [[ $dirname == *\.* ]] && [[ $dir == $path/$dirname/ ]]; then
            cd "$path"
            mv -v "$dir" "${dirname//./-}"
        fi
    done
}
# Main script
replace_spaces
replace_dots
