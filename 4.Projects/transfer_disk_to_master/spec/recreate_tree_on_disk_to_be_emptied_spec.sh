#!/usr/bin/env bash
# spec/recreate_tree_on_disk_to_be_emptied_spec.sh

set -euo pipefail
eval "$(eval shellspec - -c) exit 1"

Before 'setup'
setup(){
    DISK=/tmp/test_dir
    mkdir -p "$DISK"
    export DISK
    DBG=:
    export DBG
}


Describe 'recreate_tree_on_disk_to_be_emptied.sh'

  It 'creates the test disk directory'
    When run ./recreate_tree_on_disk_to_be_emptied.sh
    The directory /tmp/test_dir should be exist
    The status should be success
  End

  It 'creates the VRAC directory'
    When run ./recreate_tree_on_disk_to_be_emptied.sh
    The directory "$DISK"/Documents/9.Lire/aa_lectures_en_vrac should be exist
    The status should be success
  End
End
