#!/usr/bin/env bash
# deepseek2adoc._pj.sh - Convert MHTML to AsciiDoc with cleanup
# To save a DeepSeek search in adoc format, first save the web page as single file, format mhtml, name input.mhtml
# Then run this script and clean results

set -euo pipefail

# Define input/output files
INPUT_MHTML="input.mhtml"
EXTRACT="extract.html"
DECODED_HTML="decoded.html"
RAW_ADOC="input.adoc"
OUTPUT_ADOC="output.adoc"

# Extract HTML content from MHTML
extract_html() {
    sed -n "/Content-Type: text\/html/,/'----MultipartBoundary--'/p" "$INPUT_MHTML" |
        sed '1d; $d' >"$EXTRACT"
}

# Decode quoted-printable HTML
decode_html() {
    perl -MMIME::QuotedPrint -0777 -nle 'print decode_qp($_)' "$EXTRACT" >"$DECODED_HTML"
}

# Convert HTML to AsciiDoc
convert_to_adoc() {
    pandoc -f html -t asciidoc -o "$RAW_ADOC" "$DECODED_HTML"
}

# Clean up AsciiDoc content
clean_adoc() {
    local tmpfile
    tmpfile=$(mktemp)

    # Apply all sed transformations in a single pass
    sed -e "s/\[.ds-markdown-cite\]\#[0-9]*\#//g" \
        -e "/^image:data:image/d" \
        -e '/^AI-generated/,$d' \
        -e "/^$\n^$/d" \
        "$RAW_ADOC" >"$tmpfile"

    mv "$tmpfile" "$RAW_ADOC"
}

# Create output template
create_template() {
    cat <<-'EOF' >"$OUTPUT_ADOC"
	= Title ???
	:backend: asciidoctor
	:github-flavored:  // enables GitHub-specific features like tables, task lists, and fenced code blocks
	ifndef::env-github[:icons: font]
	ifdef::env-github[]
	// Naughty Waco Temps
	:note-caption: :paperclip:
	:tip-caption: :bulb:
	:warning-caption: :warning:
	:caution-caption: :fire:
	:important-caption: :exclamation:
	endif::[]
	:toc: // gets a ToC after the title
	:toclevels: 2
	// :sectnums: // gets ToC sections to be numbered
	:sectnumlevels: 3 // max # of numbering level


	== Q

	== A
	EOF
}

# Main execution
main() {
    extract_html
    decode_html
    convert_to_adoc
    clean_adoc
    create_template

    # Append processed content to output
    cat "$RAW_ADOC" >>"$OUTPUT_ADOC"

    # Clean up temporary files (optional)
    rm "$EXTRACT" "$DECODED_HTML" "$RAW_ADOC"
}

main "$@"

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
