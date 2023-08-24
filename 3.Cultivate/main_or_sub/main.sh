#!/usr/bin/env bash
# main.sh
set -euo pipefail

# shellcheck source=/dev/null
. ./lib.sh

my_var=world

echo -n 'Hello '
my_func $my_var