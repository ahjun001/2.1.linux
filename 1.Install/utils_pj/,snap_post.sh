#!/usr/bin/env bash

# set -euo pipefail

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "${0##*/}" $'only can be sourced\nExiting.'
    exit 1
fi

cat <<.
    PJ_SNAP_DESCRIPTION = "$PJ_SNAP_DESCRIPTION"
    PJ_SNAP_ROOT_POST = "$PJ_SNAP_ROOT_POST"
    PJ_SNAP_HOME_POST = "$PJ_SNAP_HOME_POST"

    Latest relevant environment variables can be set with:
    source /tmp/snapper/pj_snap.sh"

    Filters can be set with
    $ sudo -E nvim /usr/snapper/filters/excluded.txt

.

# Function to ask the user if they want to run a command
ask_and_run() {
    local prompt="$1"
    local cmd="$2"
    local varname="$3"

    read -rp "$prompt [yY] "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        export "$varname"="$(eval "$cmd")"
    fi
}

# Ask if the user wants to run the snapper command and save the output number in PJ_SNAP_HOME_POST
ask_and_run "Do you want to run 'sudo snapper -c home create --type post --pre-number '$PJ_SNAP_HOME_PRE' --description '$PJ_SNAP_DESCRIPTION'?" \
    "sudo snapper -c home create --type post --pre-number \"$PJ_SNAP_HOME_PRE\" --description \"$PJ_SNAP_DESCRIPTION\" --cleanup-algorithm number --print-number" \
    "PJ_SNAP_HOME_POST"

# Ask if the user wants to run the snapper command and save the output number in PJ_SNAP_ROOT_POST
ask_and_run "Do you want to run 'sudo snapper -c root create --type post --pre-number '$PJ_SNAP_ROOT_PRE' --description '$PJ_SNAP_DESCRIPTION'?" \
    "sudo snapper -c root create --type post --pre-number \"$PJ_SNAP_ROOT_PRE\" --description \"$PJ_SNAP_DESCRIPTION\" --cleanup-algorithm number --print-number" \
    "PJ_SNAP_ROOT_POST"

# Function to ask the user if they want to run a status command
ask_and_run_status() {
    local prompt="$1"
    local cmd="$2"
    local filename="$3"

    read -rp "$prompt [yY] "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        eval "$cmd" | sudo tee "/tmp/snapper/$filename.txt" 
    fi
}

# Ask if the user wants to run the status command for home
ask_and_run_status "Do you want to run 'sudo snapper -c home status $PJ_SNAP_HOME_PRE..$PJ_SNAP_HOME_POST'?" \
    "sudo snapper -c home status \"$PJ_SNAP_HOME_PRE\"..\"$PJ_SNAP_HOME_POST\"" \
    "$PJ_SNAP_HOME_PRE..$PJ_SNAP_HOME_POST"

# Ask if the user wants to run the status command for root
ask_and_run_status "Do you want to run 'sudo snapper -c root status $PJ_SNAP_ROOT_PRE..$PJ_SNAP_ROOT_POST'?" \
    "sudo snapper -c root status \"$PJ_SNAP_ROOT_PRE\"..\"$PJ_SNAP_ROOT_POST\"" \
    "$PJ_SNAP_ROOT_PRE..$PJ_SNAP_ROOT_POST"

# make a encapsulation in /usr/local/bin to use in $PATH

FILE_IN_PATH=/usr/local/bin/,snap_post.sh
if [[ ! -f $FILE_IN_PATH ]]; then
    cat <<. | sudo tee "$FILE_IN_PATH" >/dev/null
#!/usr/bin/env bash
# /usr/local/bin/,snap_post.sh

# set -euo pipefail

# shellcheck disable=SC1091
source /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,snap_post.sh
.
    sudo chmod +x "$FILE_IN_PATH"
fi
