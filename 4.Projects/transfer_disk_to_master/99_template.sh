#!/usr/bin/env bash
set -euo pipefail

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"
# DISK=/home/perubu/
# DISK=/media/perubu/Toshiba_4TB
# DISK=/media/perubu/Blueend_BckUp

[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

# identifying master disk
MSTR="${MSTR:=/media/perubu/Toshiba_4TB}"
# MSTR=/home/perubu/Desktop/test

RVW="${RVW:=true}"   # true or not , review what is about to be deleted
TEST="${TEST:=true}" # true or not, run extra commands or functions
SKIP="${SKIP:=true}" # true or not, not to run commands that take too long
DBG="${DBG:=echo}"   # 'echo' :  , print runtime infos

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}"
