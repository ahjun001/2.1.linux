#!/usr/bin/env bash

set -euo pipefail

CWD="${BASH_SOURCE[0]%/*}/"

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

[[ $(pgrep -f nemo) ]] && pkill -f nemo

# sort keywords so that new ones can be easier added later
if $FAST; then
    KWDS="$CWD"/03c_delete_ephemerals_short.txt
else
    KWDS="$CWD"/03c_delete_ephemerals.txt
fi
sort -u "$KWDS" -o "$KWDS"

# remove pdfs whose name containing keyword in rogue dirs
# either trash or put pdfs back in their original place
mapfile -t dirs < <(Rogue_dirs)

# searching pdfs whose name contain keywords, one keyword at a time
while read -r k; do

    echo "$k"

    # make the list of files to be trashed
    trash_l=()

    # one rogue dir at a time:
    for dir in "${dirs[@]}"; do

        # add candidates for deletion in trash list

        while read -r file; do trash_l+=("$file"); done < <(find "$dir" -type f -iname "*$k*.pdf")

    done

    [[ ${#trash_l[@]} == 0 ]] && continue

    for f in "${trash_l[@]}"; do gio trash "$f"; done

    Clean_trash

done <"$KWDS"

# searching for *.docx, *.xlsx,
# make the list of files to be trashed
trash_l=()

# one L1 dir at a time
for dir in "${dirs[@]}"; do
    # add candidates for deletion in trash list
    # find "$dir" -type f
    while read -r file; do
        trash_l+=("$file")
    done < <(find "$dir" -type f \( \
        -iname "*.docx" -o \
        -iname "*.xlsx" -o \
        -iname "*.deb" -o \
        -iname "*.rpm" \
        \))
done

[[ ${#trash_l[@]} == 0 ]] && exit 0

for f in "${trash_l[@]}"; do gio trash "$f"; done

Clean_trash

exit 0
