#!/usr/bin/env bash

# set -euo pipefail

echo "Latest relevant environment variables can be set with:"
echo "source /tmp/snapper/pj_snap.sh"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "${0##*/}" $'only can be sourced\nExiting.'
    exit 1
fi

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

# make a encapsulation in /usr/local/sbin to use in $PATH

FILE_IN_PATH=/usr/local/sbin/,snap_post.sh
if [[ ! -f $FILE_IN_PATH ]]; then
    cat <<. | sudo tee "$FILE_IN_PATH" >/dev/null
#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
source /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,snap_pre.sh "\$1"
.
    sudo chmod +x "$FILE_IN_PATH"
fi
