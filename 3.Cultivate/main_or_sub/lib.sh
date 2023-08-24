#!/usr/bin/env bash
# lib.sh

set -euo pipefail

my_func() {
    case $# in
    0)
        return 1
        ;;
    1)
        echo "$1"
        return 0
        ;;
    *)
        echo "$1"
        return 99 ;;
    esac
}
