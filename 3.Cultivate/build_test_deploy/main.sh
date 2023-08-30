#!/usr/bin/env bash
# main.sh
# shellcheck disable=SC1091
ROOT="$(cd "${BASH_SOURCE[0]%/*.sh}" && pwd)" && . "$ROOT"/lib/environments.sh && cd "$ROOT" || exit 1

$DBG $'\n'"${BASH_SOURCE[0]#*/}"$'\n'

print_env

# shellcheck  disable=SC1091
. "$ROOT"/src/module.sh
