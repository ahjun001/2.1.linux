#!/usr/bin/env bash

${DBG:=echo} $'\nEntering '"${BASH_SOURCE[0]##*/}"

set -euo pipefail

if [[ -n "${SOURCED:=1}" ]]; then
  echo "Sourced"
else
  echo "Not sourced"
fi

echo "${BASH_SOURCE[1]}"
basename "$0"
echo "$0"

echo '    tty: wrong; sourced: ok'