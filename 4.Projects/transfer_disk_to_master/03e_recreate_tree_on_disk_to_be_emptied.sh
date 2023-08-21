#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./00_commons.sh
$DBG $'\n'"$(basename "${BASH_SOURCE[0]}")"$'\n'

$SKIP || ./03d_standardize_dir_names.sh "$MSTR"

# recreate directory tree on disk
rsync -au -f"+ */" -f"- *" "$MSTR"/ "$DISK"

# check that $VRAC exists
[[ -d $VRAC ]] || {
    echo "$VRAC" was not created properly, exiting ...
    exit 1
}