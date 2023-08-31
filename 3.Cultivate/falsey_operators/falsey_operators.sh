#!/usr/bin/env bash
# falsey_operators.sh

set -euo pipefail

N=1
RUN=something

[[ $RUN ]] && echo 'it ruNs' # Runs because run is falsey
[[ $RUN ]] && echo N = $N
[[ $RUN ]] && N=$((N + 1))
[[ $RUN ]] && echo N = $N

RUN=
[[ $RUN ]] && echo 'it should Not ruN' # Doesn't run because run is now truthy
