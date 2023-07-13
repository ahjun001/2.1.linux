#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

[[ $(pgrep -f nemo) ]] && pkill -f nemo

gio trash --list | while read -r l; do
    read -ra words <<<"$l"
    nemo "${words[0]}" "${words[1]%/*}"
done
