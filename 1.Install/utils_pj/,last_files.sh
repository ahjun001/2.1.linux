#!/usr/bin/env bash
# /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,last_files.sh

Usage_exit() {
    cat <<.

Usage: ${0##*/} <adoc | txt | sh>

.
    exit
}

[[ $# -lt 1 ]] && Usage_exit

EXT="$*"

set -x
find "$HOME" \
    -path "$HOME/.config" -prune -o \
    -path "$HOME/.local" -prune -o \
    -path "$HOME/.xwechat" -prune -o \
    -path "$HOME/.vscode" -prune -o \
    -type f -name "*.$EXT" -printf '%TY-%Tm-%Td %TH:%TM %p\n' |
    sort -rn | head -10
set +x

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
