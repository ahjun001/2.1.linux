#!/usr/bin/env bash
# recreate_tree_on_disk_to_be_emptied.sh
set -euo pipefail

# identifying master disk
MSTR="${MSTR:=/media/perubu/Toshiba_4TB}"
# MSTR=/home/perubu/Desktop/test

SKIP="${SKIP:=not}" # true or not, not to run commands that take too long

DBG="${DBG:=echo}"   # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]##*/}"

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"
[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

# Directory to store all books blindly collected by WeChat
VRAC="$DISK"/Documents/9.Lire/aa_lectures_en_vrac

# recreate directory tree on disk
rsync -au -f"+ */" -f"- *" "$MSTR"/ "$DISK"

# check that $VRAC exists
[[ -d $VRAC ]] || {
    echo "$VRAC" was not created properly, exiting ...
    exit 1
}
