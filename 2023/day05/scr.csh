#! /usr/bin/tcsh

set file = "$1"

cat $file | sed '/map/ {:a;N;s/\n\([0-9]\)/@\1/g; ta}' | grep -v '^$' | sed 's/: /:/g' | sed ':a; N; s/\n/=/g; ta' | sed 's/ map:/:/g' | sed 's/ /,/g' | sed 's/:@/:/g' | awk -F '=' -f scriptPart1.awk 

set initEstimate = `cat $file | sed '/map/ {:a;N;s/\n\([0-9]\)/@\1/g; ta}' | grep -v '^$' | sed 's/: /:/g' | sed ':a; N; s/\n/=/g; ta' | sed 's/ map:/:/g' | sed 's/ /,/g' | sed 's/:@/:/g' | awk -F '=' -f scriptPart2Init.awk  | tail -n 1`
cat $file | sed '/map/ {:a;N;s/\n\([0-9]\)/@\1/g; ta}' | grep -v '^$' | sed 's/: /:/g' | sed ':a; N; s/\n/=/g; ta' | sed 's/ map:/:/g' | sed 's/ /,/g' | sed 's/:@/:/g' | awk -F '=' -v start=$initEstimate -f scriptPart2.awk 
