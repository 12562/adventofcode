#! /usr/bin/tcsh

set file = "$1"

echo "Part 1: "`cat "$file" | sed 's/:/\|/g' | awk -F '|' '{print $2" "$3}' | awk '{sum=0; delete a; for(i=1;i<=NF;i++){num=$i+0; a[num]=a[num]+1;  if(a[num] == 2) {sum+=1}}; printf("%d\n",2^(sum-1))}' | datamash sum 1`

echo "Part 2: "`cat $file | sed 's/:/\|/g' | awk -F '|' '{print $2" "$3}' | awk '{sum=0; delete a; num_matches=0; card=FNR+1; if (arr[FNR] == 0) {arr[FNR] = 1} else {arr[FNR] += 1}; for(i=1;i<=NF;i++){num=$i+0; a[num]=a[num]+1; if(a[num] == 2) {num_matches+=1}; }; for(i=card;i<card+num_matches;i++){arr[i]+=arr[FNR]};} END {res=0; for(i=1;i<=NR;i++){res += arr[i]}; printf("%d\n", res)} '`
