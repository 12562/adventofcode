#! /usr/bin/tcsh

set file = "$1"
set debug = "$2"

set numFields = `cat $1 | awk 'END{print NF}' | sed 's/$/ - 1/g' | bc`

echo "Part 1: "`cat $file | sed 's/[ \t]\+/ /g' | datamash -t ' ' transpose | tail -n$numFields | awk '{ways[FNR]=0;for(i=0;i<=$1;i++){dist=($1-i)*i; if(dist > $2){ways[FNR]+=1}}} END{res=1; for(i=1;i<=NR;i++){res*=ways[i]}; print res}'`

echo "Part 2: "`cat $file | sed 's/[ \t]\+//g' | datamash -t ':' transpose | tail -n 1 | sed 's/:/ /g' | awk '{ways[FNR]=0;for(i=0;i<=$1;i++){dist=($1-i)*i; if(dist > $2){ways[FNR]+=1}}} END{res=1; for(i=1;i<=NR;i++){res*=ways[i]}; print res}'`
