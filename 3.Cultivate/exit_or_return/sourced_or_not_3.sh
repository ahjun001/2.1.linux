#!/usr/bin/env bash

${DBG:=echo} $'\nEntering '"${BASH_SOURCE[0]##*/}"

set -euo pipefail

echo FUNCNAME = "$FUNCNAME"

if [ -n "$FUNCNAME" ]; then
  echo "Sourced" 
else
  echo "Not sourced"
fi