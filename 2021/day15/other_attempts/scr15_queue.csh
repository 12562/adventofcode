#! /usr/bin/csh

set file = $argv[1]
set row = 1 col = 1 
set min = `cat $file | awk -F '' 'NR==1 {print $0}; NR != 1{print $NF}' | grep -o '.' | paste -sd+ | bc`
set num_rows = `wc -l $file | awk '{print $1}'`
set num_cols = `awk -F '' 'END {print NF}' $file`
echo `echo "(${row} - 1) * $num_cols + ${col}" | bc`:0  > queue
while ( `cat queue | wc -l` )
  echo "check1"
  set current = `sed "1 q;d" queue`
  sed -i "1 d" queue
  echo "check2"
  set current_path = `echo "$current" | awk -F ':' '{print $1}'`
  echo "check3"
  set current_index = `echo "$current_path" | awk -F '_' '{print $NF}'`
  echo "check4"
  set row = `echo $current_index | sed 's/\(.*\)/'"(\1 + $num_cols - 1) \/ $num_cols/g" | bc`
  echo "check5"
  set col = `echo $current_index | sed 's/$/'" % $num_cols/g" | bc`
  if ( $col == 0 ) then
    set col = $num_cols
  endif
  echo "check6"
  set current_total_risk = `echo "$current" | awk -F ':' '{print $2}'`
  echo "check"
  if ( ($row == $num_rows) && ($col == $num_cols) ) then
     if ( $current_total_risk < $min ) then
        set min = $current_total_risk
        echo "${current_path}:$min" > min
        awk -i inplace -F ':' -v var=$min '$2 < var' queue
     endif
  else
     if ( $current_total_risk < $min ) then
        set current_risk = `cat $file | sed "$row q;d" | awk -v col=$col -F '' '{print $col}'` 
        set neighbors = ()
        if ( $row < $num_rows ) then
           set neighbors = ( $neighbors "`expr $current_index + $num_cols`" )
        endif
        #if ( $row > 1 ) then
        #   set neighbors = ( $neighbors "`expr $current_index - $num_cols`" )
        #endif
        if ( $col < $num_cols ) then
           set neighbors = ( $neighbors "`expr $current_index + 1`" )
        endif
        #if ( $col > 1 ) then
        #   set neighbors = ( $neighbors "`expr $current_index - 1`" )
        #endif
        echo "NEIGHS: $neighbors"
        set neighbors_to_append = ()
        set risks = ()
        foreach neighbor ( $neighbors )
           echo "$current_path" | sed 's/_/\n/g' | grep -c "^$neighbor"'$'
           if ( ! `echo "$current_path" | sed 's/_/\n/g' | grep -c "^$neighbor"'$' ` ) then
              set nrow = `echo $neighbor | sed 's/\(.*\)/'"(\1 + $num_cols) \/ $num_cols/g" | bc`
              set ncol = `echo $neighbor | sed 's/$/'" % $num_cols/g" | bc`
              if ( $ncol == 0 ) then
                 set ncol = $num_cols
              endif
              echo "Nrow: $nrow :: Ncol: $ncol"
              set neighbor_risk = `cat $file | sed "$nrow q;d" | awk -v col=$ncol -F '' '{print $col}'` 
              echo "NR: $neighbor_risk"
              set total_risk = `expr $neighbor_risk + $current_total_risk` 
              echo "${current_path}_${neighbor}:$total_risk" >> queue
              #set risks = ( $risks "${neighbor}:${neighbor_risk}" )
           endif
        end
        #set minR = `echo "$risks" | sed 's/ /\n/g' | awk -F ':' '{print $2}' | sort -n | head -n 1`
        #foreach risk ( $risks )
        #   set neigh_risk = `echo "$risk" | awk -F ':' '{print $2}'` 
        #   #if ( $neigh_risk <= `expr $minR + 2`) then
        #      set neigh = `echo "$risk" | awk -F ':' '{print $1}'`
        #      set total_risk = `expr $neigh_risk + $current_total_risk` 
        #      echo "${current_path}_${neigh}:$total_risk" >> queue
        #   #endif
        #end
        #      set neighbors_to_append = ( $neighbors_to_append "${current_path}_${neighbor}:${total_risk}@${neighbor_risk}" )
        #set neighbors_to_append = ( `echo $neighbors_to_append | sed 's/ /\n/g' | sort -t "@" -k 2 -n` )
        #echo $neighbors_to_append
        #foreach val_to_append ( $neighbors_to_append )
        #   set val_to_append = `echo $val_to_append | awk -F '@' '{print $1}'`
        #   echo "$val_to_append"  >> queue 
        #end
     else
       awk -i inplace -F ':' -v var=$min '$2 < var' queue
     endif
  endif
  head -n 10 queue
end
echo $min
