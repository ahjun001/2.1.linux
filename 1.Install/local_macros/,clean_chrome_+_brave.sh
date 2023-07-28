#!/usr/bin/env bash

set -euo pipefail

rm -f ~/.config/google-chrome/Default/GPUCache/*
rm -f ~/.config/BraveSoftware/Brave-Browser/Default/GPUCache/*

cat <<.

Hint_pj: Alternatively delete contents of
         other GPUCache directories & files at ~ level

.
