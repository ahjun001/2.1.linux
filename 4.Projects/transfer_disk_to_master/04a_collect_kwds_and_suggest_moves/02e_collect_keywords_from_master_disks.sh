#!/usr/bin/env bash

# TODO: make a research with two substrings
# use the following:
# find_dir_str1_str2() {
#   dir=$1
#   str1=$2
#   str2=$3

#   find "$dir" -type f -regextype posix-extended -regex ".*$str1.*$str2.*|.*$str2.*$str1.*"
# }


set -euo pipefail

# shellcheck source=/dev/null
. ./01_commons.sh
$DBG $'\nnow in '"$(basename "${BASH_SOURCE[0]}")"$'\n'

MASTER=/media/perubu/Toshiba_4T
[[ -d $MASTER ]] || {
    echo -e "\n$MASTER not accessible\n"
    exit 1
}

KWD='./02e_collect_kwds_and_suggest_moves'
[[ -d $KWD ]] || {
    echo -e "\n$KWD not accessible\n"
    exit 1
}
KWD=${KWD}/02e_master_keywords_n_dirs.txt

# to be removed later
rm -f $KWD

: ' dirs contains the sub-dir keywords, 
    prefix numbers are removes
    if name contains - or _ then only the first name is kept
'
for dir in \
    Documents/7.Pratiquer_un_hobby/08.Santé_nutrition \
    Documents/7.Pratiquer_un_hobby/12.Histoire_géographie/Histoire \
    Documents/7.Pratiquer_un_hobby/12.Histoire_géographie/Géographie \
    Documents/8.Regarder_un_film/Télécharger \
    Documents/1.Perso/2.Famille-amis-autres \
    Documents/2.Pro/5.Publications_good_reads \
    Documents/3.Info_tech_n_systems/a.Main_technos \
    Documents/9.Lire/aaa_BD \
    Documents/9.Lire \
    Music; do
    for d in $(find "$MASTER"/$dir -maxdepth 1 -type d,l | sed '1d'); do
        key=$(basename "$d")

        # remove digit point prefix
        key=${key/[0-9]\./}

        # remove whatever would follow the first - or _
        key=${key%%-*}
        key=${key%%_*}

        # remove keys that create results that are too general
        for r in \
            aaa \
            AC \
            css \
            Emily \
            html \
            James \
            Math \
            Paris; do
            Icomp "$key" $r && continue 2
        done

        # add to file
        echo "$key $d" >>$KWD
    done
done
