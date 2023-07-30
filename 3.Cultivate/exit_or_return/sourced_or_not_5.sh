#!/usr/bin/env bash

# set -euo pipefail

if [[ -n "${SOURCED}" ]]; then
  echo "Sourced"
else
  echo "Not sourced"
fi

echo "${BASH_SOURCE[1]}"
basename "$0"
echo "$0"
