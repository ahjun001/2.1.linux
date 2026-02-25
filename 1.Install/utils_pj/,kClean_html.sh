#!/usr/bin/env bash
# ,kClean_html.sh
# This script cleans up HTML content from the clipboard and formats it for better readability.
set -xeuo pipefail

#!/usr/bin/env bash
# ,kClean_html.sh
# This script cleans up HTML content from the clipboard using html-minifier and copies it back to the clipboard
set -xeuo pipefail

# Check if required tools are installed
if ! command -v wl-paste &>/dev/null; then
    echo "Error: wl-paste is not installed. Install wl-clipboard to use this script."
    exit 1
fi

if ! command -v wl-copy &>/dev/null; then
    echo "Error: wl-copy is not installed. Install wl-clipboard to use this script."
    exit 1
fi

if ! command -v html-minifier &>/dev/null; then
    echo "Error: html-minifier is not installed. Install it using npm: npm install -g html-minifier"
    exit 1
fi

# Get HTML content from clipboard using wl-paste
html_content=$(wl-paste)

# Check if clipboard is empty
if [ -z "$html_content" ]; then
    echo "Error: Clipboard is empty. Please copy some HTML content to the clipboard."
    exit 1
fi

# Process the HTML content using html-minifier
cleaned_content=$(
    echo "$html_content" |
        sed -n '/^<body>/q; p' |
        sed 's/ id=[^>]*>/>/g' |
        sed 's/ class=[^>]*>/>/g' |
        sed 's/ href=[^>]*>/>/g' |
        sed 's/ role=[^>]*>/>/g' |
        sed 's/ style=[^>]*>/>/g' |
        sed 's/ src=[^>]*>/>/g' |
        sed 's/strong>/g>/b' |
        # sed 's/&nbsp;/ /g' |
        sed 's/<div>\b.<\/div>//g' |
        sed 's/<div>[[:space:]]*<\/div>//g' |
        sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta' |
        sed '/^[[:space:]]*$/d' |
        html-minifier --collapse-whitespace
)

# Copy the cleaned content back to the clipboard
echo "$cleaned_content" | wl-copy

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
