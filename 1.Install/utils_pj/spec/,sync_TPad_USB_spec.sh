#!/usr/bin/env bash
# ,sync_TPad_USB_spec.sh

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

Include './,sync_TPad_USB.sh'

It "shows the usage"
  When call Usage
    The output should include 'mimi / safe'
    The error should eq ''
    The status should be success
End
