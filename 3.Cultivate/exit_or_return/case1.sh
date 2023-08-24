#!/usr/bin/bash
set -euo pipefail

echo __SOURCED__ is not set
unset __SOURCED__
${__SOURCED__:+false}  : || return 0

echo __SOURCED__ is set
__SOURCED__=1
${__SOURCED__:+false}  : || return 0

echo has not returned yet
exit 0
