#!/usr/bin/env bash

# ,google-chrome_update.sh
# if run from bash, install or re-install google-chrome
# if sourced and if not installed, then will installed

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}"

APP=google-chrome

# if launched from CLI, will install anyways
# if sourced, exiting if package is already installed
if [[ "$0" == "${BASH_SOURCE[0]}" ]] || ! command -v "$APP"; then

    case $ID in
    fedora)
        # PKG_FMT='.rpm'
        # PKG_MGR='dnf'
        wget -P /tmp/ https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
        sudo dnf install /tmp/google-chrome-stable_current_x86_64.rpm
        ;;
    linuxmint | ubuntu)
        # PKG_FMT='.deb'
        # PKG_MGR='apt'
        wget -P /tmp/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo apt install /tmp/google-chrome-stable_current_amd64.deb
        ;;
    *)
        echo "Distribution $ID not recognized, exiting ..."
        exit 1
        ;;
    esac

    $RUN "$APP"

fi

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
