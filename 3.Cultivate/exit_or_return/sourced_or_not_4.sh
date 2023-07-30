#!/usr/bin/env bash

set -euo pipefail

if [[ "${SOURCED:=0}" == 1 ]]; then
   echo "Sourced"
else
   echo "Not sourced"
fi

echo SOURCED = "$SOURCED"
