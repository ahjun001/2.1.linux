#!/usr/bin/env bash
# shellcheck source=/dev/null
set -euo pipefail

DISK="${DISK:=/tmp/test_dir}" && mkdir -p "$DISK"
# DISK=/home/perubu/
# DISK=/media/perubu/Toshiba_4TB
# DISK=/media/perubu/Blueend_BckUp

[[ -d $DISK ]] || {
    echo -e "\n$DISK not accessible\n"
    exit 1
}

# identifying master disk
MSTR="${MSTR:=/media/perubu/Toshiba_4TB}"
# MSTR=/home/perubu/Desktop/test

RVW="${RVW:=true}"   # true or not , review what is about to be deleted
TEST="${TEST:=true}" # true or not, run extra commands or functions
SKIP="${SKIP:=true}" # true or not, not to run commands that take too long
DBG="${DBG:=echo}"   # 'echo' :  , print runtime infos

$DBG $'\n'"${BASH_SOURCE[0]##*/}"

# empty trash so that it later contains only files that were trashed in the last operation
# nemo Trash:///
# [[ $(pgrep -f nemo) ]] && pkill -f nemo

### 1. SORT, Set, Shine, Standardise, Sustain: Eliminate clutter and unecessary items
SORT_STEP=2
case $SORT_STEP in
1) . erase_non_canonically_installed_dirs.sh ;&       # tested
2) . trash_links_empty_files_n_dirs.sh ;;             # tested
3) . standardize_dir_names.sh ;&                      # tested
4) echo "Have master dir names been standardized?" ;& #
5) . recreate_tree_on_disk_to_be_emptied ;&           # tested
*) printf "%s\n\n" 'SORT is done' ;;
esac
: && exit
# for testing purposes
($TEST && "$SKIP") || . ./03_create_test_dir_tree_on_hd.sh

# production steps
. ./03a_erase_non_canonically_installed_dirs.sh

"$SKIP" || . ./03b_trash_links_empty_files_n_dirs.sh

"$SKIP" || . ./03c_delete_ephemerals/03c_delete_ephemerals.sh

"$SKIP" || . ./03d_standardize_dir_names.sh

### 2. Sort, SET, Shine, Standardise, Sustain: Create a designated labelled place for each item.

: '
auto clean Wechat
hand clean Desktop, Downloads and other Rogues dirs
run dupes
'

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
