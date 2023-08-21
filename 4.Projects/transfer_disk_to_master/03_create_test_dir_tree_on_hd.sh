#!/usr/bin/env bash

set -euo pipefail

echo $'\n'"$(basename "${BASH_SOURCE[0]}")"$'\n'

SRCE=/media/perubu/Toshiba_4TB/

[[ -d $SRCE ]] || {
    echo -e "\n$SRCE not accessible\n"
    exit 1
}
# copy dir tree
DISK=/home/perubu/Desktop/test
[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

# create non non canonically installed dirs
mkdir -p $DISK/non_canon_d
for i in {1..3}; do
    mkdir -p $DISK/non_canon_d/d"$i"/.venv
    mkdir -p $DISK/non_canon_d/d"$i"/nvm
    mkdir -p $DISK/non_canon_d/d"$i"/go
    mkdir -p $DISK/non_canon_d/d"$i"/__pycache__
done

# (re-)create some sizeable folders
time rsync -aqumP --no-links --min-size=100000 --max-size=200000 $SRCE $DISK
# q quiet
# m prune empty directory chains from file list

# include a lot of pdfs if needed
time rsync -aqumP --include='*.pdf' --include='*/' --exclude='*' --no-links $SRCE $DISK

# create a few links
mkdir -p $DISK/links_d
my_file=$DISK/'links_d/somefile with a blank in it'
fallocate -l 1024000 "$my_file"

for i in {1..3}; do
    # symbolic links
    ln -sf "$my_file" $DISK/links_d/'soft lnk'"$i"
    # hard links
    ln -f "$my_file" $DISK/links_d/'hard lnk'"$i"
done

# create a few empty files & dirs
mkdir -p $DISK/empty/empty_d{1..3}
touch $DISK/empty/empty_d{1..3}/f{1..2}

# create some ephemerals
for ((i = 0; i < 10; i++)); do
    ! read -r a && break
    mkdir -p $DISK/ephemerals/"$i"
    touch $DISK/ephemerals/"$i"/"$a".pdf
    touch $DISK/ephemerals/"$i"/"$a".docx
    touch $DISK/ephemerals/"$i"/"$a".xlsx
done <./03c_delete_ephemerals/03c_delete_ephemerals.txt
