#!/usr/bin/env bash
# environment_specs.sh
eval "$(shellspec - -c) exit 1"

Before '
  ENV=TST_ENV
  . ./lib/environments.sh '



It 'runs with no output, no error'
    When run source ./src/module.sh
        The output should not be empty file
        The output should include 'DBG = :'
        The output should include 'ENV = TST_ENV'
        The output should include 'DIR1 = /tmp/tst_d1'
        The output should include 'DIR2 = /tmp/tst_d2'
        The error should eq ''
        The status should be success
End
