#!/usr/bin/env bash

set -euo pipefail

echo $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

SRCE=/media/perubu/Toshiba_4TB/

[[ -d $SRCE ]] || {
    echo -e "\n$SRCE not accessible\n"
    exit 1
}
# copy dir tree
DEST=/home/perubu/Desktop/test
[[ -d $DEST ]] || {
    echo -e "\n$DEST not accessible\n"
    exit 1
}

# create non non canonically installed dirs
mkdir -p $DEST/non_canon_d
for i in {1..3}; do
    mkdir -p $DEST/non_canon_d/d"$i"/.venv
    mkdir -p $DEST/non_canon_d/d"$i"/nvm
    mkdir -p $DEST/non_canon_d/d"$i"/go
    mkdir -p $DEST/non_canon_d/d"$i"/__pycache__
done

# (re-)create some sizeable folders
time rsync -aqumP --no-links --min-size=100000 --max-size=200000 $SRCE $DEST
# q quiet
# m prune empty directory chains from file list

# include a lot of pdfs if needed
time rsync -aqumP --include='*.pdf' --include='*/' --exclude='*' --no-links $SRCE $DEST

# create a few links
mkdir -p $DEST/links_d
my_file=$DEST/'links_d/somefile with a blank in it'
fallocate -l 1024000 "$my_file"

for i in {1..3}; do
    # symbolic links
    ln -sf "$my_file" $DEST/links_d/'soft lnk'"$i"
    # hard links
    ln -f "$my_file" $DEST/links_d/'hard lnk'"$i"
done

# create a few empty files & dirs
mkdir -p $DEST/empty/empty_d{1..3}
touch $DEST/empty/empty_d{1..3}/f{1..2}

# create some ephemerals
for ((i = 0; i < 10; i++)); do
    ! read -r a && break
    mkdir -p $DEST/ephemerals/"$i"
    touch $DEST/ephemerals/"$i"/"$a".pdf
    touch $DEST/ephemerals/"$i"/"$a".docx
    touch $DEST/ephemerals/"$i"/"$a".xlsx
done <./03c_delete_ephemerals/03c_delete_ephemerals.txt
