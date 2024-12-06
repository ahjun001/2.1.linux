#!/usr/bin/env bash
# ,sync_IHD_USB_spec.sh

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

Include './,sync_IHD_USB.sh'

It "shows the usage"
  When call Usage
    The output should include 'mimi / safe / home'
    The error should eq ''
    The status should be success
End

# make a soft link in /usr/local/sbin
LINK=/usr/local/sbin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
