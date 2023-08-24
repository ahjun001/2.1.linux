#!/usr/bin/env bash

set -euo pipefail

# should run
RUN=;
$RUN echo ok

# should not run
RUN=:
$RUN echo not ok

echo the end
