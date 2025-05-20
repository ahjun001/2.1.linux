#!/usr/bin/env bash
# ,kClean_html.sh
# This script cleans up HTML content from the clipboard and formats it for better readability.
set -euo pipefail

# Check if xclip or wl-clipboard is installed for clipboard access
if ! command -v wl-paste &>/dev/null; then
    echo "Error: wl-paste is not installed. Install wl-clipboard to use this script."
    exit 1
fi

if ! command -v wl-copy &>/dev/null; then
    echo "Error: wl-copy is not installed. Install wl-clipboard to use this script."
    exit 1
fi

# Get HTML content from clipboard using wl-paste
html_content=$(wl-paste)

# Check if clipboard is empty
if [ -z "$html_content" ]; then
    echo "Error: Clipboard is empty. Please copy some HTML content to the clipboard."
    exit 1
fi

# Process the HTML content
cleaned_content=$(
    echo "$html_content" |
        sed 's/&nbsp;/ /g' |
        sed 's/<\/div><div>/<br>\n/g' |
        sed 's/<br>/<br>\n/g' |
        sed 's/<div>/<br>\n/g' |
        sed 's/<\/div>/<br>\n/g' |
        sed 's/\r\r/\n/g' |
        sed 's/<h[1-3]>//g' |
        sed 's/<\/h[1-3]>//g' |
        sed 's/<em>/<i>/g' |
        sed 's/<\/em>/<\/i>/g' |
        sed 's/<strong>/<b>/g' |
        sed 's/<\/strong>/<\/b>/g' |
        sed 's/<li>/- /g' |
        sed 's/<\/li>/<br>\n/g' |
        sed 's/^[[:blank:]]*//g' |
        sed ':a;N;$!ba;s/\n\+\n\+/\n/g' |
        sed ':a;N;$!ba;s/-[[:blank:]]*<br>\n/- /g'
)

# Copy the cleaned content back to the clipboard
echo "$cleaned_content" | wl-copy

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
