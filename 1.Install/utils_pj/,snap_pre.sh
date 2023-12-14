#!/usr/bin/env bash
# ,snap_pre.sh

set -o pipefail # set -e not good because will get the terminal window to exit when script is sourced
# set u will cause prompt definition in inside shell to fail as well and script to exit

# Check if there is one and only one argument
[[ "$#" -ne 1 ]] && {
    echo "Usage: source ${0##*/} <description>"
    return 1
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && {
    echo "${0##*/}" $'only can be sourced\nExiting.'
    return 1
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

# save snapshot values so that they can be used in a different terminal window if needed
mkdir -p /tmp/snapper
cat <<. >/tmp/snapper/pj_snap.sh
#!/usr/bin/env bash
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && {
    echo "${0##*/}" $'only can be sourced\nExiting.'
    return 1
}
export PJ_SNAP_DESCRIPTION="$PJ_SNAP_DESCRIPTION"
export PJ_SNAP_HOME_PRE=$PJ_SNAP_HOME_PRE
export PJ_SNAP_ROOT_PRE=$PJ_SNAP_ROOT_PRE
.