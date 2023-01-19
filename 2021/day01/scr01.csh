#! /usr/bin/csh

echo "Part1: "`cat $argv[1] | sed 's/\(.*\)/\1\n\1/g' | sed '1d; $d; N; s/\([^\n]*\)\n\(.*\)/\2 - \1/g' | bc | grep -v - | wc -l`

echo "Part2: "`cat $argv[1] | sed  ':a;N;s/\n/ /g;ta;' | sed 's/\(\([^ ]*\) \(\([^ ]*\) \(\([^ ]*\)\(.*\)\)\)\)/\1\n\3\n\5/g' | awk 'NR==1{$NF = ""; $(NF-1) = ""}; NR==2{$NF=""}1'  | sed 's/ *$//g' | datamash -t " " transpose | sed 's/ / + /g' | bc | sed 's/\(.*\)/\1\n\1/g' | sed '1d; $d; N; s/\([^\n]*\)\n\(.*\)/\2 - \1/g'  | bc | grep -v '^0$\|-' | wc -l`
