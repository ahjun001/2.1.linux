#!/usr/bin/env bash

# shellcheck disable=SC1091
. ./01_commons.sh

# dirs=()
# # while read -r dir; do dirs+=("$dir"); done <<<"$(./01_L1_directories.sh)"
# while read -r dir; do dirs+=("$dir"); done < <(Rogue_dirs)

mapfile -t dirs < <(Rogue_dirs)


echo "${dirs[@]}"
