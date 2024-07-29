#!/usr/bin/env bash

set -euo pipefail

: | bash script that uses fdupes to globally index both volumes and then checks which files in the list of large files on volume v1 are already present on volume v2, even if they have a different name:

# Set the volumes to compare
V1="/home/perubu/"
V2="/run/media/perubu/Tosh_4TB/"

# Set the list of large files on volume v1
LARGE_FILES=("file1" "file2" "file3")

# Create a global index of both volumes using fdupes
fdupes -r -n -d 1 "$V1" "$V2" >index.txt

# Loop through the list of large files on volume v1
for file in "${LARGE_FILES[@]}"; do
    # Check if the file is present in the index
    if grep -q "$file" index.txt; then
        # If the file is present, print the original name and the duplicate name
        echo "$file is a duplicate of ${fdupes-q -n -d 1 "$V1/$file" "$V2" | grep -v "$file"}"
    fi
done
