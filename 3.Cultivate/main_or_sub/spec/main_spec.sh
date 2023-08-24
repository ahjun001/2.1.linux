#!/usr/bin/env bash

eval "$(shellspec - -c) exit 1"

Describe 'main.sh'
  It '1. loads functions from lib.sh'
    When run ./main.sh
    The output should include 'Hello world'
    The line 1 of stdout should eq 'Hello world'
    The stderr should eq ''
    The status should be success
  End
End

Describe "My Function"
  Include ./main.sh  # Include your script that contains the function
  It "2. requires exactly 1 argument"
    When call my_func world
    The line 1 of stdout should eq 'world'
    The status should be success
  End

  It "3. fails with more than 1 argument"
    When call my_func world moon
    The line 1 of stdout should eq 'world'
    The status should be failure
  End

  It "4. fails with no arguments"
    When call my_func
    The status should be failure
  End
End
