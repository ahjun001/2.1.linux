#!/usr/bin/env bash
# ,kClean_html.sh
# This script cleans up HTML content from the clipboard for ANKI flashcards.

# If SOURCE_HTML is set, use it instead of clipboard (for testing)
if [ -n "${SOURCE_HTML:-}" ]; then
    html_content="$SOURCE_HTML"
else
    # Check if required tools are installed
    if ! command -v wl-paste &>/dev/null; then
        echo "Error: wl-paste is not installed. Install wl-clipboard to use this script." >&2
        exit 1
    fi
    # Get HTML content from clipboard using wl-paste
    html_content=$(wl-paste)
fi

# Check if input is empty
if [ -z "$html_content" ]; then
    echo "Error: No HTML content provided. Please copy some HTML content to the clipboard or set SOURCE_HTML." >&2
    exit 1
fi

# Process the HTML content - extract body content if present
# If no body tags, process the whole content
if echo "$html_content" | grep -q '<body>'; then
    # Has body tags - extract content between them
    content_to_clean=$(echo "$html_content" | sed -n '/<body>/,/<\/body>/p' | sed '1s/.*<body>//; $s/<\/body>.*//')
else
    # No body tags - use the content as-is
    content_to_clean="$html_content"
fi

# Clean the content
cleaned_content=$(
    echo "$content_to_clean" |
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
        # Convert &nbsp; to space
        sed 's/&nbsp;/ /g' |
        # Convert tags for ANKI compatibility
        sed 's/strong>/b>/g' |
        sed 's/em>/i>/g' |
        # Remove newlines to handle multi-line content
        sed ':a;N;$!ba;s/\n//g' |
        # Remove ALL div tags but KEEP their content
        sed 's/<div[^>]*>//g' |
        sed 's/<\/div>//g' |
        # Remove ALL span tags but KEEP their content
        sed 's/<span[^>]*>//g' |
        sed 's/<\/span>//g' |
        # Remove footnote references: <sup><a>[1]</a></sup> or <sup>[1]</sup>
        sed 's/<sup><a[^>]*>[^<]*<\/a><\/sup>//g' |
        sed 's/<sup>[^<]*<\/sup>//g' |
        # Remove empty <a> tags and <a> tags that only contain whitespace
        sed 's/<a[^>]*>[[:space:]]*<\/a>//g' |
        # Remove anchor-sup combinations (footnote references)
        sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta' |
        # Remove anchor tags BUT KEEP their content (link text)
        sed 's/<a[^>]*>//g' |
        sed 's/<\/a>//g' |
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
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
)

# If html-minifier is available, use it for compression
if command -v html-minifier &>/dev/null; then
    cleaned_content=$(echo "$cleaned_content" | html-minifier --collapse-whitespace --remove-comments --minify-css true --minify-js true 2>/dev/null)
fi

# Output the cleaned content
if [ -n "${TEST_MODE:-}" ]; then
    # In test mode, just echo the cleaned content
    echo "$cleaned_content"
else
    # Normal mode: copy to clipboard
    if ! command -v wl-copy &>/dev/null; then
        echo "Error: wl-copy is not installed. Install wl-clipboard to use this script." >&2
        exit 1
    fi
    echo "$cleaned_content" | wl-copy
    echo "HTML content cleaned and copied to clipboard!"
    
    # make a soft link in /usr/local/bin
    LINK=/usr/local/bin/"${0##*/}"
    FILE=$(realpath "$0")
    [[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
fi