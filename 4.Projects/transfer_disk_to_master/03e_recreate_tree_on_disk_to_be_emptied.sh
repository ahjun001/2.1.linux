#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

$FAST || ./03d_standardize_dir_names.sh "$MSTR"

# recreate directory tree on disk
rsync -au -f"+ */" -f"- *" "$MSTR"/ "$DISK"

# check that $VRAC exists
[[ -d $VRAC ]] || {
    echo "$VRAC" was not created properly, exiting ...
    exit 1
}