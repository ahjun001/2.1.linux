#!/bin/bash

set -euo pipefail
echo $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

CWD="${0%/*}"

max_len=0
min_line=''

log_file=$CWD/removed_dupes.txt
rm -f "$log_file"
mapfile -t lines </dev/stdin
for line in "${lines[@]}"; do
    (("$max_len" < "${#line}")) && max_len="${#line}"
done
min_len="$max_len"

for line in "${lines[@]}"; do
    # if blank line, print previous line, reset min_len, min_line; and continue
    if [[ -z "$line" ]]; then
        # ls "$min_line" >>"$log_file"
        find / -type f -name "$min_line" >>"$log_file"
        echo >>"$log_file"
        min_len="$max_len"
        min_line=''
        continue
    fi

    # Get the length of the line
    len="${#line}"
    if (("$len" < "$min_len")); then
        rm -vf "$min_line" >>"$log_file"
        if [[ -f "$line" ]] && ! ((min_len == "$max_len")); then
            ln -sf "$line" "$min_line".lnk
        fi
        min_len=$len
        min_line=$line
    else
        rm -vf "$line" >>"$log_file"
        if [[ -f "$min_line" ]] && ! ((min_len == "$max_len")); then
            ln -sf "$min_line" "$line".lnk
        fi
    fi
done
