#!/usr/bin/env bash

set -euo pipefail
clear

ping -q -c 1 -w 1 google.com || echo Ping google.com unsuccessful
cat <<.


.
,width_reduce.sh &
cat <<.


.

ansible-playbook <(
    cat <<.
---
- name: Update all packages
  hosts: localhost
  tasks:
    - name: Update all packages to the latest version
      ansible.builtin.package:
        name: "*"
        state: latest
      become: true
  vars:
    ansible_connection: local
.
) -K -i localhost,


cat <<.


.
# set environment: ID
# shellcheck source=/dev/null
[[ -n ${ID+foo} ]] || . /etc/os-release
case $ID in
linuxmint | ubuntu) sudo yt-dlp -U ;;
fedora) ;;
*) echo "Should not happen" && exit 1 ;;
esac

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
