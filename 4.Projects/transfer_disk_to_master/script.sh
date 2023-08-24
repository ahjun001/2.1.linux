#!/usr/bin/env bash

# set -euo pipefail

hello() { echo "Hello $1"; }

confirm() {
    echo $'confirm : Entering'
    REPLY=y
    read -rsn 1 -p $'Press "n" to return\n' REPLY
    [[ $REPLY == "n" ]] && return
    echo $'confirm : Have not returned yet'
}

confirm

echo 'End'


${__SOURCED__:+return}