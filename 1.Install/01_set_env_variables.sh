#!/usr/bin/env bash

set -euo pipefail

# export set environment, mainly ID = linuxmint / ubuntu / fedora
# shellcheck source=/dev/null
. /etc/os-release >/dev/null
export ID
export VERSION_CODENAME

# scripts & resources root directory, taken as reference when calling sub-scripts
# careful if script not in root (as for vim, nvim, code)
SOURCE_DIR=$(pwd)
export SOURCE_DIR

STENV_CONF=/usr/local/sbin/01_set_env_variables.conf
[[ -L $STENV_CONF ]] && STENV_CONF=/home/perubu/Documents/Github/3.c-install-n-utils/01_set_env_variables.conf

# unlocking exit on error so as to keep comment lines in 01_set_env_variables.conf
set +e
# all others, as defined in conf file
while read -r LINE; do
    declare "$LINE" 2>/dev/null
    export "${LINE%=*}" 2>/dev/null
done </usr/local/sbin/01_set_env_variables.conf
set -e
