#!/usr/bin/env bash

set -euo pipefail

: '
based on names recognized in title
suggest filing directory in existing directory tree
or trash file
'

# : 'select disk to be inspected'
DISK=/media/perubu/Toshiba_4T
[[ -d $DISK ]] || {
echo -e "\n$DISK not accessible\n"
exit 1
}

# directory tree being emptied
tbCleanedDir=$DISK/staged/pdf

# default filing directory for pdf
fileDir=$DISK/Documents/9.Lire/Staged

# read pdf_trash substrings
trashs=()
while read -r trash; do trashs+=("$trash"); done <pdf_trash.txt

# read pdf_file substrings and dirs
declare -A filings=()
while read -r filing; do
    key=${filing% *}
    filingDir=${filing##* }
    filings+=([$key]="$filingDir")
done <pdf_filings.txt

# read pdf_file substrings

for file in "$tbCleanedDir"/*.pdf; do
    bfile=$(basename "$file")
    # possibly trash file
    for trash in "${trashs[@]}"; do
        if [[ $bfile == *trash* ]]; then
            rm -v file
        fi
    done
    # possibly file in designated directory
    for key in "${!filings[@]}"; do
        if [[ $bfile == *$key* ]]; then
            # check if the whole directory could be moved before moving a file
            nemo "${filings[$key]}" &
            read -r -s -n 1 -p $'Press any key to continue ...\n'
        fi
    done
    # do bank filings,
    # MGEN filings
    # staged
done
