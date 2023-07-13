#!/usr/bin/env bash
set -euo pipefail
set -x
TEMP=/tmp/answer$$

# clean up and exit
housekeeping () {
    # clear
    rm -f $TEMP
    # exit
}


main_menu() {
    dialog \
        --title "MIS management" \
        -- menu "Select operation : " 10 60 5 \
        1 "Configurate: select a disk and see an overview" \
        2 "Clean selected disk" \
        3 "Remove duplicates" \
        4 "Review files & transfer" \
        5 "Exit" 2>$TEMP

    choice="cat $TEMP"
    case $choice in
    1) config_menu ;;
    2) clean_disk ;;
    3) remove_duplicates ;;
    4) review_files_n_transfer ;;
    5) housekeeping ;;
    esac

}

main_menu
