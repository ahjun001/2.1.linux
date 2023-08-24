#!/usr/bin/env bash
#shellcheck disable=SC2317
set -euo pipefail
eval "$(shellspec - -c) exit 1"

Before 'setup'
setup(){
    nemo() { echo 'nemo' "$@"; }
    # Create a temporary directory for testing in line with the one in 00_commons.sh
    DISK=/tmp/test_dir
    mkdir -p "$DISK"
    # put a file to avoid having the script deleting the test directory
    touch "$DISK"/stub_file.empty
    export DISK
    export DBG=:
    
    my_l=() 
    export my_l
}

After 'cleanup'
cleanup(){
    mkdir -p "$DISK"
}


Describe 'Erase_my_l_or_exit()'
    Describe 'when list is empty'
        # Include ./trash_links_empty_files_n_dirs.sh
        Before 'setup'
        After 'cleanup'
        set -x
        It 'does not exit'
            Data 'n'
            When call Erase_my_l_or_exit 'symbolic_links'
            The status should be success
        End
    End

    # Describe 'when list is non-empty'
    #     BeforeEach 'my_l=(/tmp/test_dir/foo /tmp/test_dir/bar)'
    #     AfterEach 'rm -rf /tmp/test_dir/foo /tmp/test_dir/bar'

    #     It 'asks for confirmation before deleting the list'
    #         Skip if "user does not confirm" [[ "$REPLY" == "y" ]]
    #         When call Erase_my_l_or_exit 'symbolic_links'
    #         The output should include '/tmp/test_dir/foo'
    #         The output should include '/tmp/test_dir/bar'
    #         The status should be failure
    #     End

    #     It 'deletes the list when confirmed'
    #         Skip if "user does not confirm" [[ "$REPLY" == "y" ]]
    #         When call Erase_my_l_or_exit 'symbolic_links'
    #         The output should not include '/tmp/test_dir/foo'
    #         The output should not include '/tmp/test_dir/bar'
    #         The status should be success
    #     End

#         It 'copies the list to a file when not confirmed'
#             Skip if "user confirms" [[ $confirm != "n" ]]
#             When call Erase_my_l_or_exit 'symbolic_links'
#             The output should include '/tmp/symbolic_links.txt'
#             The status should be failure
#         End
#     End
# End

# Describe 'main script'
#     BeforeEach 'DISK=$(mktemp -d) && mkdir -p "$DISK"'
#     AfterEach  'rm -rf "$DISK"'

#     Describe 'Erase_my_l_or_exit() calls'
#         BeforeEach 'touch "$DISK"/file && ln -s "$DISK"/file "$DISK"/link && ln "$DISK"/file "$DISK"/hardlink'

#         It 'calls Erase_my_l_or_exit with symbolic_links argument'
#             When call Erase_my_l_or_exit symbolic_links
#             The output should include '/tmp/test_dir/link -> /tmp/test_dir/file'
#             The status should be failure
#         End

#         It 'calls Erase_my_l_or_exit with hard_links argument'
#             When call Erase_my_l_or_exit hard_links
#             The output should include '/tmp/test_dir/hardlink -> /tmp/test_dir/file'
#             The status should be failure
#         End

#         It 'calls Erase_my_l_or_exit with empty_files argument'
#             When call Erase_my_l_or_exit empty_files
#             The output should include '/tmp/test_dir/file'
#             The status should be failure
#         End

#         It 'calls Erase_my_l_or_exit with empty_dirs argument and does not exit when list is empty'
#             When call Erase_my_l_or_exit empty_dirs
#             The status should be success
#         End

#         It 'calls Erase_my_l_or_exit with empty_dirs argument and exits when list is non-empty'
#             BeforeEach 'mkdir "$DISK"/dir && touch "$DISK"/dir/file'

#             When call Erase_my_l_or_exit empty_dirs
#             The output should include '/tmp/test_dir/dir/file'
#             The status should be failure
#         End
#     End

#     Describe 'main script calls to Erase_my_l_or_exit() are correct and complete'

#         It 'calls Erase_my_l_or_exit with symbolic_links argument before removing symbolic links'
#             BeforeEach 'touch "$DISK"/file && ln -s "$DISK"/file "$DISK"/link'

#             When run script ./script.sh
#             The output should include '/tmp/test_dir/link -> /tmp/test_dir/file' # symbolic link must be printed before confirmation prompt.
#             The status should be success
#         End

#         It 'calls Erase_my_l_or_exit with hard_links argument before removing hard links but one'
#             BeforeEach '
#                 touch "$DISK"/file &&
#                 ln "$DISK"/file "$DISK"/hardlink1 &&
#                 ln "$DISK"/file "$DISK"/hardlink2 &&
#                 ln "$DISK"/file "$DISK"/hardlink3 &&
#                 ln "$DISK"/file "$DISK"/hardlink4 &&
#                 ln "$DISK"/file "$DISK"/hardlink5 &&
#                 ln "$DISK"/file "$DISK"/hardlink6 &&
#                 ln "$DISK"/file "$DISK"/hardlink7 &&
#                 ln "$DISK"/file "$DISK"/hardlink8 &&
#                 ln "$DISK"/file "$DISK"/hardlink9 &&
#                 ln "$DISK"/file "$DISK"/hardlink10 &&
#                 ln "$DISK"/file "$DISK"/hardlink11 &&
#                 ln "$DISK"/file "$DISK"/hardlink12 &&
#                 ln "$DISK"/file "$DISK"/hardlink13'
#                 '

#             When call Erase_my_l_or_exit hard_links
#                 The output should include '/tmp/test_dir/hardlink1 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink2 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink3 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink4 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink5 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink6 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink7 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink8 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink8 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink9 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink10 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#                 The output should include '/tmp/test_dir/hardlink11 -> /tmp/test_dir/file' # hard link must be printed before confirmation prompt.
#             End
#         End
# End
    End
