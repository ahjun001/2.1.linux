#!/usr/bin/env bash

set -euo pipefail

Usage_exit() {
    cat <<.

usage: ${0##*/} fetch / pull / push / status -s

.
    exit
}

[[ $# -lt 1 ]] && Usage_exit

CMD="$*"
find /home/perubu/Documents/Github -maxdepth 1 -mindepth 1 -type d ! -name '.*' \
    -exec sh -c '
    cd "$1"
    pwd 
    git '"$CMD"'
  ' sh {} \;

LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
echo FILE = "$FILE"
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
