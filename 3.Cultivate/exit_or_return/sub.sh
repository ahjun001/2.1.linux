#!/usr/bin/env bash

${DBG:=echo} $'\nEntering '"${BASH_SOURCE[0]##*/}"

set -euo pipefail

# shellcheck disable=SC2016
echo $'$0 =\t\t' "${0#/home/perubu/Documents/Github/}"
echo 'BASH_SOURCE[0] =' "${BASH_SOURCE[0]#/home/perubu/Documents/Github/}"


if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
  echo "Not sourced"
else
  echo "Sourced" 
fi

# return 0  # can only return from a function or sourced script
[[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0