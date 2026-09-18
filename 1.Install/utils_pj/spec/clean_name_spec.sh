#!/usr/bin/env shellcheck
# /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/spec/clean_name_spec.sh
# shellcheck shell=sh disable=SC3040,SC1091,SC2016

Describe 'clean_name()'
  setup() {
    # shellcheck source=../,fix_dir_names.sh
    . "$SHELLSPEC_PROJECT_ROOT/,fix_dir_names.sh"
    set +eu +o pipefail        # the script's set -euo pipefail leaks in; undo it
  }
  BeforeAll setup

  Describe 'dangerous characters (was P0)'
    It 'replaces shell operators'
      When call clean_name 'a&b;c|d<e>f(g)h$i`j'
      The output should equal 'a_b_c_d_e_f_g_h_i_j'
    End
    It 'replaces control characters (tab, newline)'
      When call clean_name "$(printf 'a\tb\nc')"
      The output should equal 'a_b_c'
    End
    It 'prefixes a leading dash'
      When call clean_name '-foo;bar'
      The output should equal '_-foo_bar'
    End
  End

  Describe 'annoying characters (was P1)'
    It 'replaces glob chars and quotes'
      When call clean_name "*?[]'\""
      The output should equal '______'
    End
    It 'replaces internal spaces'
      When call clean_name 'my dir'
      The output should equal 'my_dir'
    End
  End

  Describe 'non-ASCII is preserved'
    It 'keeps Latin accents'
      When call clean_name 'ünïcode'
      The output should equal 'ünïcode'
    End
    It 'keeps Chinese untouched'
      When call clean_name '中文目录'
      The output should equal '中文目录'
    End
    It 'keeps Chinese, fixes only the space'
      When call clean_name '我的 文件'
      The output should equal '我的_文件'
    End
    It 'keeps mixed scripts'
      When call clean_name 'Ünï cödé'
      The output should equal 'Ünï_cödé'
    End
  End

  Describe 'leading blanks'
    It 'strips leading spaces'
      When call clean_name '  spaced'
      The output should equal 'spaced'
    End
    It 'strips a leading tab'
      When call clean_name "$(printf '\ttabbed')"
      The output should equal 'tabbed'
    End
    It 'strips leading newlines'
      When call clean_name "$(printf '\n\nlead')"
      The output should equal 'lead'
    End
  End

  Describe 'edge cases'
    It 'collapses an all-blank name to _'
      When call clean_name "$(printf ' \t\n')"
      The output should equal '_'
    End
    It 'guards dot-only names'
      When call clean_name ' .'
      The output should equal '_'
    End
    It 'leaves a trailing blank as _ (pins current behavior)'
      When call clean_name 'dir '
      The output should equal 'dir_'
    End
    It 'keeps other ASCII punctuation (old P2 is gone)'
      When call clean_name 'a#b:c,d'
      The output should equal 'a#b:c,d'
    End
    It 'leaves clean names untouched'
      When call clean_name 'plain-name.v2'
      The output should equal 'plain-name.v2'
    End
  End
End