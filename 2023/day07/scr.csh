#! /usr/bin/tcsh

set file = $1
set debug = $2

echo -n "Part 1: "
cat $file | sed 's/\([A-Z0-9]\)\([A-Z0-9]\)\([A-Z0-9]\)\([A-Z0-9]\)\([A-Z0-9]\) \(.*\)/\1 \2 \3 \4 \5 \6/g' | awk -v d=$debug -f script1.awk

echo -n "Part 2: "
cat $file | sed 's/\([A-Z0-9]\)\([A-Z0-9]\)\([A-Z0-9]\)\([A-Z0-9]\)\([A-Z0-9]\) \(.*\)/\1 \2 \3 \4 \5 \6/g' | awk -v d=$debug -f script2.awk
