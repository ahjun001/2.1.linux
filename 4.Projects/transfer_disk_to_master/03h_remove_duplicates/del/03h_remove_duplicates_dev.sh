#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

CWD="${0%/*}"
HEAD="$VRAC"

# build a testing environment
$TEST && {
    HEAD="$DISK"/testing_dir
    mkdir -p "$HEAD"
    rsync -a "$VRAC"/ "$HEAD"
}

# register size of directory before operation
SIZE_BEF=$(du -sc "$HEAD" | tail -n 1 | awk '{print $1}')

# remove dupes from within $VRAC and get total size
fdupes -r "$HEAD" | "$CWD"/rem_dupes.sh

SIZE_AFT=$(du -sc "$HEAD" | tail -n 1 | awk '{print $1}')
REDUC=$(echo "scale=5; ($SIZE_BEF - $SIZE_AFT) / $SIZE_BEF * 100" | bc)
printf "Directory reduction of %.2f%%\n" "$REDUC"

fdupes -r "$HEAD"
