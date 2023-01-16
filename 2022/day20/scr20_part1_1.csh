#! /usr/bin/csh

set file = $argv[1]

cat $file | grep -n '.' > runtime_file
set size = `cat $file | wc -l`
set num = 1
set lm = `expr $size - 1`

while ( $num <= $size )
  set current_line = `grep "^${num}:" runtime_file`
  #echo "check: current line: $current_line"
  set current_pos = `cat runtime_file | grep -n '.' |  grep ":${num}:" | awk -F ':' '{print $1}'`
  set current_num = `echo $current_line | awk -F ':' '{print $2}'`
  #echo "check: current pos: $current_pos"
  #echo "check: current num: $current_num"
  
  #echo "$current_pos : $new_pos"
  if ( $current_num > 0 ) then
     set current_num_sign = "+"
  else
     set current_num_sign = "-"
  endif
  if ( `expr $current_pos + $current_num` == 0 ) then
     set to_add = 0
  else
     if ( "$current_num_sign" == "+" ) then
       set to_add = `echo "(( $current_pos + $current_num  )  / $size)" | bc`
     else
       set to_add = `echo "(( $current_pos + $current_num  )  / $size) $current_num_sign  1" | bc `
     endif
  endif
  #echo $to_add
  set exp = `echo "(( $current_pos + $current_num ) > $size)" | bc`
  set exp2 = `echo "(( $current_pos + $current_num ) <= 1)" | bc`
  if ( $exp || $exp2 ) then
     #if ( (`expr $current_pos + $current_num` <= -5000) ) then
     #   set new_pos = `expr \( $current_pos - 1 + $current_num $current_num_sign $to_add  \) %  $size`
     #else
     if ( "$current_num_sign" == "+" ) then
        #echo "check"
        set new_pos = `expr \( $current_pos  + $current_num $current_num_sign $to_add  \) %  $size`
     else
        set new_pos = `expr \( $current_pos  + $current_num + $to_add  \) %  $size`
     endif
  else
     set new_pos = `expr \( $current_pos  + $current_num \)`
  endif
 
  if ( $new_pos <= 0 ) then
     set new_pos = `expr $size + $new_pos`
  endif
  
  sed -i -- "$current_pos d" runtime_file
  if ( $new_pos == $size ) then
    echo $current_line >> runtime_file
  else
    sed -i -- "$new_pos i$current_line" runtime_file
  endif
  #echo "$current_num $current_pos $new_pos"
  #cat runtime_file | xargs echo
  @ num = ( $num + 1 )
end 

set zeros_index = `grep -n ':0' runtime_file | awk -F ':' '{print $1}'`
set thousand_index = `expr $zeros_index + 1000`
set thousand_index = `expr $thousand_index % $size`
set thousand_num = `sed "$thousand_index q;d" runtime_file | awk -F ':' '{print $2}'`
set two_thousand_index = `expr $zeros_index + 2000`
set two_thousand_index = `expr $two_thousand_index % $size`
set two_thousand_num = `sed "$two_thousand_index q;d" runtime_file | awk -F ':' '{print $2}'`
set three_thousand_index = `expr $zeros_index + 3000`
set three_thousand_index = `expr $three_thousand_index % $size`
set three_thousand_num = `sed "$three_thousand_index q;d" runtime_file | awk -F ':' '{print $2}'`
#echo "$thousand_num $two_thousand_num $three_thousand_num"
echo "Part 1 : "`expr $thousand_num + $two_thousand_num + $three_thousand_num`
