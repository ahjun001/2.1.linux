#!/usr/bin/env bash

${DBG:=echo} $'\nEntering '"${BASH_SOURCE[0]##*/}"

set -euo pipefail

# When included from shellspec, __SOURCED__ variable defined and script
# end here. The script path is assigned to the __SOURCED__ variable.
${__SOURCED__:=false} : || echo "Sourced"

echo __SOURCED__ = "$__SOURCED__"

# echo "${BASH_SOURCE[1]}"
basename "$0"
echo "$0"
