#!/usr/bin/env bash
# src/module.sh

# shellcheck  disable=SC1091
ROOT="$(cd "${BASH_SOURCE[0]%/*.sh}"/.. && pwd)" && . "$ROOT"/lib/environments.sh && cd "$ROOT" || exit 1

$DBG $'\n'"${BASH_SOURCE[0]#*/}"$'\n'

print_env