#!/usr/bin/env bash

set -euo pipefail

# Check if there is one and only one argument
if [ "$#" -ne 1 ]; then
    echo "Usage: source ${0##*/} <description>"
    exit 1
fi


[[ "${BASH_SOURCE[0]}" == "${0}" ]] && {
    echo "${0##*/}" $'only can be sourced\nExiting.';
    exit 1
}

# Save the description in PJ_SNAP_DESCRIPTION
PJ_SNAP_DESCRIPTION=$1
export PJ_SNAP_DESCRIPTION

# Run the snapper command and save the output number in PJ_SNAP_HOME_PRE
PJ_SNAP_HOME_PRE=$(sudo snapper -c home create --type pre --print-number --description "$PJ_SNAP_DESCRIPTION" --cleanup-algorithm number)
export PJ_SNAP_HOME_PRE

# Run the snapper command and save the output number in PJ_SNAP_ROOT_PRE
PJ_SNAP_ROOT_PRE=$(sudo snapper -c root create --type pre --print-number --description "$PJ_SNAP_DESCRIPTION" --cleanup-algorithm number)
export PJ_SNAP_ROOT_PRE

LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
