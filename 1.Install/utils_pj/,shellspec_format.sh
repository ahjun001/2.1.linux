#!/usr/bin/env bash
set -euo pipefail

# Indent level
declare -i indent=0
declare -i shift=4

# Loop through each line
while read -r line; do
    if [[ $line =~ ^('It'|'Specify'|'Example'|'Context'|'Describe'|'ExampleGroup') ]]; then
        printf "%${indent}s%s\n" "" "$line"
        # Increase indent after keyword line
        indent=$((indent + shift))

    elif [[ $line =~ ^End$ ]]; then
        # Decrease indent before printing End
        indent=$((indent - shift))

        # Print End with lower indentation
        printf "%${indent}s%s\n" "" "$line"

    else
        # Print other lines with current indentation
        printf "%${indent}s%s\n" "" "$line"
    fi

done <<< \
    "$(xclip -selection clipboard -o)" |
    xclip -selection clipboard

[[ -S /usr/local/sbin/,shellspec_format.sh ]] ||
    sudo ln -fs ~/Documents/Github/2.1.linux/1.Install/utils_pj/,shellspec_format.sh /usr/local/sbin/,shellspec_format.sh
