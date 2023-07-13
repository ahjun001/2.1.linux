#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

find /media/perubu/Toshiba_4T -type f ! -name "*.mp4" ! -name "*.mp3" ! -name "*.jpg" ! -name "*.opus" ! -name "*.sh" ! \
    -name "*.pdf" ! -name "*.mobi" ! -name "*.azw3" ! -name "*.epub" ! -name "*.rar" ! -name "*.odg" ! -name "*.txt" \
    ! -name "*.uni" ! -name "*.wenlin" ! -name "*.py" ! -name "*.png" ! -name "*.webp" ! -name "*.json" ! -name "*.js" \
    ! -name "*.gif" ! -name "*.exe" ! -name "*.css" ! -name "*.xls" ! -name "*.srt" ! -name "*.webm" ! -name "*.vtt" \
    ! -name "*.svg" ! -name "*.torrent" ! -name "*.jpeg" ! -name "*.ods" ! -name "*.sql" ! -name "*.odt" ! -name "*.gz" \
   ! -name "*.whl" ! -name "*.xml" ! -name "*.xlsx" ! -name "*.eps"
