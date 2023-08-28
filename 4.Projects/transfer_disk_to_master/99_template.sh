#!/usr/bin/env bash
# 99_template.sh
set -euo pipefail

SKIP="${SKIP:=not}" # true or not, not to run commands that take too long

DBG="${DBG:=echo}"   # 'echo' :  , print runtime infos
$DBG $'\n'"${BASH_SOURCE[0]##*/}"

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"
[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    return 1
}
