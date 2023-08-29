#!/usr/bin/env bash

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

BeforeEach 'setup'
setup() {
    DISK=/tmp/test_dir3
    MSTR=/tmp/test_mstr
    rm -rf "$MSTR" "$DISK"
    mkdir -p "$MSTR" "$DISK"
    # export all variables declare in script
    DBG=:
    export DBG
    export DISK MSTR DBG
    FDUPES_RESULT_F='fdupes_results.txt'
    echo > "$FDUPES_RESULT_F"

  Include ./remove_duplicates.sh
}

AfterEach 'teardown'
teardown() {
    # Remove the temporary directory and its stub file
    rm -rf "$MSTR" "$DISK" "$FDUPES_RESULT_F"
}

# Specify 'Elementary test: the script removes duplicates accross disks at root level'
#     echo file.txt > "$DISK"/file.txt
#     echo file.txt > "$MSTR"/file.txt
#     When run script ./remove_duplicates.sh -m
#     The stdout should eq ''
#     The stderr should include $' '
#     The file "$DISK"/file.txt should not be exist
#     The file "$MSTR"/file.txt should be exist
#     The status should be success
# End


# It 'detects duplicates in recurse directories accross disks'
#     mkdir -p "$DISK"/l1/l2
#     echo file.txt > "$DISK"/l1/l2/file.txt
#     mkdir -p "$MSTR"/l1/l2
#     echo file.txt > "$MSTR"/l1/l2/file.txt
#     When run script ./remove_duplicates.sh -m
#     The stdout should eq ''
#     The stderr should include ''
#     The file "$DISK"/l1/l2/file.txt should not be exist
#     The file "$MSTR"/l1/l2/file.txt should be exist
#     The status should be success
# End

helper_create_dupe_files(){
    echo abc > "$1"/abc.txt
    mkdir -p "$1"/l1
    echo abc >"$1"/l1/abcd.txt
} 

# Defined in spec/remove_duplicates_spec.sh
Describe 'fdupes_clean_both'

  It 'does not delete anything when there are no duplicates'
    # Run the function with no duplicates
    When call fdupes_clean_both<"$FDUPES_RESULT_F"
    The file "$FDUPES_RESULT_F" should eq ''
    The stdout should eq ''
    The stderr should eq ''
    The status should be success
  End
End
#   It 'deletes duplicates that only exist in DISK and not in MSTR'
#     # Create duplicate files in $DISK
#     helper_create_dupe_files "$DISK"

#     # Run the function with duplicates in $DISK
#     When call fdupes_clean_both
#     The stdout should include "File deleted"
#     The stdout should not include "File added to fdupes_review.txt"
#     The file "$DISK/duplicate_file" should not exist
#   End

#   It 'deletes duplicates in DISK and preserves duplicates in MSTR'
#     # Create duplicate files in both $MSTR and $DISK
#     helper_create_dupe_files "$DISK"
#     helper_create_dupe_files "$MSTR"

#     # Run the function with duplicates in both directories
#     When call fdupes_clean_both
#     The stdout should include "File deleted"
#     The stdout should not include "File added to fdupes_review.txt"
#     The file "$DISK/duplicate_file" should not exist
#     The file "$MSTR/duplicate_file" should exist
#   End

#   It 'handles when fdupes_results.txt does not end with a blank line'
#     # Create duplicate files and manually write to fdupes_results.txt
#     helper_create_dupe_files "$DISK"
#     echo "$DISK/duplicate_file" >> "$FDUPES_RESULT_F"

#     # Run the function
#     When call fdupes_clean_both
#     The stdout should include "File deleted"
#     The file "$DISK/duplicate_file" should not exist
#   End
# End
