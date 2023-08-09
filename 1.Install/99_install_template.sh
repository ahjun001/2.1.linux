#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. ~/Documents/Github/2.1.linux/1.Install/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}"

# Exit if APP is already installed
APP="${APP:?}"
# if command -v "$APP" >/dev/null; then
#     $DBG $'\t'"$APP" is already installed
#     [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 0 || return 0
# fi

# forcing to install if launched from CLI
# when sourced, exiting if package is already installed
if [[ "$0" == "${BASH_SOURCE[0]}" ]] || ! command -v "$APP"; then

    case $ID in
    fedora)
        $DBG -e "\n$APP not implemented in $ID\n"
        ;;
    linuxmint | ubuntu)
        $DBG -e "\n$APP not implemented in $ID\n"
        ;;
    *)
        echo "Distribution $ID not recognized, exiting ..."
        exit 1
        ;;
    esac

    LINKS="${0#/*}"/links_pj.sh
    [[ -f $LINKS ]] && $LINKS

    $RUN "$APP"

fi
