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
    for dir in */; do
        newdir=${dir//\. /.}
        newdir=${newdir// /_}
        mv -v --strip-trailing-slashes "$dir" "$newdir"
        mv "$dir" "$new_dir"
    done
}

# Function to replace dots with dashes in directory names starting with 20[0-9][0-9]
replace_dots() {
    for dir in 20[0-9][0-9]*/; do
        new_dir="${dir//./-}"
        mv "$dir" "$new_dir"
    done
}

# Main script
replace_spaces
replace_dots
