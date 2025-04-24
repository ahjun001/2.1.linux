#!/usr/bin/env bash

set -euo pipefail

rm -f ~/.config/google-chrome/Default/GPUCache/*
rm -f ~/.config/BraveSoftware/Brave-Browser/Default/GPUCache/*
rm -f ~/.config/Z-Library/GPUCache/*

cat <<.

Hint_pj: Alternatively delete contents of
         other GPUCache directories & files at ~ level

.

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
