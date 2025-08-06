#! /usr/bin/tcsh

set file = "$1"
set debug = "$2"
set wd = `cat $file | awk -F '' 'END {print NF}'`
set ht = `cat $file | awk -F '' 'END {print NR}'`

set horizontal_left_to_right = `grep -o XMAS $file | wc -l`
if ( $debug ) then
   echo "Horizontal left to right:"
   grep -n --color XMAS $file
   
   echo "****"
endif

set horizontal_right_to_left = `cat $file | rev | grep -o XMAS  | wc -l`
if ( $debug ) then
   echo "Horizontal right to left:"
   cat $file | rev | grep -n --color XMAS
   
   echo "****"
endif

set vertical_top_to_bottom = `cat $file | sed 's/ */ /g' | datamash -t ' ' transpose | sed 's/ //g' | grep -v '^$' | grep -o XMAS | wc -l`
if ( $debug ) then
   echo "Vertical top to bottom:"
   cat $file | sed 's/ */ /g' | datamash -t ' ' transpose | sed 's/ //g' | grep -v '^$' | grep -n --color XMAS
   
   echo "****"
endif

set vertical_bottom_to_top = `cat $file | sed 's/ */ /g' | datamash -t ' ' transpose | rev  | sed 's/ //g' | grep -v '^$' | grep -o XMAS | wc -l`
if ( $debug ) then
   echo "Vertical bottom to top:"
   cat $file | sed 's/ */ /g' | datamash -t ' ' transpose | rev  | sed 's/ //g' | grep -v '^$' | grep -n --color XMAS 
   
   echo "****"
endif

set diagonal_bottomleft_to_topright = `cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; printf "**%2d**: ",numelems; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -o XMAS | wc -l`
if ( $debug ) then
   echo "Diagonal bottom-left to top-right:"
   cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; printf "**%2d**: ",numelems; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' 
   cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; printf "**%2d**: ",numelems; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color XMAS
   
   echo "****"
endif

set diagonal_topright_to_bottomleft = `cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N} else {S=i-h+1; N=h; numelems=N-S+1}; printf "**%2d**: ",numelems; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -o XMAS | wc -l`
if ( $debug ) then
   echo "Diagonal top-right to bottom-left:"
   cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N } else {S=i-h+1; N=h; numelems=N-S+1}; printf "**%2d**: ",numelems; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}'
   cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N } else {S=i-h+1; N=h; numelems=N-S+1}; printf "**%2d**: ",numelems; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color XMAS
   
   echo "****"
endif

set diagonal_bottomright_to_topleft = `cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; printf "**%2d**: ",numelems; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -o XMAS | wc -l`
if ( $debug ) then
   echo "Diagonal bottom-right to top-left:"
   cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S } else {S=h; N=i-h+1; numelems=S-N+1}; printf "**%2d**: ",numelems; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}'
   cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S } else {S=h; N=i-h+1; numelems=S-N+1}; printf "**%2d**: ",numelems; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color XMAS 
   
   echo "****"
endif

set diagonal_topleft_to_bottomright = `cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N } else {S=i-h+1; N=h; numelems=N-S+1}; printf "**%2d**: ",numelems; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -o XMAS | wc -l`
if ( $debug ) then
   echo "Diagonal top-left to bottom-right:"
   cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N } else {S=i-h+1; N=h; numelems=N-S+1}; printf "**%2d**: ",numelems; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}'
   cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N } else {S=i-h+1; N=h; numelems=N-S+1}; printf "**%2d**: ",numelems; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color XMAS 
   
   echo "****"
endif

echo "Part 1: `expr $horizontal_left_to_right + $horizontal_right_to_left + $vertical_top_to_bottom + $vertical_bottom_to_top + $diagonal_bottomleft_to_topright + $diagonal_topright_to_bottomleft + $diagonal_bottomright_to_topleft + $diagonal_topleft_to_bottomright`"


if ( $debug ) then
   echo "bottomleft to topright"
   cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if ($1 <= h) {print($1 + 1 - i","i)} else {print(h+1-i","$1-h+i)} }}}'
   echo "****"
endif

set v1 = `cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if ($1 <= h) {print($1 + 1 - i","i)} else {print(h+1-i","$1-h+i)} }}}'`

if ( $debug ) then
   echo "topright to bottomleft"
   cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N} else {S=i-h+1; N=h; numelems=N-S+1}; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if($1 <= w) {print(i","$1 + 1 - i)} else {print($1-w+i","w+1-i)} }}}'
   echo "****"
endif

set v2 = `cat $file | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N} else {S=i-h+1; N=h; numelems=N-S+1}; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if($1 <= w) {print(i","$1 + 1 - i)} else {print($1-w+i","w+1-i)} }}}'`

if ( $debug ) then
   echo "bottomright to topleft"
   cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if($1 <= h) {print($1 + 1 - i","w + 1 - i)} else {print(h-i+1","2*w-$1-i+1)} }}}'
   echo "****"
endif

set v3 = `cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=i; N=1; numelems=S} else {S=h; N=i-h+1; numelems=S-N+1}; for (j=S;j>=N;j--) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if($1 <= h) {print($1 + 1 - i","w + 1 - i)} else {print(h-i+1","2*w-$1-i+1)} }}}'`

if ( $debug ) then
   echo "topleft to bottomright"
   cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N } else {S=i-h+1; N=h; numelems=N-S+1}; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if($1<=w) { print(i","w - $1 + i)} else {print($1-h+i","i)} }}}'
   echo "****"
endif

set v4 = `cat $file | rev | sed ':a; N; s/\n//g;ta' | sed 's/ */ /g' | awk -v h=$ht -v w=$wd '{for (i=1;i<=h+w-1;i++) { if(i<=h) { S=1; N=i; numelems=N } else {S=i-h+1; N=h; numelems=N-S+1}; for (j=S;j<=N;j++) { printf $(i + (j - 1) * (w-1))"" }; print ""}}' | grep -n --color MAS | sed 's/\([XMAS]\)\|:/\1 /g' | awk -v h=$ht -v w=$wd '{for(i=1;i<=NF;i++) {if ($i == "M" && $(i+1)=="A" && $(i+2)=="S") { if($1<=w) { print(i","w - $1 + i)} else {print($1-h+i","i)} }}}'`

echo "Part 2: `echo $v1 $v2 $v3 $v4 | sed 's/ /\n/g' | sort | uniq -d | wc -l`"
