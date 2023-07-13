#!/usr/bin/env bash

# remove files that wechat downloads automatically
# some are good to keep to inspect: *.epub
# others, starting with names from delete_list can be deleted

set -e

old_wd=$(pwd)

cd '/home/perubu/Documents/WeChat Files/wxid_6761767617821/FileStorage/File' || exit

rm -fv free_space.txt
df -h / | tee -a free_space.txt

# for i in {0..9}; do
#     find . -name "*($i)*" -exec rm {} \;
# done

delete_list=(
    BBC
    Bloomberg
    'Business Traveller'
    Challenges
    Closer
    'Consumer Reports'
    Courrier_International
    Cuisine
    Échos
    Femina
    'Femme Actuelle'
    FigTV
    Ici_Paris
    Journal
    'La Croix'
    LaCroix
    'Le Figaro'
    lefigaro
    Le_Figaro
    Le_Journal
    'Le Journal'
    lemonde
    LeMonde
    'Le Monde'
    'LE MONDE'
    'Le nouvel'
    'Le Parisien'
    'Le Point'
    "L'Equipe"
    lequipe
    Les_Inrockuptibles
    'Le Temps'
    "L'Express"
    lhumanite
    "L'Obs"
    "L'Opinion"
    lesechos
    'Les Echos'
    libe
    lib1
    Madame
    Maison
    Marianne
    Marie_Claire
    "Mens Health"
    "Midi Olympique"
    Moustique
    Paris_Match
    TV
    Society
    Stereophile
    'Télé Obs'
    'Télérama'
    'True Detective'
    'Valeurs Actuelles'
    5China
)

my_command=delete
# my_command=print

for name in "${delete_list[@]}"; do
    find . -name "$name*.pdf" -"$my_command"
done

find . -name "*.gif" -"$my_command"

df -h / | tee -a free_space.txt

cat free_space.txt

cd "$old_wd" || exit
