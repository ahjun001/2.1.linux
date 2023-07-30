#!/usr/bin/env bash

if [ "${0##*/}" = "${0}" ]; then
    echo "1: Script is being run directly, not sourced."
else
    echo "1: Script is being sourced from another script."
fi
