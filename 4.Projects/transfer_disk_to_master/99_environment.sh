#!/usr/bin/env bash
# shellcheck disable=SC2034

# use DBG to print runtime infos
DBG='echo'
# DBG=:

# use TEST && NOT to run extra commands or functions
# particularly building testing environments
TEST=true
# TEST=false
 
# use RVW to see what is about to be deleted
RVW=true

# use SKIP not to run commands that take too long
# that are known be have already been run successfully
# or that we don't want to run to preserve working disk when in development phase
# SKIP=true
SKIP=false

# identifying master disk
MSTR=/media/perubu/Toshiba_4TB
# MSTR=/home/perubu/Desktop/test

DISK=/tmp/test_dir && mkdir -p "$DISK"
# DISK=/home/perubu/
# DISK=/media/perubu/Toshiba_4TB
# DISK=/media/perubu/Blueend_BckUp

[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

# Directory to store all books blindly collected by WeChat
VRAC="$DISK"/Documents/9.Lire/aa_lectures_en_vrac
