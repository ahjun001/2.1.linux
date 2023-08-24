#!/usr/bin/env bash

${DBG:=echo} $'\nEntering '"${BASH_SOURCE[0]##*/}"

set -euo pipefail

if [[ "${SOURCED:=0}" == 1 ]]; then
   echo "Sourced"
else
   echo "Not sourced"
fi

echo SOURCED = "$SOURCED"

echo '    tty: ok; sourced: wrong'