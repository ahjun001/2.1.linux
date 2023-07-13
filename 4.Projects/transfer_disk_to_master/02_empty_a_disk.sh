#!/usr/bin/env bash
# shellcheck source=/dev/null

set -euo pipefail

. ./01_commons.sh

# empty trash so that it later contains only files that were trashed in the last operation
nemo Trash:///
[[ $(pgrep -f nemo) ]] && pkill -f nemo

### SORT, Set, Shine, Standardise, Sustain: Eliminate clutter and unecessary items

# for testing purposes
($TEST && "$FAST") || . ./03_create_test_dir_tree_on_hd.sh

# production steps
. ./03a_erase_non_canonically_installed_dirs.sh

"$FAST" || . ./03b_trash_links_empty_files_n_dirs.sh

"$FAST" || . ./03c_delete_ephemerals/03c_delete_ephemerals.sh

"$FAST" || . ./03d_standardize_dir_names.sh

### Sort, SET, Shine, Standardise, Sustain: Create a designated labelled place for each item.

. ./03e_recreate_tree_on_disk_to_be_emptied.sh

. ./03f_manage_wechat_folders.sh

. ./03g_manually_reposition_dirs_in_DDMPV.sh

. ./03h_remove_duplicates/03h_remove_duplicates.sh

baobab "$DISK"

# . ./03g_collect_kwds_and_suggest_moves/02e_collect_keywords_from_master_disks.sh &&
# . ./03g_collect_kwds_and_suggest_moves/02e_scrawl_disk_n_suggest_moves.sh

# . ./03_check_conventional_dirs_for_files_to_keep.sh

: "
SORT, Set, Shine, Standardise, Sustain: Eliminate clutter and unecessary items
Sort, SET, Shine, Standardise, Sustain: Create a designated labelled place for each item.
Sort, Set, SHINE, Standardise, Sustain: Regular upkeep to ensure that the workspace remains organized and efficient
Sort, Set, Shine, STANDARDISE, Sustain: Establish standard procedures, guidelines and schedule
Sort, Set, Shine, Standardise, SUSTAIN: Make part of daily routine so as to improve progressively

"
: "
Todo rewrite in English and as is being performed

0. nettoyer les disques maitres
    Sur l'ensemble du disque:
        éliminer les venv, notamment python, éventuellement les remplacer par un fichier requirements.txt
        ce qui permet d'éliminer les doublons
        Identifier & sauvegarder les dir de configurations cachés
    Puis, un répertoire à la fois:
        transférer la librairie calibre dans à lire et effacer le répertoire
        transférer le contenu de Desktop et effacer le répertoire
        transférer le contenu de PDF et effacer le répertoire
    
1. recréer un arborescence sur le disque à vider à partir des disques maitres
2. éliminer les doublons sur le disque à vider
3. éliminer les doublons entre le disque à vider et les disques maitres
"

: "
Eliminates dupes efficiently, that is:
- minimize number of files being inspected, in particular:
    venv, go, npm
- standardize directory names
- manually reposition directories in 'Documents Downloads Music Pictures Videos'
- automatically reposition
Documents  .epub .pdf
Music  .mp3
Pictures .png .jpeg .jpg 
Videos .mp4 .avi .mvk
files in a likely 'staged' directory
and then run rdfind
"
