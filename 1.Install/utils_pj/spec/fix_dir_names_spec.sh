#!/usr/bin/env shellcheck
# /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/spec/fix_dir_names_spec.sh
# shellcheck shell=sh disable=

# spec/fix_dir_names_spec.sh
Describe 'fix_dir_names.sh'
  setup() {
    script="$SHELLSPEC_PROJECT_ROOT/,fix_dir_names.sh"
    WIP="$(mktemp -d)"
  }
  cleanup() { rm -rf "$WIP"; }
  BeforeEach setup
  AfterEach cleanup

  It 'shows usage and fails without arguments'
    When run "$script"
    The status should be failure
    The output should include 'Usage:'
  End

  It 'rejects an unknown mode'
    When run "$script" frobnicate "$WIP"
    The status should be failure
    The stderr should include 'mode can only be list or fix'
  End

  It 'says All clear on a clean tree'
    mkdir -p "$WIP/plain/sub"
    When run "$script" list "$WIP"
    The status should be success
    The output should equal 'All clear.'
  End

  It 'counts leading-blank directories (regression)'
    mkdir -p "$WIP/  spaced" "$WIP/plain"
    When run "$script" list "$WIP"
    The status should be success
    The output should include 'count: 1'
    The path "$WIP/  spaced" should exist      # list must not touch anything
  End

  It 'preserves Unicode names, fixing only their blanks'
    mkdir -p "$WIP/ünïcode" "$WIP/中文 目錄" "$WIP/我的文件"
    When run "$script" fix "$WIP"
    The status should be success
    The path "$WIP/ünïcode" should exist       # already clean → untouched
    The path "$WIP/中文_目錄" should exist     # space → _, hanzi kept
    The path "$WIP/我的文件" should exist
    The path "$WIP/中文 目錄" should not exist
  End

  It 'renames parents and children (find -depth regression)'
    mkdir -p "$WIP/old dir/child dir"
    When run "$script" fix "$WIP"
    The status should be success
    The path "$WIP/old_dir/child_dir" should be directory
    The path "$WIP/old dir" should not exist
  End

  It 'refuses to clobber an existing name'
    mkdir -p "$WIP/my dir" "$WIP/my_dir"
    When run "$script" fix "$WIP"
    The status should be success                 # a skip is not an error
    The stderr should include 'SKIP (exists)'
    The path "$WIP/my dir" should exist          # left alone
  End

  It 'handles newlines in names'
    mkdir -p "$WIP/$(printf 'bad\nname')"
    When run "$script" fix "$WIP"
    The path "$WIP/bad_name" should be directory
  End

  It 'after fix, list reports All clear'
    mkdir -p "$WIP/  spaced" "$WIP/my dir" "$WIP/-dash;"
    "$script" fix "$WIP" >/dev/null             # run directly; list is under test
    When run "$script" list "$WIP"
    The output should equal 'All clear.'
  End
End