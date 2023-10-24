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

[[ -S /usr/local/sbin/,gh_command.sh ]] || sudo ln -fs ~/Documents/Github/2.1.linux/1.Install/utils_pj/,gh_command.sh /usr/local/sbin/,gh_command.sh
