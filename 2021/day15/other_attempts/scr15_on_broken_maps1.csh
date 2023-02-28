#! /usr/bin/csh

set file = $argv[1]
cat $file | awk -F '' '{print $0""($1+1)%9}' | sed 's/0/9/g' > reference_file 
cat $file | head -n1 | sed 's/ */\n/g' | grep -v '^$' | awk '{print ($0+1)%9}' | sed 's/0/9/g' | paste -sd '' >> reference_file 
cat reference_file
set num = 0
set init = 1
set prev_dist = 0
set current_row = 0
set current_col = 0
while ( $num <= 8 )
  set num_rows = `wc -l reference_file | awk '{print $1}'`
  set num_cols = `awk -F '' '{print NF}' reference_file | head -n 1`
  if ( $num <= 7 ) then
    set total = `echo "$num_rows * $num_cols - 1" | bc`
  else
    set total = `echo "$num_rows * $num_cols" | bc`
  endif
  echo "NR: $num_rows :: NC: $num_cols :: Total: $total"
  seq $total | sed 's/\(.*\)/\1:100000/g' > dist
  seq $total | sed 's/.*/0/g' > prev
  seq $total > Q
  sed -i "$init s/:.*/:0/g" dist
  
  while (`cat Q | wc -l`)
    set u = `cat dist | grep ":" | sort -n -t ":" -k 2 | head -n 1`
#    echo "U: $u"
    set uindex = `echo $u | awk -F ':' '{print $1}'`
    set udist = `echo $u | awk -F ':' '{print $2}'`
    sed -i '/^'$uindex'$/ d' Q
    sed -i "$uindex s/.*://g" dist
    set neighbors = () 
    set row = `echo $uindex | sed 's/\(.*\)/'"(\1 + $num_cols - 1) \/ $num_cols/g" | bc`
    set col = `echo $uindex | sed 's/$/'" % $num_cols/g" | bc`
#    echo "$row $col : $udist"
    if ( $col == 0 ) then
      set col = $num_cols
    endif
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
#    echo "check"
#    echo "Neighbors: $neighbors"
    foreach neighborV ( $neighbors )
       if ( `grep -c "^$neighborV"'$' Q` ) then
#          echo "NV: $neighborV"
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
  set mydist = `tail -n 1 dist`
  echo "$current_row :: $current_col"
  echo "Current dist: "`expr $prev_dist + $mydist`
  cat dist | grep -n "." | awk -v col=$num_cols -v row=$num_rows -v num=$num -v d=$prev_dist -v c=$current_col -v r=$current_row -F ':' 'NR%col == 0 {print $1":"$2+d":"($2+d)/(col + c + r + int((NR)/row))"-"col"-"int((NR)/row)} ; int((NR+col)/row) == row && NR%col != 0 {print $1":"$2+d":"($2+d)/((NR%col) + c + r + int((NR+col)/row))"-"(NR%col)"-"int((NR+col)/row)}' | sort -t ":" -k 3,3n -k 2,2n
  set value = `cat dist | grep -n "." | awk -v col=$num_cols -v row=$num_rows -v num=$num -v d=$prev_dist -v c=$current_col -v r=$current_row -F ':' 'NR%col == 0 {print $1":"$2+d":"($2+d)/(col + r + c + int((NR)/row))}; int((NR+col)/row) == row  && NR%col != 0 {print $1":"$2+d":"($2+d)/((NR%col) + r + c + int((NR+col)/row))}' | sort  -t ":" -k 3,3n -k 2,2n | head -n 1 `
  set init = `echo $value | awk -F ':' '{print $1}'`
  set prev_dist = `echo $value | awk -F ':' '{print $2}'`
  echo $prev_dist
  if ( $init > 110 ) then
     set current_row = `expr $current_row + 10`
  else
     set current_col = `expr $current_col + 10`
  endif
  echo $init
  set row_init = `echo  "($init + $num_cols - 1) / $num_cols" | bc` 
  echo "$row_init $num_cols"
  if ( $num != 7 ) then 
     if ( $row_init == $num_cols ) then
       set init = `expr $init % $num_cols`
     else
       set init = `echo "(($row_init - 1) * ($num_cols)) + 1" | bc`
     endif
  else
     if ( $row_init == $num_cols ) then
       set init = `expr $init % $num_cols`
     else
       set init = `echo "(($row_init - 1) * ($num_cols - 1)) + 1" | bc`
     endif
  endif
  grep -o . reference_file | sed 's/\(.*\)/(\1 + 1) % 9/g' | bc | sed 's/0/9/g' | paste -sd '' | sed 's/\(.\{'$num_cols'\}\)/\1\n/g' | grep -v '^$' > tmp
  if ( $num == 7 ) then
     set nc_minus_one = `expr $num_cols - 1`
     cat tmp |  awk -F '' '{$NF="";print $0}' | sed 's/ //g' | head -n-1 > reference_file
  else
     mv tmp reference_file
  endif
  cat reference_file
  echo "$init"
  echo ""
  \cp -f dist dist$num
  \cp -f prev prev$num
  @ num += 1
end
