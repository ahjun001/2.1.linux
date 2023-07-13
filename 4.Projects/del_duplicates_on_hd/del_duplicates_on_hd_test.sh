#!/usr/bin/env bash

usage() {
    echo "Usage: $0 $OPTSTR"
    exit 1
}

ROOT='/tmp/fdupes_test'
OPTSTR='r:' # dev & test take default ROOT, prod requires ROOT to be defined
while getopts $OPTSTR flag; do
    case $flag in
    r)
        ROOT=${OPTARG}
        ;;
    *)
        usage
        ;;
    esac
done

# clean previous work
rm -r ${ROOT}

# creating dir
mkdir -p ${ROOT}/tmp1

# checking that directory exists
[ ! -d ${ROOT} ] && echo -e "Directory ${ROOT} DOES NOT exists.\nExiting ..." && exit

# creating files of various sizes
fallocate -l 1048576 ${ROOT}/1mebi.txt

# make copies
cp ${ROOT}/1mebi.txt ${ROOT}/1mebi_cp1.txt
cp ${ROOT}/1mebi.txt ${ROOT}/1mebi_cp2.txt

cp ${ROOT}/1mebi.txt ${ROOT}/1mebi_cp3.txt
touch ${ROOT}/1mebi_cp3.txt

cp ${ROOT}/1mebi.txt ${ROOT}/1mebi_diffa.txt
echo "a" >>${ROOT}/1mebi_diffa.txt
cp ${ROOT}/1mebi_diffa.txt ${ROOT}/1mebi_diffa1.txt
cp ${ROOT}/1mebi.txt ${ROOT}/1mebi_diffb.txt
echo "b" >>${ROOT}/1mebi_diffb.txt
cp ${ROOT}/1mebi_diffb.txt ${ROOT}/1mebi_diffb1.txt

cp ${ROOT}/1mebi.txt ${ROOT}/tmp1
