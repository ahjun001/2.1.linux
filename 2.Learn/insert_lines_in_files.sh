#!/usr/bin/env bash
# shellcheck disable=2016

# 00_model.sh
# repeat description of what the script should do

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}" 

files=(
    '01_post_install.sh'
    '02_expressvpn.sh'
    '02_git.sh'
    '02_grub2.sh'
    '02_mount_data.sh'
    '02_shellspec.sh'
    '02_update_repos.sh'
    '03_reset_all_links.sh'
)

lines=(
    '# run with arg u  to undo'
    ''
    '# launch after install
[[ -n ${LAUNCH_APP+foo} ]]  || LAUNCH_APP=true

# info verbose debug trace
[[ ${MY_TRACE+foo} ]] || MY_TRACE=true'
    ''
)

# MY_STRING='# run with arg u  to undo\n\n display results or not\n \[ -n "${LAUNCH_APP+x}"  \] && LAUNCH_APP=true'
for line in "${lines[@]}"; do
    MY_STRING+="\n$line"
done
MY_STRING="${MY_STRING:2}"
for file in "${files[@]}"; do
    if [ "$1" = 'u' ]; then
        for line in "${lines[@]}"; do
            sed -i "/$line/d" "$file"
        done
        sed -i "/$MY_STRING/d" "$file"
    else
        sed -i "6i$MY_STRING" "$file"
    fi
    less "$file"
done
