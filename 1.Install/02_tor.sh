#!/usr/bin/env bash

# 02_git.sh
# install git, required to install zsh & oh-my-zsh

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh # to get VERSION_CODENAME

packageNeeded=torbrowser
# Exit if command is already installed
if command -v "$packageNeeded" >>"$INSTALL_LOG"; then
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then exit 0; else return 0; fi
fi

case $ID in
fedora)
    sudo dnf install "$packageNeeded"
    ;;
linuxmint | ubuntu)
    cat <<.
    Download tar from https://www.torproject.org/
    Decompress tor-browser in /tmp, then move to /opt
    $ cd /opt/tor-browser
    $ ./start-tor-browser.desktop --register-app
.
    # sudo apt install torbrowser-launcher

#     sudo apt install apt-transport-tor
#     if [ ! -f /etc/apt/sources.list.d/tor.list ]; then
#         sudo tee /etc/apt/sources.list.d/tor.list <<EOF
# # For the stable version.
# deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] tor://apow7mjfryruh65chtdydfmqfpj5btws7nbocgtaovhvezgccyjazpqd.onion/torproject.org $UBUNTU_CODENAME main
# EOF
#     fi
#     wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null

#     sudo apt update
#     sudo apt install tor deb.torproject.org-keyring
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac
