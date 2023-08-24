#!/usr/bin/env bash

${DBG:=echo} $'\nEntering '"${BASH_SOURCE[0]##*/}"

set -euo pipefail

echo '$- = ' $-


if [[ $- = *i* ]]; then
  echo "2: Script is being sourced."
else
  echo "2: Script is being run directly."
fi
echo '    tty: ok; sourced: wrong'