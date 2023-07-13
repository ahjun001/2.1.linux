#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

# Usage
PGM=${0##*/}
Usage() {
    cat <<.
$PGM                will treat the disk defined in 01_commons.sh
$PGM <other_disk>   operates on disk as indicated

ex: $PGM /home/perubu/Desktop/test

In directory names, $PGM will replace:
- spaces everywhere except for Calibre directories
- . with - in dates
.
}

case $# in
0) $TEST && Usage ;;
1) $DBG using "$PGM" with DISK = "$DISK" ;;
*)
    echo "$PGM" : too many arguments. Exiting ...
    exit 1
    ;;
esac

# check max depth of directory tree
D=$(find "$DISK" -type d | awk -F"/" 'NF > max {max = NF} END {print max}')
$DBG max depth of directory tree = "$D"

# replace spaces in directories names by _
# and . in dates by -
# for i in $(eval echo "{1..$D}"); do
for i in $(seq 1 "$D"); do
    find "$DISK" -maxdepth "$i" -type d | while read -r dir; do

        # replace spaces everywhere except for Calibre
        # if [[ $dir == *" "* ]] && ! [[ $dir == *'Calibre Library'* ]]; then
        if echo "$dir" | grep -q ' ' && ! [[ $dir == *'Calibre Library'* ]]; then
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
