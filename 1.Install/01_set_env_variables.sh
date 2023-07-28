#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail

# export set environment, mainly ID = linuxmint / ubuntu / fedora
# shellcheck source=/dev/null
. /etc/os-release >/dev/null

export ID               #  linuxmint
export VERSION_CODENAME # vera

# scripts & resources root directory, taken as reference when calling sub-scripts
# careful if script not in root (as for vim, nvim, code)
SOURCE_DIR=$(pwd)
export SOURCE_DIR

# info verbose debug trace
DBG='echo' # 'echo' :

# lauch apps after install
RUN=; # ;  or :
