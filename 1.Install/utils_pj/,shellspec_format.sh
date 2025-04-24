#!/usr/bin/env bash
# ,shellspec_format.sh
set -euo pipefail

# Indent level
declare -i INDENT=0
declare -i SHIFT_W=2
BLANK=
DATA=
WHEN=

# Loop through each line
while read -r line; do
    if [[ $line =~ ^('It'|'Specify'|'Example'|'Context'|'Describe'|'ExampleGroup') ]]; then
        # Increase INDENT after keyword line
        printf "%${INDENT}s%s\n" "" "$line"
        INDENT=$((INDENT + SHIFT_W))

    elif [[ $line =~ ^End$ ]]; then
        # Decrease INDENT before printing End
        if [[ $DATA ]]; then
            # DATA is on from previous lines, so no indent
            DATA=
        else
            INDENT=$((INDENT - SHIFT_W))
            [[ $WHEN ]] && INDENT=$((INDENT - SHIFT_W)) && WHEN=
        fi
        printf "%${INDENT}s%s\n" "" "$line"

    elif [[ $line =~ ^('When') ]]; then
        # Increase INDENT after keyword line
        printf "%${INDENT}s%s\n" "" "$line"
        ! [[ $WHEN ]] && INDENT=$((INDENT + SHIFT_W)) && WHEN=1 # next WHEN won't indent
        # The previous data, if there was one, is over
        DATA=

    elif [[ $line =~ ^[[:space:]]*$ ]]; then
        printf "%${INDENT}s%s\n" "" "$line"
        [[ $BLANK ]] && INDENT=$((INDENT + SHIFT_W)) && BLANK=1 # next blank won't intend

    elif [[ $line =~ ^('Data') ]]; then
        DATA=1
        printf "%${INDENT}s%s\n" "" "$line"

    else
        # Print other lines with current INDENTation
        printf "%${INDENT}s%s\n" "" "$line"
    fi

    # done  # to be used with ShellSpec, then input is stdin, output is stdout
done <<< \
    "$(xclip -selection clipboard -o)" |
    xclip -selection clipboard

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
