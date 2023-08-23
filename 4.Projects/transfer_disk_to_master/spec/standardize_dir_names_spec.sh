#!/usr/bin/env bash

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exIt 1"

BeforeAll 'setup'
  setup() {
    # Create a temporary directory for testing in line with the one in 00_commons.sh
    DISK=/tmp/test_dir
    mkdir -p "$DISK"

    export DBG=echo
    export DISK
    }

It "exits if DISK does not exist"
    DISK='/invalid/path'
    When run ./standardize_dir_names.sh
    The error should include 'Permission denied'
    The status should be failure
End

It "calculates max depth correctly"
    DBG='echo'
    DISK=/tmp/test_dir
    NDIR="$DISK"/test1/test2/test3/test4
    mkdir -p "$NDIR"
    When run ./standardize_dir_names.sh
    The output should include "max depth of directory tree = 4"
    The status should be success
    rm -rf "$DISK"
End

It "replaces space in all directories"
    DBG='echo'
    DISK=/tmp/test_dir
    NDIR="$DISK"/test\ 1/test\ 2/test\ 3/test\ 4
    mkdir -p "$NDIR"
    When run ./standardize_dir_names.sh
    The output should include "max depth of directory tree = 4"
    The status should be success
    rm -rf "$DISK"
End

It "replaces spaces in dirs with underscores"
    DISK=/tmp/test_rep1
    TEST_D="$DISK"/test\ dir\ 1
    mkdir -p "$TEST_D"
    When run ./standardize_dir_names.sh
    The output should include 'test_dir_1'
    The directory "$DISK"/test_dir_1 should be exist
    The status should be success
    rm -rf "$DISK"
End

It "replaces dots in dates with dashes"
    DISK=/tmp/test_rep1
    mkdir -p "$DISK""/2023.01.01"
    When run ./standardize_dir_names.sh
    The output should include '2023-01-01'
    The directory  "$DISK""/2023-01-01" should be exist
    The status should be success
    rm -rf "$DISK"
End

AfterAll 'teardown'
teardown() {
    # Remove The temporary directory and Its stub file
    : || rm -r "$DISK"
}