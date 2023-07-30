#!/usr/bin/env bash

set -euo pipefail

echo FUNCNAME = "$FUNCNAME"

if [ -n "$FUNCNAME" ]; then
  echo "Sourced" 
else
  echo "Not sourced"
fi