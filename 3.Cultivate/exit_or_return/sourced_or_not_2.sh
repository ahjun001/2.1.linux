#!/usr/bin/env bash

set -euo pipefail

echo '$- = ' $-


if [[ $- = *i* ]]; then
  echo "2: Script is being sourced."
else
  echo "2: Script is being run directly."
fi