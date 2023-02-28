#! /usr/bin/tcsh

set file = $argv[1]

rm -f reference_file prev dist Q
set num = 0
set num_rows = `wc -l $file | awk '{print $1}'`
set num_cols = `awk -F '' 'END {print NF}' $file`
touch reference_file
while ( $num < 5 )
   cat $file | grep -o '.' | sed "s/\(.*\)/(\1 + $num) % 9/g" | bc | sed 's/0/9/g' | paste -sd '' | sed "s/\(.\{$num_cols\}\)/\1\n/g" | grep -v '^$' > tmp
   paste -d "" reference_file tmp > tmp2
   \cp -f tmp2 reference_file
   @ num += 1
end
\cp -f reference_file reference_file2
set num = 1
while ( $num < 5 )
  foreach row ( `cat reference_file2 | sed 's/ //g'` )
    set new_row = `echo $row | grep -o '.' | sed "s/\(.*\)/(\1 + $num) % 9/g" | bc | sed 's/0/9/g' | paste -sd '' `
    echo $new_row >> reference_file
  end
  @ num += 1
end
rm -f tmp tmp2 reference_file2

set file = reference_file
set num_rows = `cat $file | wc -l`
set num_cols = `cat $file | awk -F '' 'END {print NF}'`
set total = `expr $num_rows \* $num_cols`

set source = 1
set source_dist = 0
set source_prev = 0
echo "${source}:${source_dist}" > Q
seq $total | sed 's/\(.*\)/10000000/g' | sed "1 s/.*/${source_dist}/g" > dist
seq $total | sed 's/.*/0/g' > prev

while ( `cat Q | wc -l` )
  set u = `head -n1 Q`
  echo $u
  sed -i '1d' Q
  set uindex = `echo "$u" | awk -F ':' '{print $1}'`
  set udist  = `echo "$u" | awk -F ':' '{print $2}'`
  
  set row = `echo $uindex | sed 's/\(.*\)/'"(\1 + $num_cols - 1) \/ $num_cols/g" | bc`
  set col = `echo $uindex | sed 's/$/'" % $num_cols/g" | bc | sed 's/^0$/'$num_cols'/g'`
  
  set neighbors = ()
  if ( $row < $num_rows ) then
     set neighbors = ( $neighbors "`expr $uindex + $num_cols`" )
  endif
  if ( $row > 1 ) then
     set neighbors = ( $neighbors "`expr $uindex - $num_cols`" )
  endif
  if ( $col < $num_cols ) then
     set neighbors = ( $neighbors "`expr $uindex + 1`" )
  endif
  if ( $col > 1 ) then
     set neighbors = ( $neighbors "`expr $uindex - 1`" )
  endif
  
  foreach neighborV ( $neighbors )
    set vdist = `sed "$neighborV q;d" dist`
    #set nrow = `echo $neighborV | sed 's/\(.*\)/'"(\1 + $num_cols - 1) \/ $num_cols/g" | bc`
    #set ncol = `echo $neighborV | sed 's/$/'" % $num_cols/g" | bc | sed 's/^0$/'$num_cols'/g'`
    #set neighbor_risk = `cat $file | sed "$nrow q;d" | awk -v col=$ncol -F '' '{print $col}'`
    set neighbor_risk = `grep -o . $file | sed "$neighborV q;d"`
    set alt = `expr $udist + $neighbor_risk`
    if ( $alt < $vdist ) then
       sed -i "$neighborV s/.*/$alt/g" dist
       sed -i "$neighborV s/.*/$uindex/g" prev
       if ( ! `cat Q | grep -c "^${neighborV}:"` ) then
          echo "${neighborV}:$alt" >> Q
          awk -i inplace '{print NR":"$s}' Q
          sort -t : -k 3,3n -k 1,1n -o Q <Q 
          sed -i 's/^[0-9]*://g'  Q
       else
          sed -i "s/^\(${neighborV}:\).*/\1${alt}/g" Q
       endif
    endif
  end
  echo "****Q****"
  cat Q
  echo "*********"
end
tcsh scr2.csh $file
