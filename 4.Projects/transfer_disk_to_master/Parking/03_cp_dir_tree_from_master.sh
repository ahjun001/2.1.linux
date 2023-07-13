#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

# DISK is the master, DEST the destination
DEST=/home/perubu/Desktop/test
# DEST=/home/perubu/My\ Passport\ Ultra

# remove empty dirs on DEST : they are not useful as they don't contains files to be saved
find $DEST -type d -empty -print -delete

# change to $DISK to get dirs and files relative path
cd "$DISK"

# recreate the master directory tree on DEST
find . -type d -print0 | sed 's/^.//' | xargs -0 -I{} mkdir -p "$DEST"/{}

# copy staged.txt files, containing indexes to classify dirs and files, on the new tree on DEST
find . -type f -name 'staged.txt' | sed 's/^.//' | xargs -I{} rsync -aPu "$DISK"/{} "$DEST"/{}

# shellcheck source=/dev/null
. ./03_collect_keywords_from_tree.sh
