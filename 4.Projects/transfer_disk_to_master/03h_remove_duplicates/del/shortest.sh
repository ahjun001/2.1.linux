#!/bin/bash

set -euo pipefail

: '
This script reads input from  stdin  and processes each line to keep the file in each group with the shortest path.
Finally, it prints the shortest path for each group.
You can use this script with the  fdupes  command like this:
fdupes -r /path/to/directory | ./shortest_path.sh
'
max_len=0
min_line=''

mapfile -t lines <./vrac.txt
for line in "${lines[@]}"; do
    (("$max_len" < "${#line}")) && max_len="${#line}"
done
min_len="$max_len"

for line in "${lines[@]}"; do
    # if blank line, print previous line, reset min_len, min_line; and continue
    if [[ -z "$line" ]]; then
        echo "$min_line"
        min_len="$max_len"
        min_line=''
        continue
    fi

    # Get the length of the line
    len="${#line}"
    if (("$len" < "$min_len")); then
        min_len=$len
        min_line=$line
    fi
done
