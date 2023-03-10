#! /usr/bin/tcsh

set file = $argv[1]

part2:
rm -f prev dist Q
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
  
  set neighbors = (`echo $neighbors | sed 's/ /\n/g' | sort -n`)
  set pattern = `echo $neighbors | sed 's/\([0-9]\+\) */\1p;/g'`
  set vdist = (`sed -n "$pattern" dist`)
  set neighbor_risk = (`grep -o '.' $file | sed -n "$pattern"`)
  set alt = (`echo $neighbor_risk | sed 's/ /\n/g' | sed 's/$/'" + $udist"'/g' | bc`)
  set to_update = ( `echo "${vdist}:${alt}" | sed 's/:/\n/g' | datamash -t " " transpose | sed 's/ / > /g' | bc | grep -n "1" | awk -F ':' '{print $1}'`)
  foreach tu ( $to_update )
       set neighbor = $neighbors[$tu]
       sed -i "$neighbor s/.*/$alt[$tu]/g" dist
       sed -i "$neighbor s/.*/$uindex/g" prev
       if ( ! `cat Q | grep -c "^${neighbor}:"` ) then
          echo "${neighbor}:${alt[$tu]}" >> Q
          awk -i inplace '{print NR":"$s}' Q
          sort -t ":" -k 3,3n -k 1,1n -o Q <Q 
          sed -i 's/^[0-9]*://g'  Q
       else
          sed -i "s/^\(${neighbor}:\).*/\1${alt[$tu]}/g" Q
       endif
  end
  cat Q | awk -F ':' '{print $2}' | sort -nC || exit
end



if ( $file != "reference_file" ) then
   echo "Part 1 : "`tail -n1 dist`
   rm -f reference_file
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
   set file = "reference_file"
   goto part2
else
   echo "Part 2 : "`tail -n1 dist`
endif
rm -f reference_file dist prev Q
