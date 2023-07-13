#!/usr/bin/env bash

# 02_brave.sh
# repeat description of what the script should do

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# Exit if command is already installed
if command -v brave-browser >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

case $ID in
fedora)
    sudo dnf install dnf-plugins-core

    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/

    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

    sudo dnf install brave-browser
    ;;
linuxmint | ubuntu)

    sudo apt update

    sudo apt install curl

    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update

    sudo apt install brave-browser

    ;;

*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac

[[ $LAUNCH_APP = true ]] && brave-browser
