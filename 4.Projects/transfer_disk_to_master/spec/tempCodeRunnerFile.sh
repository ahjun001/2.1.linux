  It "calculates max depth correctly"
    mkdir -p /tmp/test/nested/directories
    DISK=/tmp/test
    DBG='echo'
    When run ./standardize_dir_names.sh
    The output should include "max depth of directory tree = 5"
    rm -rf /tmp/test
  End