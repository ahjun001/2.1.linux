#!/usr/bin/env bash
set -euo pipefail

# : 'select disk to be inspected'
# DISK=/media/perubu/Toshiba_4T
[[ -d $DISK ]] || {
echo -e "\n$DISK not accessible\n"
exit 1
}
DISK=/home/perubu/Desktop/test

# overview
# baobab $DISK

: ' Define canonical level-1 directories
lev1Dirs=(
    Documents
    Pictures
    Videos
    Music
) '

# shellcheck disable=SC2035
if ! [[ $DISK == *'media'* ]]; then rm -rv $DISK; fi

# Create canonical level-2 directories
# shellcheck disable=SC2034
declare -a DocDirs=(
    1.Perso
    2.Pro
    3.Info\ tech\ n\ systems
    4.Chinois
    5.General\ Admin
    6.My\ pics\ n\ vids
    7.Pratiquer\ un\ hobby
    8.Lire
    9.Ecouter\ et\ chanter
    10.Se\ distraire
    Non\ classé
    Github
)

# shellcheck disable=SC2034
PicsDirs=(
    Chronos
    PJ
    Non\ classé
)

# shellcheck disable=SC2034
VidsDirs=(
    Ã\ voir
    Déja\ vu
    Classé
    Non\ classé
)

# shellcheck disable=SC2034
AudioDirs=(
    Musique
    China stories
    Andrew Huberman
    Podcasts
    Meditations
    NSDR
    Tango\ Music
    Poèmes
)

for d in "${DocDirs[@]}"; do mkdir -p $DISK/Documents/"$d"; done
for d in "${PicsDirs[@]}"; do mkdir -p $DISK/Pictures/"$d"; done
for d in "${VidsDirs[@]}"; do mkdir -p $DISK/Videos/"$d"; done
for d in "${AudioDirs[@]}"; do mkdir -p $DISK/Music/"$d"; done


tree -d $DISK
