#!/usr/bin/env bash
# /usr/local/bin/_mpv_launch.sh

set -euo pipefail

DBG=  # : or nothing to be in debug mode
$DBG set -x

PGM="${0##*/}"

Usage() {
    cat <<.

$PGM assumes that the command launch directory has exactly one video file
and two subtitle files ending in fr-FR.<suffix> en-US.<suffix> and zh-CN.<suffix>
<suffix> being srt or vtt

    usage: $PGM <primary-sid  secondary-sid>

    examples: $PGM
              $PGM 2 3  # primary-sid=1 secondary-sid=2
.
}

validate_input() {
    if [[ $# != 0 && $# != 2 ]]; then Usage && exit 1; fi

    if [[ $# = 2 ]]; then
        SID=$1
        SEC_SID=$2
    else
        SID=1
        SEC_SID=3
    fi

    if ! [[ $SID =~ ^[0-9]+$ ]]; then
        echo "Error: primary-sid must be a number."
        exit 1
    fi

    if ! [[ $SEC_SID =~ ^[0-9]+$ ]]; then
        echo "Error: secondary-sid must be a number."
        exit 1
    fi
}

find_movie_file() {
    for file in *; do
        if [[ $file =~ \.(mp4|mkv|webm|avi)$ ]]; then
            MOVIE_FILE=$file
            break
        fi
    done
}

process_subtitles_files() {

    SUB_FILES[0]=
    for file in *.srt *.vtt; do
        if [[ $file =~ (en-US.srt|en-US.vtt|fr-FR.srt|fr-FR.vtt)$ ]]; then
            SUB_FILES[0]=$file
            break
        fi
    done
    echo "$SID" "${SUB_FILES[0]}"

    SUB_FILES[1]=
    for file in *.srt *.vtt; do
        if [[ $file =~ (zh-CN.srt|en-US.vtt|zh-CN.srt)$ ]]; then
            SUB_FILES[1]=$file
            break
        fi
    done
    echo "$SEC_SID" "${SUB_FILES[1]}"
}

main() {
    validate_input "$@"

    find_movie_file
    ffprobe -hide_banner "$MOVIE_FILE"

    process_subtitles_files

    mpv "$MOVIE_FILE" \
        --sub-file="${SUB_FILES[0]}" --sid="$SID" \
        --sub-file="${SUB_FILES[1]}" --secondary-sid="$SEC_SID" \
        --no-sub-ass \
        --sub-font-size=40 --sub-color=#fff000
}

main "$@"

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
