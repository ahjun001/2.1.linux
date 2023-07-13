#!/usr/bin/env bash
set -euo pipefail

# select disk to be emptied, that is files to be placed in other dir on same disk
# DISK=/media/perubu/Toshiba_4T
[[ -d $DISK ]] || {
echo -e "\n$DISK not accessible\n"
exit 1
}
DISK=/home/perubu/Desktop/test

# select folder
SRCE=Downloads/books

declare -A keyDir
while read -r LINE; do keyDir+=([${LINE% *}]=${LINE#* }); done <keywords_dirs.txt
# for k in "${!keyDir[@]}"; do echo "$k" "${keyDir[$k]}"; done

afterOpenDirs=()
for file in "$DISK"/"$SRCE"/*; do
    for k in "${!keyDir[@]}"; do
        if grep -qi "$k" <<<"$file"; then
            destDir=$DISK/"${keyDir[$k]}"/staged
            mkdir -p "$destDir"
            rsync -a "$file" "$destDir"
            afterOpenDirs+=("$destDir")
        fi
    done
done
readarray -t afterOpenDirs <<<"$(for dir in "${afterOpenDirs[@]}"; do echo "$dir"; done | sort -u)"
for dir in "${afterOpenDirs[@]}"; do
    nemo "$dir"
done
