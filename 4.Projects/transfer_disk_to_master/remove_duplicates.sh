#!/usr/bin/env bash
# remove_duplicates.sh

# use DBG to print runtime infos
DBG="${DBG:=echo}" # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]##*/}"

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"
[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    return 1
}

# identifying master disk
# MSTR="$MSTR"
MSTR="${MSTR:=/tmp/mstr_dir}" && mkdir -p "$MSTR"

PGM=${BASH_SOURCE[0]##*/}

Usage() {
    cat <<.
$PGM
    usage: $PGM -d -m -- 
    m scanning both disk and master, automatically keeping file on master
    d scanning only disk, reviewing cases individually
.
}

fdupes_clean_both() {
    # Initialize an empty array to hold the current group of duplicates
    declare -a CURRENT_GROUP

    # Read the fdupes results file line by line
    while IFS= read -r LINE; do
        # If the line is not empty, add it to the current group
        if [[ -n $LINE ]]; then
            CURRENT_GROUP+=("$LINE")
        else
            # If the line is empty, we've reached the end of a group
            # Check if any of the files in the group are in "$MSTR"/
            IN_MSTR=false
            for file in "${CURRENT_GROUP[@]}"; do
                if [[ $file == "$MSTR"/* ]]; then
                    IN_MSTR=true
                    break
                fi
            done

            # If one of the files is in "$MSTR"/, delete the duplicates in "$DISK"/
            # Otherwise, add the group to fdupes_review.txt
            if $IN_MSTR; then
                for file in "${CURRENT_GROUP[@]}"; do
                    if [[ $file == "$DISK"/* ]]; then
                        rm "$file"
                    fi
                done
            else
                printf '%s\n' "${CURRENT_GROUP[@]}" >>fdupes_review.txt
                printf '\n' >>fdupes_review.txt
            fi

            # Clear the current group
            CURRENT_GROUP=()
        fi
    done

    # Handle the last group if the file doesn't end with a blank line
    if [[ ${#CURRENT_GROUP[@]} -ne 0 ]]; then
        IN_MSTR=false
        for file in "${CURRENT_GROUP[@]}"; do
            if [[ $file == "$MSTR"/* ]]; then
                IN_MSTR=true
                break
            fi
        done

        if $IN_MSTR; then
            for file in "${CURRENT_GROUP[@]}"; do
                if [[ $file == "$DISK"/* ]]; then
                    rm "$file"
                fi
            done
        else
            printf '%s\n' "${CURRENT_GROUP[@]}" >>fdupes_review.txt
            printf '\n' >>fdupes_review.txt
        fi
    fi

}
fdupes_review_disk() {
    fdupes -r "$DISK"
}

${__SOURCED__:+return}

[[ $# == 0 ]] && Usage && exit 1
while getopts :dm F; do
    case $F in
    m)
        fdupes -rA "$DISK" "$MSTR" >fdupes_results.txt
        : '
        r recursive search
        A exclude hidden files (directories ?)
        '
        fdupes_clean_both <fdupes_results.txt
        ;;
    d) fdupes_review_disk;;
    *) Usage && exit 1 ;;
    esac
done
