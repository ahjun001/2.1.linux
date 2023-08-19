#!/usr/bin/env bash

set -euo pipefail
clear

dmesg | grep -i audio | grep error || :

dmesg | grep -i failed || :

dmesg | grep -i sound | grep fail || :

dmesg | grep -i alc257 | grep error || :

dmesg | grep amdgpu | grep audio | grep fail || :

dpkg --list | grep pulse | cut -d ' ' -f 3 |
    while read -r PKG; do
        sudo apt install --reinstall "$PKG"
    done
