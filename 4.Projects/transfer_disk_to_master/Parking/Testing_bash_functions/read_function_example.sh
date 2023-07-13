#!/usr/bin/env bash
set -x

if read -r -p "Enter some text or Ctrl-D to abort: " my_text; then
    echo OK
    echo my_text = "$my_text"
else
    echo not OK
fi
