#!/usr/bin/env bash

set -euo pipefail

: '
Clone a list of repositories from github account
Suggestion: 
(i) clone github.com/ahjun001/ahjun001 in /tmp or ~/Documents/Github
(ii) edit ghb_repos_list.txt so that it corresponds with repos in Github
(iii) run
'

REPOS=./ghb_repos_list.txt

DEST_DIR=/home/perubu/Documents/Github
mkdir -p $DEST_DIR

# sort entries and make sure they are unique
sort -uo $REPOS $REPOS

# remove blank lines, add a blank line at the end so that the last line is also processed
# shellcheck disable=SC1003
sed -i -e '/^[[:space:]]*$/d' -e '$a\' $REPOS

# Clone each repository
while IFS= read -r REPO; do
    [[ -d $DEST_DIR/$REPO ]] && continue
    echo "Cloning $REPO..."
    git clone "https://github.com/ahjun001/$REPO" $DEST_DIR/"$REPO"
done <$REPOS
echo "All repositories cloned successfully!"
