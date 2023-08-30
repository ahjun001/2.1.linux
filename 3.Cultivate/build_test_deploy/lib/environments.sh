#!/usr/bin/env bash
# environments.sh
set -euo pipefail # will be propagated

### VARIABLES TO UNSET IN TEST ENVIRONMENT
export DBG="${DBG:=echo}" # print runtime infos  echo :

### DEFINING THE ENVIRONMENT
export ENV="${ENV:=DEV_ENV}"

case $ENV in
DEV_ENV)
    export DIR1=/tmp/dir_dev
    rm -rf $DIR1 && mkdir -p $DIR1
    ;;
TST_ENV) # most variables defined in ShellSpec
    :
    ;;
PRD_ENV)
    export DIR1=/tmp/dir_prod
    [[ -d $DIR1 ]] && exit 1
    ;;
*) echo "$ENV" not set properly ;;
esac

print_env() {
    printf "DBG = %s\n" "$DBG"
    printf "ENV = %s\n" "$ENV"
    printf "DIR1 = %s\n" "$DIR1"
}
