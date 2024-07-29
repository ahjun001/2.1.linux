#!/usr/bin/env bash

set -euo pipefail

VOLUME="/run/media/perubu/Tosh_4TB/"
# MIN_SIZE=536870912
MIN_SIZE_MBi=20

fdupes -r --minsize $((1024 ** 2 * MIN_SIZE_MBi)) -- "$VOLUME" >min_size_${MIN_SIZE_MBi}.txt

: open in dolphin
