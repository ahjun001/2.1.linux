#!/usr/bin/env bash

# set -euo pipefail

# find /home/perubu/Documents/Github -maxdepth 1 -mindepth 1 -type d ! -name '.*' \
#     -exec sh -c '
#     cd "$1"
#     [[ $(git status | sed -n "$p") == "nothing to commit, working tree clean" ]] || (
#         pwd
#         git status -s
#         # code .
#     )
#   ' sh {} \;

set -euo pipefail

find /home/perubu/Documents/Github -maxdepth 1 -mindepth 1 -type d ! -name '.*' \
  -exec sh -c '
      cd "$1" &&
      git fetch &&
      git status | grep -q "nothing to commit, working tree clean" ||
      code .
      ' sh {} \;

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
