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

LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
echo FILE= "$FILE"
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
