#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

TEST &&=
$TEST && mkdir /tmp/test
ls -d /tmp/test
$TEST && touch /tmp/test/filetest
ls /tmp/test
$TEST && rm -r /tmp/test
