#!/usr/bin/env bash

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

BeforeAll 'setup'
setup() {
    # Create a temporary directory for testing in line with the one in 00_commons.sh
    DISK=/tmp/test_dir
    mkdir -p "$DISK"
    # put a file to avoid having the script deleting the test directory
    touch "$DISK"/stub_file.empty
    export DISK
    export DBG=:

    # Create some directories to be deleted
    declare -a list
    list=(
        .git
        .idea
        myvenv
        go
        nvm
        __pycache__
        containers
        a/.git
        b/.idea
        c/.venv
        d/go
        e/nvm
        f/__pycache__
        g/.venv3
        h/containers
    )

    for d in "${list[@]}"; do
        mkdir -p "$DISK"/"$d"
    done

}

It 'deletes directories'
When run ./erase_non_canonically_installed_dirs.sh
The status should be success
for d in "${list[@]}"; do
    The directory "$DISK"/"$d" should not be exist
done
End

AfterAll 'teardown'
teardown() {
    # Remove the temporary directory and its stub file
    rm "$DISK"/stub_file.empty
    rmdir "$DISK"
}
