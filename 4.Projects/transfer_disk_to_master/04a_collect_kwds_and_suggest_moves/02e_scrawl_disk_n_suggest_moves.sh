#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

[[ $(pgrep -f nemo) ]] && pkill -f nemo

KWDS='./02e_collect_kwds_and_suggest_moves/02e_master_keywords_n_dirs.txt'

# searching pdfs whose name contain keywords, one keyword at a time
while read -r k d; do

    echo "$k"
    # make the list of files to be moved
    move_l=()

    # one L1 dir at a time
    # for dir in "${dirs[@]}"; do
    while read -r dir; do

        # add candidates for deletion in move list
        while read -r file; do
            move_l+=("$file")
        done < <(find "$dir" -type f -iname "*$k*")

        # done <<<"$(./01_L1_directories.sh)"
    done < <(Rogue_dirs)

    set +u
    [[ ${#move_l} == 0 ]] && continue
    set -u

    # if target directory does not exist on target drive, create it
    TARGET_D="$d"/staged
    [[ -d $TARGET_D ]] || mkdir -p "$TARGET_D"

    # check if not empty, possibly houseclean by spawning nemo
    [[ $(find "$TARGET_D" -type d -empty) == "$TARGET_D" ]] || nemo "$TARGET_D"

    for f in "${move_l[@]}"; do mv "$f" "$TARGET_D"; done

    nemo "$TARGET_D"

    # house cleaning
    [[ $(find "$TARGET_D" -type d -empty) == "$TARGET_D" ]] && rm -r "$TARGET_D"
done <$KWDS
