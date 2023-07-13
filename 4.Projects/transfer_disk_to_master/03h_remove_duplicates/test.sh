#!/bin/bash
 # Loop from 1 to 3
for i in {1..3}; do
    # Create variable name using the index
    var_name="VAR$i"
    # Assign value to the variable
    declare "$var_name=$i"
done
 # Print the values of the variables
echo "VAR1: $VAR1"
echo "VAR2: $VAR2"
echo "VAR3: $VAR3"