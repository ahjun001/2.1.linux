#!/usr/bin/env bash
#shellcheck disable=SC2034,SC2317
set -euo pipefail
eval "$(shellspec - -c) exit 1"

: " to test:
it manages no argument
it manages empty list
for each of 
        symbolic_links
        hard_links
        empty_files
        empty_dirs
    Confirming or Infirming removals
"

Before 'setup'
setup(){
    # mock nemo so that it does not interfere with tests
    nemo() { echo 'nemo' "$@"; }
    # nemo() { :; }
    # Create a temporary directory for testing
    DISK=/tmp/test_dir
    mkdir -p "$DISK"
    # create a file to avoid having the script deleting the test directory
    touch "$DISK"/stub_file.empty
    Include ./lib_pj.sh
}

It 'fails when # of argument != 1'
    When call Erase_my_l_or_exit 
    The stdout should eq ''
    The stderr should eq 'Erase_my_l_or_exit requires 1 and only 1 argument'
    The status should be failure
End


Describe 'SYMBOLIC LINKS'
    Before 'my_l=()'
    It 'does not fail when list is empty'
        Data 'n'
        When call Erase_my_l_or_exit 'symbolic_links'
        The status should be success
    End

    Describe 'when list is non-empty'
        BeforeEach 'setupEach'
        setupEach(){
            touch "$DISK"/stub_file.empty
            ln -fs "$DISK"/stub_file.empty "$DISK"/foo
            ln -fs "$DISK"/stub_file.empty "$DISK"/bar
            my_l=(
                 "$DISK"/foo
                 "$DISK"/bar
                )
        }
        AfterEach 'afterEach'
        afterEach(){
            rm -f "$DISK"/stub_file.empty
            rm -f /tmp/symbolic_links.txt
            rm -f "$DISK"/{foo,bar}
        }

        It 'deletes the list when confirmed'
            Data '_'
            When call Erase_my_l_or_exit 'symbolic_links'
            The file /tmp/symbolic_links.txt should not be exist
            The file "$DISK"/foo should not be exist
            The file "$DISK"/bar should not be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/test_dir/foo'
            The output should include '/tmp/test_dir/bar'
            The stderr should equal ''
            The status should be success
        End

        It 'copies the list to a file when not confirmed'
            Data 'n'
            When call Erase_my_l_or_exit 'symbolic_links'
            The file /tmp/symbolic_links.txt should be exist
            The file "$DISK"/foo should be exist
            The file "$DISK"/bar should be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/symbolic_links.txt'
            The stderr should equal ''
            The status should be failure
        End
    End
End

Describe 'HARD LINKS'
    Before 'my_l=()'
    It 'does not fail when list is empty'
        Data 'n'
        When call Erase_my_l_or_exit 'hard_links'
        The status should be success
    End

    Describe 'when list is non-empty'
        BeforeEach 'setupEach'
        setupEach(){
            touch "$DISK"/stub_file.empty
            ln -f "$DISK"/stub_file.empty "$DISK"/foo
            ln -f "$DISK"/stub_file.empty "$DISK"/bar
            my_l=(
                 "$DISK"/foo
                 "$DISK"/bar
                )
        }
        AfterEach 'afterEach'
        afterEach(){
            rm -f "$DISK"/stub_file.empty
            rm -f /tmp/empty_dirs.txt
            rm -f /tmp/hard_links.txt
            rm -f "$DISK"/{foo,bar}
        }

        It 'deletes the list when confirmed'
            Data '_'
            When call Erase_my_l_or_exit 'hard_links'
            The file /tmp/hard_links.txt should not be exist
            The file "$DISK"/foo should not be exist
            The file "$DISK"/bar should not be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/test_dir/foo'
            The output should include '/tmp/test_dir/bar'
            The stderr should equal ''
            The status should be success
        End

        It 'copies the list to a file when not confirmed'
            Data 'n'
            When call Erase_my_l_or_exit 'hard_links'
            The file /tmp/hard_links.txt should be exist
            The file "$DISK"/foo should be exist
            The file "$DISK"/bar should be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/hard_links.txt'
            The stderr should equal ''
            The status should be failure
        End
    End
End

Describe 'EMPTY_FILES'
    Before 'my_l=()'
    It 'does not fail when list is empty'
        Data 'n'
        When call Erase_my_l_or_exit 'empty_files'
        The status should be success
    End

    Describe 'when list is non-empty'
        BeforeEach 'setupEach'
        setupEach(){
            touch "$DISK"/stub_file.empty
            touch "$DISK"/foo
            touch "$DISK"/bar
            my_l=(
                 "$DISK"/foo
                 "$DISK"/bar
                )
        }
        AfterEach 'afterEach'
        afterEach(){
            rm -f "$DISK"/stub_file.empty
            rm -f /tmp/empty_files.txt
            rm -f "$DISK"/{foo,bar}
        }

        It 'deletes the list when confirmed'
            Data '_'
            When call Erase_my_l_or_exit 'empty_files'
            The file /tmp/empty_files.txt should not be exist
            The file "$DISK"/foo should not be exist
            The file "$DISK"/bar should not be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/test_dir/foo'
            The output should include '/tmp/test_dir/bar'
            The stderr should equal ''
            The status should be success
        End

        It 'copies the list to a file when not confirmed'
            Data 'n'
            When call Erase_my_l_or_exit 'empty_files'
            The file /tmp/empty_files.txt should be exist
            The file "$DISK"/foo should be exist
            The file "$DISK"/bar should be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/empty_files.txt'
            The stderr should equal ''
            The status should be failure
        End
    End
End

Describe 'EMPTY_DIRS'
    Before 'my_l=()'
    It 'does not fail when list is empty'
        Data 'n'
        When call Erase_my_l_or_exit 'empty_dirs'
        The status should be success
    End

    Describe 'when list is non-empty'
        BeforeEach 'setupEach'
        setupEach(){
            touch "$DISK"/stub_file.empty
            mkdir -p "$DISK"/foo
            mkdir -p "$DISK"/bar
            my_l=(
                 "$DISK"/foo
                 "$DISK"/bar
                )
        }
        AfterEach 'afterEach'
        afterEach(){
            rm -f "$DISK"/stub_file.empty
            rm -f /tmp/empty_dirs.txt
            rm -rf "$DISK"/{foo,bar}
        }

        It 'deletes the list when confirmed'
            Data '_'
            When call Erase_my_l_or_exit 'empty_dirs'
            The file /tmp/empty_dirs.txt should not be exist
            The dir "$DISK"/foo should not be exist
            The dir "$DISK"/bar should not be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/test_dir/foo'
            The output should include '/tmp/test_dir/bar'
            The stderr should equal ''
            The status should be success
        End

        It 'copies the list to a file when not confirmed'
            Data 'n'
            When call Erase_my_l_or_exit 'empty_dirs'
            The file /tmp/empty_dirs.txt should be exist
            The dir "$DISK"/foo should be exist
            The dir "$DISK"/bar should be exist
            The file "$DISK"/stub_file.empty should be exist
            The output should include '/tmp/empty_dirs.txt'
            The stderr should equal ''
            The status should be failure
        End
    End
End
