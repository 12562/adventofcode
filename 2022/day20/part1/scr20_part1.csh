#! /usr/bin/csh

set file = "$argv[1]"
grep -n . $file > reference_file
\cp -f $file runtime_file
set size = `wc -l $file | awk '{print $1}'`
set ctr = 1
while ( $ctr <= $size )
  set line = `sed "$ctr q;d" reference_file`
  set current_pos = `echo $line | awk -F ':' '{print $1}'`
  set current_num = `echo $line | awk -F ':' '{print $2}'`
  if ( $current_num != 0 ) then
     set expression = `echo "$current_num > 0" | bc`
     if ( $expression ) then
        set current_num_sign = "+"
     else
        set current_num_sign = "-"
     endif
     set first_exp = `echo "( $current_pos + $current_num ) > $size" | bc`
     set sec_exp = `echo "( $current_pos + $current_num ) <= 1" | bc`
     if ( $first_exp || $sec_exp ) then
        set new_pos = `expr \( $current_pos  + $current_num $current_num_sign 1 \) %  $size`
     else
        set new_pos = `expr \( $current_pos  + $current_num \) %  $size`
     endif
     #echo "check NEW_POS: $new_pos"
     set expression = `echo "$new_pos <= 0" | bc`
     if ( $expression ) then
        set new_pos = `expr $size + $new_pos`
        #echo "check: NEW_POS: $new_pos"
        set entry_pos = 1
        while ( $entry_pos <= $size )
          set entry = `sed "$entry_pos q;d" reference_file`
          set i = `echo $entry | sed 's/:.*//g' | awk -F ':' '{print $1}'`
          set expression = `echo "$i == $current_pos" | bc`
          if ( $expression ) then
             sed -i "$entry_pos s/.*:/${new_pos}:/g" reference_file
          else   
             set first_exp = `echo "($i >= $current_pos) && ($i <= $new_pos)" | bc`
             if ( $first_exp ) then
                set newpos = `expr $i - 1`
                sed -i "$entry_pos s/.*:/${newpos}:/g" reference_file
             endif
          endif
          @ entry_pos = ( $entry_pos +  1 )
        end
     else
        set first_exp = `echo "($current_num >= 0) && (( $current_pos + $current_num ) <= $size)" | bc`
        if ( $first_exp ) then
           set sign = "+"
           set newpossign = "-"
           set comparison = "<="
           set other_comparison = ">="
        else
           set sign = "-"
           set newpossign = "+"
           set comparison = ">="
           set other_comparison = "<="
        endif
        set entry_pos = 1
        #echo "check : $i $comparison  $new_pos"
        while ( $entry_pos <= $size )
          set entry = `sed "$entry_pos q;d" reference_file`
          set i = `echo $entry | sed 's/:.*//g' | awk -F ':' '{print $1}'`
          set expression = `echo "$i == $current_pos" | bc`
          if ( $expression) then
             sed -i "$entry_pos s/.*:/${new_pos}:/g" reference_file
          else
             #echo "check ($i $comparison $new_pos) && ($i $other_comparison $current_pos)"
             set first_exp = `echo "($i $comparison $new_pos) && ($i $other_comparison $current_pos)" | bc`
             if ( $first_exp ) then
                set newpos = `expr $i $newpossign 1`
                #echo "check NEWPOS: $newpos"
                sed -i "$entry_pos s/.*:/${newpos}:/g" reference_file
             endif
          endif
          @ entry_pos = ( $entry_pos + 1 )
        end
     endif
     sed -i "$current_pos d" runtime_file
     if ( $new_pos == $size ) then
       echo $current_num >> runtime_file
     else
       sed -i "$new_pos i$current_num" runtime_file
     endif
     #cat runtime_file | xargs echo
     #cat reference_file | xargs echo
  endif
  echo $ctr
  @ ctr = ( $ctr + 1 )
end
