#!/usr/bin/env bash
# shellcheck disable=SC2317

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

Describe "Erase_my_l_or_exit()"

Before "mock"
  mock() {
    rm() { echo 'rm' "$@"; }
    nemo() { echo 'nemo' "$@"; }
    read() { REPLY="y"; }
    find() {
      case "$1" in
        "/tmp/test_dir") echo "/tmp/test_dir/file1" ;;
        *) echo "" ;;
      esac
    }
  }

  It "removes symbolic links"
    When run Erase_my_l_or_exit "symbolic_links"
    The line 2 of output should eq "rm -rv /tmp/test_dir/file1"
  End

  It "removes hard links"
    When run Erase_my_l_or_exit "hard_links"
    The line 2 of output should eq "rm /tmp/test_dir/file1"
  End

  It "creates log file and opens nemo"
    When run Erase_my_l_or_exit "hard_links"
    The line 9 of output should eq "echo 'Copying list in /tmp/hardlinks.txt'"
    The line 12 of output should eq "nemo '/tmp/hardlinks.txt'"
  End

  It "lists empty files"
    When run Erase_my_l_or_exit "empty_files"
    The line 2 of output should eq "rm -rv /tmp/test_dir/file1"
  End

  It "lists empty dirs"
    When run Erase_my_l_or_exit "empty_dirs"
    The line 2 of output should eq "rm -rv /tmp/test_dir/file1"
  End

  It "creates log file for empty dirs and opens nemo"
    When run Erase_my_l_or_exit "empty_dirs"
    The line 9 of output should eq "echo 'Copying list in /tmp/empty_dirs.txt'"
    The line 12 of output should eq "nemo '/tmp/empty_dirs.txt'"
  End
End
