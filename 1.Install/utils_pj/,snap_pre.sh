#!/usr/bin/env bash
# ,snap_pre.sh

set -o pipefail # set -e not good because will get the terminal window to exit when script is sourced
# set u will cause prompt definition in inside shell to fail as well and script to exit

# Check if there is one and only one argument
[[ "$#" -ne 1 ]] && {
    echo "Usage: source ${0##*/} <description>"
    return 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "${0##*/}" $'only can be sourced\nExiting.'
    exit 1
fi

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
if "${BASH_SOURCE[0]}" == "${0}" ; then
    echo "${0##*/}" $'only can be sourced\nExiting.'
    return 1
fi
export PJ_SNAP_DESCRIPTION="$PJ_SNAP_DESCRIPTION"
export PJ_SNAP_HOME_PRE=$PJ_SNAP_HOME_PRE
export PJ_SNAP_ROOT_PRE=$PJ_SNAP_ROOT_PRE
.

# make a encapsulation in /usr/local/sbin to use in $PATH

FILE_IN_PATH=/usr/local/sbin/,snap_pre.sh
if [[ ! -f $FILE_IN_PATH ]]; then
    cat <<. | sudo tee "$FILE_IN_PATH" >/dev/null
#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
source /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,snap_pre.sh "\$1"
.
    sudo chmod +x "$FILE_IN_PATH"
fi
