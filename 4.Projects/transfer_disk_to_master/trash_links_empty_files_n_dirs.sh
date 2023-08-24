#!/usr/bin/env bash
# shellcheck disable=SC2034
set -euo pipefail

[[ -n ${__SOURCED__:=¨¨} ]] && {
    DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"
    [[ -d $DISK ]] || {
        echo -e "\n$DISK not accessible\n"
        exit 1
    }
}

DBG="${DBG:=echo}" # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]##*/}"

# Displaying what is about to be erased
Erase_my_l_or_exit() {
    : "$1 can be:
    symbolic_links
    hard_links
    empty_files
    empty_dirs
    "

    # if list non empty, suggest to delete the whole list
    if [[ ${#my_l[@]} != 0 ]]; then
        IFS=$'\n'
        echo "${my_l[*]}"
        read -rsn 1 -p $'\nPress \'n\' not to erase these '"$1"$'\n'

        if [[ $REPLY != 'n' ]]; then
            for d in "${my_l[@]}"; do rm -rv "$d"; done
        else
            echo 'Copying list in /tmp/'"$1"'.txt'
            IFS=$'\n'
            echo "${my_l[*]}" >'/tmp/'"$1"'.txt'
            echo $'Removing should be performed outside this script. Exiting ...\n'
            nemo '/tmp/'"$1"'.txt' &
            exit 1
        fi
    fi
    return 0
}

# remove symbolic links
mapfile -t -d $'\0' my_l < <(find "$DISK" -type l -print0)
Erase_my_l_or_exit 'symbolic_links'

# remove hard links, but keep at least one of the linked file
mapfile -t my_l < <(find "$DISK" -type f -links +1)

if [[ ${#my_l[@]} != 0 ]]; then
    IFS=$'\n'
    echo "${my_l[*]}"
    read -rsn 1 -p $'\nPress \'n\' not to erase all hardlinks but one\n'

    if [[ $REPLY != 'n' ]]; then
        find "$DISK" -type f -links +1 -print -delete
    else
        log_file=/tmp/hardlinks.txt
        echo 'Copying list in '"$log_file"
        IFS=$'\n'
        echo "${my_l[*]}" >"$log_file"
        echo $'Removing should be performed outside this script. Exiting ...\n'
        nemo "$log_file"
        exit 1
    fi
fi

# list all empty files on DISK
mapfile -t -d $'\0' my_l < <(find "$DISK" -type f -empty -print0)
Erase_my_l_or_exit 'empty_files'

# list all empty dirs on DISK
mapfile -t -d $'\0' my_l < <(find "$DISK" -type d -empty -print0)
Erase_my_l_or_exit 'empty_dirs'
