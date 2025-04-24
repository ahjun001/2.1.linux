#!/usr/bin/env bash
# ,snap_pre.sh

set -o pipefail # set -e not good because will get the terminal window to exit when script is sourced

# set u will cause prompt definition in inside shell to fail as well and script to exit

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo -e "\n${0##*/}" $'only can be sourced\nExiting.\n'
    exit 1
fi

# Check if there is one and only one argument
[[ "$#" -ne 1 ]] && {
    echo -e "\nUsage: source ${0##*/} <description>\n"
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then exit 1; else return 1; fi
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
cat <<. >/tmp/snapper/snap_pre_post_env.sh
#!/usr/bin/env bash
# /tmp/snapper/snap_pre_post_env.sh

if [[ "\${BASH_SOURCE[0]}" == "\${0}" ]]; then
    cat <<EOF

/tmp/snapper/,snap_pre_post_env.sh can only be sourced
Exiting.

EOF
    exit 1
fi

export PJ_SNAP_DESCRIPTION="$PJ_SNAP_DESCRIPTION"
export PJ_SNAP_HOME_PRE=$PJ_SNAP_HOME_PRE
export PJ_SNAP_ROOT_PRE=$PJ_SNAP_ROOT_PRE

.

# echo PJ_SNAP_DESCRIPTION = "$PJ_SNAP_DESCRIPTION"
# echo PJ_SNAP_HOME = "$PJ_SNAP_HOME_PRE"
# echo PJ_SNAP_ROOT = "$PJ_SNAP_ROOT_PRE"
sudo snapper -c root list | grep "$PJ_SNAP_DESCRIPTION"
sudo snapper -c home list | grep "$PJ_SNAP_DESCRIPTION"

# make a encapsulation in /usr/local/bin to use in $PATH

FILE_IN_PATH=/usr/local/bin/,snap_pre.sh
if [[ ! -f $FILE_IN_PATH ]]; then
    cat <<. | sudo tee "$FILE_IN_PATH" >/dev/null
#!/usr/bin/env bash
# /usr/local/bin/,snap_pre.sh

# set -euo pipefail

if [[ \${BASH_SOURCE[0]} == "\${0}" ]] ; then
    echo "/tmp/snapper/,snap_pre.sh" \$'only can be sourced\nExiting.'
    exit 1
fi

# Check if there is one and only one argument
[[ "\$#" -ne 1 ]] && {
    echo -e "\nUsage: source \${0##*/} <description>\n"
    return 1
}

# shellcheck disable=SC1091
source /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,snap_pre.sh "\$1"
.
    sudo chmod +x "$FILE_IN_PATH"
fi
