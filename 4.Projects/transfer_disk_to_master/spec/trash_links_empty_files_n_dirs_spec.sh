#!/usr/bin/env bash

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

Describe 'Erase_my_l_or_exit'
    It 'displays the list when not empty and exits if user presses n'
        export my_l=(/tmp/file1 /tmp/file2)

        When run ./trash_links_empty_files_n_dirs.sh
            The output should include "/tmp/file1"
            The output should include "/tmp/file2"
            The exit status should be 1
    End

    It 'does not display list when empty'
        unset my_l

        When run ./trash_links_empty_files_n_dirs.sh
        When run ./trash_links_empty_files_n_dirs.sh
        The output should not include "Press"
        The exit status should be 0
    End
End

Describe 'Clean_trash'
    It 'launches nemo for each trashed file'
        When run ./trash_links_empty_files_n_dirs.sh
        The output should include "nemo"
    End
End

Describe 'main'
    BeforeEach 'create test files'
        touch /tmp/file{1..3}
        mkdir /tmp/emptydir
    End

    AfterEach 'remove test files'
        rm -rf /tmp/file{1..3} /tmp/emptydir
    End

    It 'removes symbolic links'
        ln -s /tmp/file1 /tmp/link1

        When run ./trash_links_empty_files_n_dirs.sh
        The file "/tmp/link1" should not exist
    End

    It 'prompts before removing hard links'
        ln /tmp/file1 /tmp/link1

        When run ./trash_links_empty_files_n_dirs.sh
        The output should include "/tmp/link1"
        The file "/tmp/link1" should exist
    End

    It 'removes empty files'
        touch /tmp/emptyfile

        When run ./trash_links_empty_files_n_dirs.sh
        The file "/tmp/emptyfile" should not exist
    End

    It 'removes empty directories'
        When run ./trash_links_empty_files_n_dirs.sh
        The directory "/tmp/emptydir" should not exist
    End
End
