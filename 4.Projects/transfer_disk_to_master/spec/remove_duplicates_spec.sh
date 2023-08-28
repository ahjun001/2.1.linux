#!/usr/bin/env bash

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

Before 'setup'
setup() {
    DISK=/tmp/test_dir3
    mkdir -p "$DISK"
    MSTR=/tmp/test_mstr
    mkdir -p "$MSTR"
    # export all variables declare in script
    DBG=:
    export DBG
    export DISK MSTR DBG
}

It 'erases duplicates accross disks'
    echo file.txt > "$DISK"/file.txt
    echo file.txt > "$MSTR"/file.txt
    When run script ./remove_duplicates.sh -m
    The stdout should include 'test_dir3'
    The stdout should include 'test_mstr'
    The stderr should include ''
    The status should be success
End

After 'teardown'
teardown() {
    # Remove the temporary directory and its stub file
    rmdir "$DISK" "$DISK2"
}
