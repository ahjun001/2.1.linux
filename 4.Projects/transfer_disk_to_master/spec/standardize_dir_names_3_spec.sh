#!/usr/bin/env bash
# standardize_dir_names_3_spec.sh

# set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

Include "standardize_dir_names_3.sh"
DISK="/tmp/test_dir"
export DISK

setup() {
rm -rf "$DISK"
mkdir -p "$DISK"
}
BeforeEach 'setup'

AfterEach " rm -rf $DISK"

It "replaces spaces 1"
    mkdir -p "$DISK/20 21.test"
    mkdir -p "$DISK/. 20 21.test"
    When call replace_spaces
        find "$DISK" -maxdepth 1 -type d | sed "s|$DISK||" | grep -q "_"
        The status should be success
End

replace_spaces_and_check() {
    replace_spaces
    find "$DISK" -maxdepth 1 -type d | sed "s|$DISK||" | grep -q " "
}

It "replaces spaces 2"
    mkdir -p "$DISK/21 22.test"
    mkdir -p "$DISK/. 21 22.test"
    When call replace_spaces_and_check
        The status should be failure
End

# It "replaces dots with dashes in directory names starting with 20[0-9][0-9]"
#     mkdir -p "$DISK/2021.test"
#     mkdir -p "$DISK/2022.test"
#     replace_dots
#     ls "$DISK" | grep -q "2021.test"
#     The status should be failure
#     ls "$DISK" | grep -q "2021-test"
#     The status should be success
#     ls "$DISK" | grep -q "2022.test"
#     The status should be failure
#     ls "$DISK" | grep -q "2022-test"
#     The status should be success
# End
