#!/usr/bin/env bash
# ,kClean_html.sh
# This script cleans up HTML content from the clipboard for ANKI flashcards.
# Extracts and cleans content between <body> and </body> tags.
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

# Process the HTML content - extract body content and clean it
cleaned_content=$(
    echo "$html_content" |
        # Extract content between <body> and </body> tags
        sed -n '/<body>/,/<\/body>/p' |
        # Remove the <body> and </body> tags themselves
        sed '1s/.*<body>//; $s/<\/body>.*//' |
        # Remove attributes with double quotes
        sed 's/ id="[^"]*"//g' |
        sed 's/ class="[^"]*"//g' |
        sed 's/ href="[^"]*"//g' |
        sed 's/ role="[^"]*"//g' |
        sed 's/ style="[^"]*"//g' |
        sed 's/ src="[^"]*"//g' |
        # Remove attributes with single quotes
        sed "s/ id='[^']*'//g" |
        sed "s/ class='[^']*'//g" |
        sed "s/ href='[^']*'//g" |
        sed "s/ role='[^']*'//g" |
        sed "s/ style='[^']*'//g" |
        sed "s/ src='[^']*'//g" |
        # Convert tags for ANKI compatibility
        sed 's/strong>/b>/g' |
        sed 's/em>/i>/g' |
        # Remove newlines to handle multi-line content
        sed ':a;N;$!ba;s/\n//g' |
        # Remove outer div wrapper
        sed 's/^<div>//;s/<\/div>$//' |
        # Remove ALL div tags but KEEP their content
        sed 's/<div[^>]*>//g' |
        sed 's/<\/div>//g' |
        # Remove anchor-sup combinations (footnote references)
        sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta' |
        # Remove empty lines
        sed '/^[[:space:]]*$/d' |
        # Clean up extra whitespace (keep single spaces)
        sed 's/[[:space:]]\{2,\}/ /g' |
        # Remove spaces before >
        sed 's/[[:space:]]*>/>/g' |
        # Remove spaces after <
        sed 's/<[[:space:]]*/</g' |
        # Remove spaces between tags
        sed 's/>[[:space:]]*</></g' |
        # Remove leading/trailing spaces
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' |
        # Finally, use html-minifier for compression
        html-minifier --collapse-whitespace --remove-comments --minify-css true --minify-js true
)

# Copy the cleaned content back to the clipboard
echo "$cleaned_content" | wl-copy

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"

echo "HTML content cleaned and copied to clipboard!"