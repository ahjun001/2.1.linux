#!/bin/bash

# Get the name of the file that contains the keywords.
file_name=$1

# Open the file and read the keywords one at a time.
while read -r keyword; do

  # Remove the leading whitespace from the keyword.
#   keyword=$(cut -d' ' -f1 <<< "$keyword")

  # Do something with the keyword.
  echo "The keyword is: $keyword"

done < "$file_name"