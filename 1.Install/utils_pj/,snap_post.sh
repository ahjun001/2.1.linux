#!/usr/bin/env bash

# set -euo pipefail

echo "Latest relevant environment variables can be set with:"
echo "source /tmp/snapper/pj_snap.sh"

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && {
    echo "${0##*/}" $'only can be sourced\nExiting.'
    exit 1
}

# Run the snapper command and save the output number in PJ_SNAP_HOME_POST
PJ_SNAP_HOME_POST=$(sudo snapper -c home create --type post --pre-number "$PJ_SNAP_HOME_PRE" --description "$PJ_SNAP_DESCRIPTION" --cleanup-algorithm number --print-number)
export PJ_SNAP_HOME_POST

# Run the snapper command and save the output number in PJ_SNAP_ROOT_POST
PJ_SNAP_ROOT_POST=$(sudo snapper -c root create --type post --pre-number "$PJ_SNAP_ROOT_PRE" --description "$PJ_SNAP_DESCRIPTION" --cleanup-algorithm number --print-number)
export PJ_SNAP_ROOT_POST

# Ask if the user wants to run the status command for home
read -rn 1 -p "Do you want to run 'sudo snapper -c home status $PJ_SNAP_HOME_PRE..$PJ_SNAP_HOME_POST'? (y/n) "
case $REPLY in y | Y)
    sudo snapper -c home status "$PJ_SNAP_HOME_PRE".."$PJ_SNAP_HOME_POST"
    ;;
esac

# Ask if the user wants to run the status command for root
read -rn 1 -p "Do you want to run 'sudo snapper -c root status $PJ_SNAP_ROOT_PRE..$PJ_SNAP_ROOT_POST'? (y/n) "
case $REPLY in y | Y)
    sudo snapper -c root status "$PJ_SNAP_ROOT_PRE".."$PJ_SNAP_ROOT_POST"
    ;;
esac

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
