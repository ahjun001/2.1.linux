#!/usr/bin/env bash
# environment_specs.sh
eval "$(shellspec - -c) exit 1"

Before '
  ENV=TST_ENV
  . ./lib/environments.sh '



It 'RUNS WITH NO OUTPUT, NO ERROR'
    When run ./lib/environments.sh
        The output should eq ''
        The error should eq ''
        The status should be success
End

Include ./lib/lib.sh
It 'GETS THE CORRECT ENVIRONMENT FOR TESTING'
    When call print_env
        The output should not be empty file
        The output should include 'DBG = :'
        The output should include 'ENV = TST_ENV'
        The error should eq ''
        The status should be success
End