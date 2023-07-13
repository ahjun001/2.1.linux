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

cd $DISK/$SRCE

for file in *.epub *.pdf; do
    if [[ $file == *by* ]]; then
        author="${file##*by }"
        author="${author% (*}"
        author="${author% [*}"
        author="${author%.epub}"
        author="${author%.pdf}"
        author="${author// /_}"
        echo "$author"
    fi
done
# nemo .
