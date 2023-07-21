#!/usr/bin/env bash

# 02_speed_up_dnf_n_apt.sh
# speed up Linux Package Manager

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

case $ID in
fedora)
    #dnf flags
    lines=(
        'fastestmirror=1'
        'max_parallel_downloads=10'
        'deltarpm=true'
    )
    for line in "${lines[@]}"; do
        # only delete the line if it exists, and add it if it doesn't exist yet
        if grep -q "$line" /etc/dnf/dnf.conf; then
            if [ "$ACT" = 'u' ]; then
                sudo sed -i "/$line/d" /etc/dnf/dnf.conf
                [ "$MY_TRACE" = true ] && echo "deleted line $line"
            else
                [ "$MY_TRACE" = true ] && echo "$line already in file, nothing done"
            fi
        else
            if [ "$ACT" = 'u' ]; then
                [ "$MY_TRACE" = true ] && echo "$line not found, nothing to be deleted"
            else
                echo "$line" | sudo tee -a /etc/dnf/dnf.conf
                [ "$MY_TRACE" = true ] && echo "added line $line"
            fi
        fi
    done
    [ "$LAUNCH_APP" = true ] && less /etc/dnf/dnf.conf
    ;;
linuxmint | ubuntu)
    echo "$0 not implemented in $ID"
    # exit 1
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac
