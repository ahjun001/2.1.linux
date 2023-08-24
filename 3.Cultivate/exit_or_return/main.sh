#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=SC2034

set -euo pipefail

clear
DBG=echo\ -e
$DBG $'\nEntering '"${BASH_SOURCE[0]##*/}"$'\n'

STEP=8
case $STEP in
1) . ./sourced_or_not_1.sh ;&
2) . ./sourced_or_not_2.sh ;&
# 3) . ./sourced_or_not_3.sh ;&
4) . ./sourced_or_not_4.sh ;&
5) 
    SOURCED=1
. ./sourced_or_not_5.sh ;&
6) . ./sourced_or_not_6.sh ;&
7)
    SOURCED=1
    . ./sub.sh
    ;;
    8) . ./case1.sh;;
*) echo case is over;;
esac

$DBG $'\nExiting '"${BASH_SOURCE[0]##*/}"$'\n'
