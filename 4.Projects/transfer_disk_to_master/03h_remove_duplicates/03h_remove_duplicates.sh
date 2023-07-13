#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

CWD="${BASH_SOURCE[0]%/*}"

# Remove_dupes_under_dir() {
#     # register size of directory before operation
#     SIZE_BEF=$(du -sc "$1" | tail -n 1 | awk '{print $1}')

#     # remove dupes from within $VRAC and get total size
#     fdupes -r "$1" | "$CWD"/rem_dupes.sh

#     SIZE_AFT=$(du -sc "$1" | tail -n 1 | awk '{print $1}')
#     REDUC=$(echo "scale=5; ($SIZE_BEF - $SIZE_AFT) / $SIZE_BEF * 100" | bc)
#     printf "Directory reduction of %.2f%%\n" "$REDUC"

#     fdupes -r "$1"
# }

# if $TEST; then
#     # build or update testing environment
#     HEAD="$DISK"/testing_dir
#     mkdir -p "$HEAD"
#     rsync -a "$VRAC"/ "$HEAD"

#     Remove_dupes_under_dir "$HEAD"
# else

#     Remove_dupes_under_dir "$VRAC"
#     Remove_dupes_under_dir "$DISK"

# fi

if $TEST; then
    # build or update testing environment
    # HEAD="$DISK"/testing_dir
    # mkdir -p "$HEAD"
    # rsync -a "$VRAC"/ "$HEAD"
    # "$CWD"/rem_dupes.sh "$HEAD"

    mkdir -p "$DISK"/test/testing_dir
    fallocate -l 1111000 "$DISK"/test/testing_dir/file.txt
    
    declare -a HEAD=('testing_0_dir' 'testing_1_dir' 'testing_2_dir')
    for i in "${!HEAD[@]}"; do
        # echo "$i"
        # echo "${HEAD[i]}"
        mkdir -p "$DISK"/test/"${HEAD[i]}"
        fallocate -l "$((i+1))"024000 "$DISK"/test/"${HEAD[i]}"/file"$i".txt
        cp "$DISK"/test/"${HEAD[i]}"/file"$i".txt "$DISK"/test/"${HEAD[i]}"'/file'"$((i+1))".txt
        ln -fs "$DISK"/test/"${HEAD[i]}"/file"$i".txt "$DISK"/test/"${HEAD[i]}"/file"$i".lnk
        ln -f "$DISK"/test/"${HEAD[i]}"'/file'"$((i+1))".txt "$DISK"/test/"${HEAD[i]}"'/file'"$((i+2))".txt
        ln -f  "$DISK"/test/testing_dir/file.txt "$DISK"/test/"${HEAD[i]}"/file.txt
    done
    # ln -f "$DISK"/test/testing_0_dir/file1.txt "$DISK"/test/testing_1_dir/file3.txt
    # ln -fs "$DISK"/test/testing_0_dir/file1.txt "$DISK"/test/testing_1_dir/file3.lnk
    # ln -fs "$DISK"/test/testing_0_dir/file2.txt "$DISK"/test/testing_2_dir/file3.lnk

    # tree "$DISK"/test
    baobab  "$DISK"/test

    fdupes -dNHr "$DISK"/test
    # -dN delete with no prompt
    # -H delete also hard links
    # -r recurse in directory

    # TODO: see how to treat symb links
    # treat several disks together
    
    # "$CWD"/rem_dupes.sh "$DISK"/test
    baobab  "$DISK"/test
else
    "$CWD"/rem_dupes.sh "$VRAC"
    "$CWD"/rem_dupes.sh "$DISK"
fi
