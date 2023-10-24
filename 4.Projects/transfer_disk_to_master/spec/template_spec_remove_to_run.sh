#!/usr/bin/env bash

set -euo pipefail

# test fails if shellspec fails to load
eval "$(shellspec - -c) exit 1"

BeforeAll 'setup'
setup() {
    # Create a temporary directory for testing
    DISK=/tmp/test_dir
    mkdir -p "$DISK"

    # export all variables declare in script
    export DISK
    export DBG=:
}

It 'needs to be done'
End

AfterAll 'teardown'
teardown() {
    # Remove the temporary directory and its stub file
    rmdir "$DISK"
}
