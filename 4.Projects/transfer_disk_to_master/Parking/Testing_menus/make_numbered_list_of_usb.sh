#!/usr/bin/env bash

find /media/perubu -maxdepth 1 -type d | sed '1d' | nl -s '. ' | while read -r LINE; do echo "# $LINE"; done
