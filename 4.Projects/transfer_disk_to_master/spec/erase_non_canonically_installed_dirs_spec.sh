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

    # Create some directories to be deleted
    mkdir -p "$DISK/.git" "$DISK/.idea" "$DISK/myvenv" "$DISK/go" "$DISK/nvm" "$DISK/__pycache__"
    mkdir -p "$DISK/a/.git" "$DISK/b/.idea" "$DISK/c/.venv" "$DISK/d/go" "$DISK/e/nvm" \
        "$DISK/f/__pycache__"
    mkdir -p "$DISK/g/.venv3"
}

It 'deletes directories'
    When run ./erase_non_canonically_installed_dirs.sh
        The status should be success
        The output should include 'erase_non_canonically_installed_dirs.sh'
        The directory "$DISK/.git" should not be exist
        The directory "$DISK/.idea" should not be exist
        The directory "$DISK/myvenv" should not be exist
        The directory "$DISK/go" should not be exist
        The directory "$DISK/nvm" should not be exist
        The directory "$DISK/__pycache__" should not be exist
End

AfterAll 'teardown'
teardown() {
    # Remove the temporary directory and its stub file
    rm "$DISK"/stub_file.empty
    rmdir "$DISK"
}
