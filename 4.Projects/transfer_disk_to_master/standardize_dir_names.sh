#!/usr/bin/env bash
set -euo pipefail

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"

[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

DBG="${DBG:=echo}" # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}"

# check max depth of directory tree
D1=$(echo "$DISK" | awk -F"/" 'NF > max {max = NF} END {print max}')
D2=$(find "$DISK" -type d | awk -F"/" 'NF > max {max = NF} END {print max}')
D=$((D2 - D1))
$DBG max depth of directory tree = "$D"

# replace spaces in directories names by _
# and . in dates by -
# for i in $(eval echo "{1..$D}"); do
for i in $(seq 1 "$D"); do
    find "$DISK" -maxdepth "$i" -type d | while read -r dir; do

        # replace spaces
        if echo "$dir" | grep -q ' '; then
            newdir=${dir//\. /.}
            newdir=${newdir// /_}
            mv -v --strip-trailing-slashes "$dir" "$newdir"
        else
            newdir=$dir
        fi

        # in dir names, replace . with - in dates
        lastdirname=$(basename "$newdir")
        if [[ $lastdirname == 20[0-9][0-9]* ]]; then
            pathto=${newdir%"$lastdirname"}
            if [[ $lastdirname == *\.* ]] && [[ $newdir == $pathto$lastdirname ]]; then
                cd "$pathto"
                mv -v "$newdir" "${lastdirname//./-}"
            fi
        fi

    done
done
