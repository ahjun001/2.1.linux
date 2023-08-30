#!/usr/bin/env bash
# environment_specs.sh
eval "$(shellspec - -c) exit 1"


BeforeEach $'
export ENV=TST_ENV
export DBG=:
export DIR1=/tmp/test_dir && mkdir -p "$DIR1" \
'

AfterEach $'rm -r "$DIR1"'

It 'runs with no output, no error'
    When run ./lib/environments.sh
        The output should eq ''
        The error should eq ''
        The status should be success
End

Include ./lib/environments.sh
It 'gets the correct environment for testing'
    When call print_env
        The output should not be empty file
        The output should include 'DBG = :'
        The output should include 'ENV = TST_ENV'
        The error should eq ''
        The status should be success
End