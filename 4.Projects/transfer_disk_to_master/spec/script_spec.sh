#!/usr/bin/env bash

set -euo pipefail

eval "$(shellspec - -c) exit 1"

Describe "hello.sh"
    Include ./script.sh
    It "says hello"
      When call hello world
      The output should eq "Hello world"
      The stderr should eq ""
      The status should be success
    End
End

Describe 'confirm'
  Include ./script.sh
    It 'prints "confirm n"'
        Data 'n'
        When call confirm
        The output should include 'Entering'
        # The line 1 of stdout should eq "confirm : Entering"
        # The line 2 of stdout should eq "End"
        # The stderr should eq ""
        The status should be success
    End
End

#     # It 'prints "confirm y"'
#     #     Data 'y'
#     #     When run source ./script.sh
#     #     The output should include 'Entering'
#     #     The line 1 of stdout should eq "confirm : Entering"
#     #     The line 2 of stdout should eq "confirm : Have not returned yet"
#     #     The line 3 of stdout should eq "End"
#     #     The stderr should eq ""
#     #     The status should be success
#     # End
# End
