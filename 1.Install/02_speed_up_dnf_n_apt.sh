#!/usr/bin/env bash

# 02_speed_up_dnf_n_apt.sh
# speed up Linux Package Manager

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

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
                $DBG "deleted line $line"
            else
                $DBG "$line already in file, nothing done"
            fi
        else
            if [ "$ACT" = 'u' ]; then
                $DBG "$line not found, nothing to be deleted"
            else
                echo "$line" | sudo tee -a /etc/dnf/dnf.conf
                $DBG "added line $line"
            fi
        fi
    done
    $RUN less /etc/dnf/dnf.conf
    ;;
linuxmint | ubuntu)
    [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0
    ;;
*)
    echo -e "Distribution $ID not recognized, exiting ...\n"
    exit 1
    ;;
esac
