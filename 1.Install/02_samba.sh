#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}"

# Check if smbd service is active
if ! systemctl is-active smbd >/dev/null 2>&1; then

    # Install samba
    sudo apt install samba -y

    # Configure samba share
    sudo sed -i 's/^\[homes\]/\[homes\]\n   browseable = yes\n   read only = no/g' /etc/samba/smb.conf

    # Add samba user
    sudo smbpasswd -a "$USER"

    # Start and enable samba services
    sudo systemctl enable smbd.service nmbd.service
    sudo systemctl start smbd.service nmbd.service

    # Open firewall
    sudo ufw allow samba

fi
: "
nmbd handles the NetBIOS name services that enables broadcast discovery, name registration, and name resolution for the Samba server and shares.

It works together with smbd which provides the file and print sharing services itself.
nmbd broadcasts the name and registers the Samba server so that smbd shares can be discovered and accessed by their name from Windows clients.

That's why it's recommended to run nmbd anytime smbd is running to provide the full Samba functionality expected by Windows clients.
"
