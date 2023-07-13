#!/usr/bin/env bash

read -rsn 1 -r -p $'Press \'n\' not to erase these files\n'
[[ $REPLY != 'n' ]] && echo "would erase dirs"
