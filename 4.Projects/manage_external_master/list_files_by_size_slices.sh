#!/usr/bin/env bash

# Set the volume to search
# VOLUME="/run/media/perubu/Tosh_4TB/"
VOLUME="/home/perubu/"

# Set the size limits
# MIN_SIZE=1073741824 # 1 GB
# MIN_SIZE=536870912
MIN_SIZE=1024M
# MIN_SIZE=2048M
# MIN_SIZE=1048576
# MAX_SIZE=2147483648 # 2 GB
# echo $((MIN_SIZE * 1048576))

# Find all files on the volume that meet the size criteria
# find "$VOLUME" -xdev -type f -size +$MIN_SIZE -size -$MAX_SIZE -exec ls -lh {} \; | sort -h > "${MIN_SIZE}MB.txt"
# find "$VOLUME" -xdev -type f -size +$((MIN_SIZE * 1024)) -exec ls -lh {} \; | sort -h >"${MIN_SIZE}MB.txt"
# find "$VOLUME" -xdev -type f -size +102400 -exec ls -lh {} \; | sort -h >"${MIN_SIZE}MB.txt"

# du --all --human-readable --separate-dirs --threshold $MIN_SIZE "$VOLUME"/.[^.]*
du -ahSt $MIN_SIZE "$VOLUME"/* | sort -rh
