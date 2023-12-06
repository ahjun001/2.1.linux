#!/usr/bin/env bash
# create or re-create links to pj utils

set -euo pipefail

for f in /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/*.sh; do
    sudo ln -fs "$f" /usr/local/sbin/
done

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
