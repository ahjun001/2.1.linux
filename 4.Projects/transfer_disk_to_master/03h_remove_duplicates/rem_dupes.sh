#!/bin/bash
# shellcheck disable=SC2034

set -euo pipefail

CWD="${0%/*}"

max_len=0
min_line=''

log_file=$CWD/removed_dupes_log.txt
rm -f "$log_file"

# substituting arguments with variables
case "$#" in
0) dir1=/home/perubu/Desktop/test/test ;;
1) dir1="$1" ;;
2) dir2="$2" ;;
3) dir3="$3" ;;
4) dir4="$4" ;;
*) echo ;; # of arguments needs to be extended, exiting; exit;;
esac

# register size of directory before operation
SIZE_BEF=$(du -sc "$dir1" | tail -n 1 | awk '{print $1}')

# run fdupes and store result in lines
mapfile -t lines < <(fdupes -r "$dir1")
# echo "${lines[*]}"

for line in "${lines[@]}"; do
    (("$max_len" < "${#line}")) && max_len="${#line}"
done
min_len="$max_len"

for line in "${lines[@]}"; do
    # if blank line, print previous line, reset min_len, min_line; and continue
    if [[ -z "$line" ]]; then
        if [[ "$min_line" == '' ]]; then echo >>"$log_file"; else ls "$min_line" >>"$log_file"; fi
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

# get resulting directory size and print result
SIZE_AFT=$(du -sc "$dir1" | tail -n 1 | awk '{print $1}')

REDUC=$(echo "scale=5; 100 * ( $SIZE_AFT / $SIZE_BEF  -  1 ) " | bc)
printf "Directory reduction of %.2f%%\n" "$REDUC"

# check that there no dupes remain
fdupes -r "$dir1"
