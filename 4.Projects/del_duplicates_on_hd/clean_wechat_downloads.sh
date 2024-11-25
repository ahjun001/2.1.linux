#!/usr/bin/env bash
# clean_wechat_download.sh

# shellcheck disable=SC1001

: 'Scope and purpose
remove files that wechat downloads automatically, mostly pdfs, located under a set directory
'
: 'Todo
refactor
'
set -euo pipefail

# Hardcoded flags, see Usage
if [ "$#" -eq 0 ]; then set -- -p; fi

TARGET='/run/media/perubu/Tosh_4TB/Documents/t0/t1/t/21. epub_n_pdf/pdf/'
# TARGET='

START_WITH_LIST=(
    cyclisme
    vital_food
    01net
    5China
    60_millions_de_consommateurs
    art_Press
    australian\ hifi
    auto
    avantages-
    bBC
    bild
    bloomberg
    bois
    business\ Traveller
    c_est_Votre_Argent
    canEnch
    canard
    causette
    cerveau
    challenges
    charlie
    closer
    connaissance
    consumer\ Reports
    cosmopolitan
    courrier_International
    cuisine
    cyclingWeekly
    d_tente_Jardin
    discover_Britain
    elle
    equ
    equipe
    femina
    femme\ Actuelle
    figTV
    financial\ times
    food\ \&\ home
    france_football
    gourmand
    grande\ galerie
    humanite
    ici_Paris
    investir
    journal
    l\'argus
    l.Essentiel.Du
    l\ Equipe
    l\'Argus
    l\'Equipe
    l\'Express
    l\'Obs
    l\'Opinion
    l\'Équipe
    l\’Opinion
    l\’equipe
    l_Express
    l_Humanite
    l_Obs
    l_Opinion
    l_equipe
    laCroix
    la\ Croix
    la_Sarthe
    leMonde
    le\ Figaro
    le\ Journal
    le\ Monde
    le\ Parisien
    le\ Point
    le\ Temps
    le\ cycle
    le\ nouvel
    le_Bouvet
    le_Chasseur_Fran
    le_Figaro
    le_Journal
    le_Monde
    le_Parisien
    le_Temps
    lefigaro
    leparis
    lequipe
    les\ Echos
    les_Cahiers
    les_Echos
    les_Inrockuptibles
    lesechos
    lhumanite
    lib
    lmnd
    mIT_Sloan
    mONACO\ MATIN
    macformat
    madame
    magazine
    magicmaman
    maison
    marianne
    marie_Claire
    mediapart
    mens\ Health
    mickey
    midi
    midi\ Olympique
    mieux_Vivre_Votre_Argent
    moustique
    nICE\ MATIN
    nat.Geo.
    nature
    newScientist
    ouest\ France
    parenth_se
    paris_Match
    pour\ la\ science
    rugby_
    santé_
    santé_
    saveurs
    science_illustrated
    so.Foot
    so\ Foot
    society
    stereophile
    strat_gies
    système_D
    tV
    temps
    tendances
    theNewYorker
    the_Economist
    the_New_Yorker
    tout.Comprendre
    true\ Detective
    télé\ Obs
    télérama
    vAR MATIN
    valeurs Actuelles
    vogue
    voile
    wSJ
    wirtschaftswoche
    échos
    fig
    express
)

CONTAINS_LIST=(
    toddler
    corona
    covid
    ielts
    job
    kid
    libe
    mickey
    newyork
    posting
    spec
    wallstreet
    wsj
)

Fresh_can() {
    local ROOT=$1

    echo -e "\nPreparing canned data ...\n"
    # Clean previous work
    rm -rf "${ROOT}"
    mkdir -p "${ROOT}/tmp1" "${ROOT}/tmp2" "${ROOT}/tmp3"

    # Make a few files
    touch \
        "${ROOT}/LeMonde.pdf" \
        "${ROOT}/L'Obs.pdf" \
        "${ROOT}/some.gif" \
        "${ROOT}/tmp1/L'Équipe.pdf" \
        "${ROOT}/tmp1/L'Equipe.pdf" \
        "${ROOT}/tmp2/L'Express.pdf" \
        "${ROOT}/tmp2/some.gif" \
        "${ROOT}/tmp3/LeMonde.pdf"
}

PGM=${0##*/}
Usage() {
    cat <<.
    Usage: $PGM [-t] [-p]
      --        no flags will default to -t, so that edit & run is faster in VSCode
      -h        Display this message & exit
      -t        Run in test mode (root directory: /tmp/clean_wechat)
      -p        Run in production mode (default: false, root directory: /run/media/perubu/Tosh_4TB)
      -d        Will delete files that it found
.
    echo -e "Exiting ...\n" && exit 1
}

# setting root according to environment, possibly setting a testing environment
# MODE=''
while getopts 'htpd' flag; do
    case "${flag}" in
    t)
        ROOT='/tmp/clean_WC_downloads'
        Fresh_can "$ROOT"
        ;;
    p)
        ROOT=$TARGET
        rm -rf '/run/media/perubu/Tosh_4TB/.Trash-1000/files/'
        ;;
    d)
        # MODE='-delete'
        echo -e 'Will delete files it had found ...\n'
        ;;
    h*) Usage ;;
    esac
done

# record space freed
INI_WD=$(pwd)
FREESPACE="$INI_WD/free_space.txt"

df -h "$ROOT" >"$FREESPACE"

# recording current directory
dolphin --new-window "$ROOT" 2>/dev/null &

read -rsn 1 -p $'Press any key to continue...\n\n' </dev/tty

# Main
for name in "${START_WITH_LIST[@]}"; do
    find "$ROOT" -iname "$name*.pdf" -print
done
find "$ROOT" \
    \( -name '*.gif' \
    -o -name '*tmp' \) -print

read -rsn 1 -p $'\nPress any key to mark more files for deletion ...\n\n' </dev/tty

for name in "${CONTAINS_LIST[@]}"; do
    find "$ROOT" -iname "*$name*.pdf" -print
done

read -rsn 1 -p $'\nPress any key to delete listed files ...\n\n' </dev/tty

for name in "${START_WITH_LIST[@]}"; do
    find "$ROOT" -iname "$name*.pdf" -print -delete
done
find "$ROOT" -name '*.gif' -print -delete
find "$ROOT" \
    \( -name '*.gif' \
    -o -name '*tmp' \) -print -delete

for name in "${CONTAINS_LIST[@]}"; do
    find "$ROOT" -iname "*$name*.pdf" -print -delete
done

df -h "$ROOT" >>"$FREESPACE"
echo -e '\n'
cat "$FREESPACE"
