#! /usr/bin/tcsh

set file = $1
set debug = $2

echo -n "Part 1 : "
cat $file | sed 's/ \+/:/g' | sed 's/^:\|:$//g' | datamash -t ':' transpose | awk -F ':' '{for (i=1;i<NF;i++){if (i<NF-1) {printf $i" "$NF" "} else {printf $i} } print ""}' | bc | datamash sum 1
set formatSpecSize = `cat $file | rev | tail -n 1 | sed 's/\(\+\|\*\) /\1\n/g' | awk '{print length}'`
echo -n "Part 2 : "
cat $file | rev | awk -v arrelems="$formatSpecSize" '{split(arrelems, arr, " "); split($0, chars, "");pos=0; for(i=1;i<=length(arr);i++) {pos=arr[i]+pos+1; chars[pos]="#"}; for(i=1;i<=length(chars);i++){printf(chars[i])}; print ""}' | awk -F '#' -v arrelems="$formatSpecSize" '{ split(arrelems, arr, " "); for(k=1;k<=NF;k++) {  split($k, arr2, ""); for(i=1;i<=arr[k];i++){ if(arr2[i]!=" ") {res[k, i, NR]=arr2[i];} else {res[k, i, NR]=""} };} } END{ for(k=1; k<NF; k++) { op[k]=""; sum=0; prod=1; for(i=1;i<=arr[k];i++){ num[i]=""; for(j=1;j<=FNR;j++){ if (j < FNR ) {num[i] = num[i] res[k, i, j]; print num[i]} else { op[k] = op[k] res[k, i, j]; print op[k];} }}; for(i=1;i<=arr[k];i++){ if ( op[k] == "+" ) { sum += num[i]} else { prod *= num[i] } }; if (op[k] == "+") {printf "sum: %d\n", sum} else { printf "prod: %d\n", prod}}}' | grep "prod\|sum" | awk -F ':' '{print $2}' | datamash sum 1
