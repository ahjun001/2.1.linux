#!/usr/bin/env bash
# environments.sh
set -euo pipefail # will be propagated

ENV="${ENV:=DEV_ENV}"

case $ENV in
DEV_ENV)
    DBG="${DBG:=echo}" # print runtime infos  echo :
    DIR1=/tmp/dev_d1 && rm -rf $DIR1 && mkdir -p $DIR1
    DIR2=/tmp/dev_d2 && rm -rf $DIR2 && mkdir -p $DIR2
    ;;
TST_ENV)
    DBG="${DBG:=:}" # print runtime infos  echo :
    DIR1=/tmp/tst_d1 && rm -rf $DIR1 && mkdir -p $DIR1
    DIR2=/tmp/tst_d2 && rm -rf $DIR2 && mkdir -p $DIR2
    ;;
PRD_ENV)
    DBG="${DBG:=echo}" # print runtime infos  echo :
    DIR1=/tmp/prod_d && [[ -d $DIR1 ]] && exit 1
    DIR2=/tmp/prod_d && [[ -d $DIR2 ]] && exit 2
    ;;
*) echo "$ENV" not set properly ;;
esac
