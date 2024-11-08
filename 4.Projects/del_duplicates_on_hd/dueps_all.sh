#!/usr/bin/env bash
# dupes_all.sh

set -euo pipefail

MEGA='000000'
MINSIZE=1"$MEGA"
DUPES='dupes_list.txt'

PGM=${0##*/}

Usage() {
    cat <<EOF
Usage: $PGM [-t] [-p]
  -t        Run in test mode (root directory: /tmp/fdupes_test)
  -p        Run in production mode (default: false, root directory: /run/media/perubu/Tosh_4TB)
EOF
    echo "Exiting ..." && exit 1
}

Fresh_can() {
    local ROOT=$1

    echo -e "\nPreparing canned data ..."

    # Clean previous work
    rm -rf "${ROOT}"
    mkdir -p "${ROOT}/tmp1" "${ROOT}/tmp2" "${ROOT}/tmp3"

    # Create files of various sizes
    for size in 1M 2M 3M; do
        fallocate -l "${size}" "${ROOT}/${size}.txt"
    done

    # Make copies
    local base_file="${ROOT}/1M.txt"
    cp -v "${base_file}" "${ROOT}/1M_cp1.pdf"
    cp -v "${base_file}" "${ROOT}/1M_cp2.epub"
    cp -v "${base_file}" "${ROOT}/1M_cp3.mp3"
    touch "${ROOT}/1M_cp3.mp4"
    cp -v "${base_file}" "${ROOT}/1M_diffa.txt"
    cp -v "${ROOT}/1M_diffa.txt" "${ROOT}/1M_diffa1.avi"
    cp -v "${base_file}" "${ROOT}/1M_diffb.txt"
    cp -v "${ROOT}/1M_diffb.txt" "${ROOT}/1M_diffb1.webm"
    cp -v "${base_file}" "${ROOT}/tmp1"
    cp -v "${ROOT}/2M.txt" "${ROOT}/tmp2"
    cp -v "${ROOT}/3M.txt" "${ROOT}/tmp2"
    cp -v "${ROOT}/3M.txt" "${ROOT}/tmp3"
}

Create_dupes_list() {
    # Create dupes list
    echo -e "# $DUPES\n" >"$DUPES"
    time fdupes --recurse --minsize="$MINSIZE" --size --order=name "$ROOT" >>"$DUPES"
}

Process_lines_with_slash() {
    local num_lines=${#lines_with_slash[@]}
    if [ "$num_lines" -ne 0 ]; then
        for l in "${lines_with_slash[@]}"; do echo "$l"; done
        for ((i = 0; i < num_lines; i += 2)); do
            if [ $((i + 1)) -lt "$num_lines" ]; then
                dolphin --split --new-window \
                    "$(dirname "${lines_with_slash[$i]}")" \
                    "$(dirname "${lines_with_slash[$i + 1]}")" 2>/dev/null &
            else
                dolphin --new-window \
                    "$(dirname "${lines_with_slash[$i]}")" 2>/dev/null &
            fi
        done
        echo
        read -rsn 1 -p "Press any key to continue...\n" </dev/tty
        clear
        lines_with_slash=()
        [[ $(pgrep dolphin) ]] && killall dolphin
    fi
}

Review_dupes_list() {
    # Close all opened Dolphin instances
    [[ $(pgrep dolphin) ]] && killall dolphin

    # Array to store the lines starting with '/'
    local lines_with_slash=()

    # Read the input file line by line
    while read -r line; do
        if [[ "$line" =~ ^/ ]]; then
            lines_with_slash+=("$line")
        else
            Process_lines_with_slash
        fi
    done <"$DUPES"
}

# Main
if [ "$#" -eq 0 ]; then set -- -t; fi
while getopts 'tp' flag; do
    case "${flag}" in
    t)
        ROOT='/tmp/fdupes_test'
        Fresh_can "$ROOT"
        ;;
    p)
        ROOT='/run/media/perubu/Tosh_4TB'
        ;;
    *) Usage ;;
    esac
done

Create_dupes_list
Review_dupes_list
