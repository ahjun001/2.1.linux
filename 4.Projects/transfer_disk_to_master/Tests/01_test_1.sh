#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\n'"$(basename "${BASH_SOURCE[0]}")"$'\n'

echo $#
# [[ $# == ]]