#! /usr/bin/tcsh

set file = "$1"
set debug = "$2"

cat $file | awk -v d=$debug -f script.awk
