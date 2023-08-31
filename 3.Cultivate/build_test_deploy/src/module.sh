#!/usr/bin/env bash
# src/module.sh

# shellcheck  disable=SC1090,1091
ROOT="$(cd "${BASH_SOURCE[0]%/*.sh}"/.. && pwd)" && . "$ROOT"/lib/environments.sh && cd "$ROOT" || exit 1
. "$ROOT"/lib/lib.sh

$DBG $'\n'"${BASH_SOURCE[0]#*/}"$'\n'


print_env