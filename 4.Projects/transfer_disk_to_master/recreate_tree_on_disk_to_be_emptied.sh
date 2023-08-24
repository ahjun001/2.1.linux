#!/usr/bin/env bash
set -euo pipefail

# identifying master disk
MSTR="${MSTR:=/media/perubu/Toshiba_4TB}"
# MSTR=/home/perubu/Desktop/test

SKIP="${SKIP:=not}" # true or not, not to run commands that take too long

DBG="${DBG:=echo}"   # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]##*/}"

$SKIP || {
    DISK=$MSTR
    ./standardize_dir_names.sh "$MSTR"
}

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"

[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

# recreate directory tree on disk
rsync -au -f"+ */" -f"- *" "$MSTR"/ "$DISK"

# check that $VRAC exists
[[ -d $VRAC ]] || {
    echo "$VRAC" was not created properly, exiting ...
    exit 1
}
