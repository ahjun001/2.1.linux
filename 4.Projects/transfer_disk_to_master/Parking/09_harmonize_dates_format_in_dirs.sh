#!/usr/bin/env bash

set -euo pipefail

# MASTER=/media/perubu/Toshiba_4T
MASTER=/home/perubu/Desktop/test

[[ -d $MASTER ]] || {
    echo -e "\n$MASTER not accessible\n"
    exit 1
}

# make test sample
rsync -av -f'+ */' -f'- *' /media/perubu/Toshiba_4T/Documents/5.General_Admin /home/perubu/Desktop/test

# while read -r filename; do
#     newname="${filename// /_}"
#     newname="${newname//\./-}"
#     echo "$newname"
#     mv -v "$filename" "$newname"
# done <<<"$(find $MASTER'/Documents/5.General_Admin/MGEN/Demandes de remboursement n relevés de prestations' -name '20[0-9][0-9]*')"

for file in "$MASTER"/Documents/5.General_Admin/MGEN/Demandes\ de\ remboursement\ n\ relevés\ de\ prestations/Demandes\ de\ remboursement\ -\ pjp/20[*; do
    # mv "$file" "${file// /_}"
    mv "$file" "${file//./-}"
done
