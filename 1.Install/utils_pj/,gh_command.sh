#!/usr/bin/env bash

set -euo pipefail

Usage() {
    cat <<.

usage: ${0##*/} fetch / pull / push

.
}

[[ $# == 1 ]] || {
    Usage
    exit
}

CMD="$1"
find /home/perubu/Documents/Github -maxdepth 1 -mindepth 1 -type d ! -name '.*' \
    -exec sh -c '
    cd "$1"
    pwd 
    git '"$CMD"'
  ' sh {} \;
