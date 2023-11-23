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
# Function to replace dots with dashes in directory names starting with 20[0-9][0-9]
replace_spaces() {
    find "$DISK" -depth -type d -execdir prename 's/\. /./' {} \;
    find "$DISK" -depth -type d -print0 | xargs -0 -I{} prename 's/ /_/' "{}"
}

replace_dots() {
    for dir in "$DISK"/20[0-9][0-9]*; do
        dirname=$(basename "$dir")
        path=$(dirname "$dir")
        if [[ "$dirname" == *.* ]] && [[ "$dir" == "$path/$dirname" ]]; then
            mv "$dir" "${dir//./-}"
        fi
    done
}

# Main script
mkdir -p "$DISK/2021.01-01.test"
mkdir -p "$DISK/2021.02.02.test"
replace_spaces
replace_dots
find "$DISK" -maxdepth 1 -type d | grep -q "2021"
