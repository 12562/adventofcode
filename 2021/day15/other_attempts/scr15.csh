#! /usr/bin/csh

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
#\cp -f $file reference_file
set num_rows = `wc -l reference_file | awk '{print $1}'`
set num_cols = `awk -F '' 'END {print NF}' reference_file`
set total = `echo "$num_rows * $num_cols" | bc`
seq $total | sed 's/\(.*\)/\1:10000000/g' > dist
seq $total | sed 's/.*/0/g' > prev
seq $total > Q
sed -i "1 s/:.*/:0/g" dist
  
while (`cat Q | wc -l`)
  set u = `cat dist | grep ":" | sort -n -t ":" -k 2 | head -n 1`
   echo "U: $u"
  set uindex = `echo $u | awk -F ':' '{print $1}'`
  set udist = `echo $u | awk -F ':' '{print $2}'`
  sed -i '/^'$uindex'$/ d' Q
  sed -i "$uindex s/.*://g" dist
  set neighbors = () 
  set row = `echo $uindex | sed 's/\(.*\)/'"(\1 + $num_cols - 1) \/ $num_cols/g" | bc`
  set col = `echo $uindex | sed 's/$/'" % $num_cols/g" | bc`
  # echo "$row $col : $udist"
  if ( $col == 0 ) then
    set col = $num_cols
  endif
  if ( $row < $num_rows ) then
     set neighbors = ( $neighbors "`expr $uindex + $num_cols`" )
  endif
  #if ( $row > 1 ) then
  #   set neighbors = ( $neighbors "`expr $uindex - $num_cols`" )
  #endif
  if ( $col < $num_cols ) then
     set neighbors = ( $neighbors "`expr $uindex + 1`" )
  endif
  #if ( $col > 1 ) then
  #   set neighbors = ( $neighbors "`expr $uindex - 1`" )
  #endif
  # echo "check"
  # echo "Neighbors: $neighbors"
  foreach neighborV ( $neighbors )
     if ( `grep -c "^$neighborV"'$' Q` ) then
        # echo "NV: $neighborV"
        set vdist = `sed "$neighborV q;d" dist | awk -F ':' '{print $2}'`
        set nrow = `echo $neighborV | sed 's/\(.*\)/'"(\1 + $num_cols - 1) \/ $num_cols/g" | bc`
        set ncol = `echo $neighborV | sed 's/$/'" % $num_cols/g" | bc`
        if ( $ncol == 0 ) then
           set ncol = $num_cols
        endif
        set neighbor_risk = `cat reference_file | sed "$nrow q;d" | awk -v col=$ncol -F '' '{print $col}'` 
        set alt = `expr $udist + $neighbor_risk` 
        if ( $alt < $vdist ) then
           sed -i "$neighborV s/:.*/:$alt/g" dist
           sed -i "$neighborV s/.*/$uindex/g" prev 
        endif 
     endif
  end
end
tail -n 1 dist

tcsh ./scr2.csh
