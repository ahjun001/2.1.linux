#!/usr/bin/env bash
# clean_wechat_download.sh

: 'Scope and purpose
remove files that wechat downloads automatically, mostly pdfs, located under a set directory
'
: 'Todo
refactor
'
set -euo pipefail

# Hardcoded flags, see Usage
if [ "$#" -eq 0 ]; then set -- -p; fi

# TARGET='/run/media/perubu/Tosh_3TB/Documents/WeChat Files/wxid_6761767617821/FileStorage/File/'
# TARGET='/run/media/perubu/Tosh_3TB/Documents/11.Se_distraire/voir et jeter/PDFs/'
# TARGET='/run/media/perubu/Tosh_4TB/Documents/09.Lire/aa_lectures_en_vrac/journaux & livres/'
# TARGET='/run/media/perubu/Tosh_4TB/Downloads/Downloads/'
# TARGET='/run/media/perubu/Tosh_4TB/Misc/WeChat_Files/wxid_6761767617821/FileStorage/File/2022-09/'
TARGET='/run/media/perubu/Tosh_4TB/Misc/WeChat_Files/wxid_6761767617821/FileStorage/File/'
# TARGET='

DELETE_LIST=(
    l'argus
    mickey
    magicmaman
    macformat
    le\ cycle
    food\ \&\ home
    cyclingWeekly
    cosmopolitan
    avantages-
    australian\ hifi
    60_millions_de_consommateurs
    01net
    5China
    art_Press
    auto
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
    courrier_International
    cuisine
    d_tente_Jardin
    discover_Britain
    elle
    equ
    equipe
    femina
    femme\ Actuelle
    figTV
    financial\ times
    france_football
    humanite
    ici_Paris
    investir
    journal
    l.Essentiel.Du
    l\ Equipe
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
    madame
    magazine
    maison
    marianne
    marie_Claire
    mediapart
    mens\ Health
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
    saveurs
    so.Foot
    so\ Foot
    society
    stereophile
    strat_gies
    tV
    temps
    theNewYorker
    the_Economist
    the_New_Yorker
    tout.Comprendre
    true\ Detective
    télé\ Obs
    télérama
    vAR MATIN
    valeurs Actuelles
    voile
    wSJ
    wirtschaftswoche
    échos
    vogue
    santé_
    tendances
    science_illustrated
    rugby_
    pour\ la\ science
    Sant\é_
    syst\ème_D
    grande\ galerie
    l\'Argus
    gourmand
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
for name in "${DELETE_LIST[@]}"; do
    find "$ROOT" -iname "$name*.pdf" -print
done
find "$ROOT" -name '*.gif' -print

read -rsn 1 -p $'\nPress any key to delete these files ...\n\n' </dev/tty

for name in "${DELETE_LIST[@]}"; do
    find "$ROOT" -iname "$name*.pdf" -print -delete
done
find "$ROOT" -name '*.gif' -print -delete

df -h "$ROOT" >>"$FREESPACE"
echo -e '\n'
cat "$FREESPACE"
