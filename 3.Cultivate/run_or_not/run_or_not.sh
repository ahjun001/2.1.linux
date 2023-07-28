#!/usr/bin/env bash

set -euo pipefail
set -x

# should run
RUN=;
$RUN echo ok

# should not run
RUN=:
$RUN echo not ok
echo ok
