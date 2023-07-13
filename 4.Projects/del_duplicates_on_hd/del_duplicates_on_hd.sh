#!/usr/bin/env bash

usage() {
    echo "Usage: $0 $OPTSTR"
    exit 1
}

TEST_DIR='/tmp/fdupes_test'
ROOT=${TEST_DIR}
OPTSTR='r:' # dev & test take default ROOT, prod requires ROOT to be defined
# requires nothing (default, will continue execution) or -r arg, other situations will trigger getops error message and exit
while getopts $OPTSTR flag; do
    case $flag in
    r) ROOT=${OPTARG} ;;
    *) usage ;;
    esac
done

# creating or checking existance of root directory
if [ "${ROOT}" = ${TEST_DIR} ]; then
    filename=$0
    filename="${filename%.*}"
    test_file="${filename}""_test.sh" # adding _test to file being tested by convention
    ./"${test_file}" -r "${ROOT}"
else
    [ ! -d "${ROOT}" ] && echo -e "Directory ${ROOT} DOES NOT exists.\nExiting ..." && exit
fi

fdupes -rdNS -o name "${ROOT}"
# r recurse
# d delete
# N no prompt
# S show size of duplicates
# o name

echo -e "\n\n"

find "${ROOT}" -type f -name '*.txt'
