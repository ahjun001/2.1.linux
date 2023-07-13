#!/usr/bin/env bash

# set -eux

M_ROOT=/media/perubu/

# shellcheck source=/dev/null
[ -z "${ID}" ] && source /etc/os-release

case $ID in
fedora) M_ROOT="$/run/M_ROOT" ;;
linuxmint | ubuntu) true ;;
*) echo 'Should not happen' && exit 1 ;;
esac

DIRS=("${M_ROOT}"*)
echo 'Select one of the following : '
select SEL in "${DIRS[@]}"; do
    [[ -z $SEL ]] || break
done
echo "$SEL selected"

export SEL
