#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh

$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

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
