#! /usr/bin/csh

rm -f simulation_file tmp_file
set i = 1 
set file = "test_input17.txt" 
while ( $i <= 4000 ) 
  echo "|.......|" >> simulation_file
  @ i = ( $i + 1 )
end
echo "+-------+" >> simulation_file
tac simulation_file > tmp_file

set num_winds = `cat $file | sed 's/ */\n/g' | grep -v '^$' | wc -l`
set max_ht = 0
set current_rock = 0
set num = 1
set wind_dir_num = 1

while ( $num < 2023 )
  echo "NUM: $num"
  set rock_left_corner = 3
  set current_rock_shape = (`awk -v rock_num=$current_rock '/^$/{n+=1}; n==rock_num && \! /^$/ {print}' rocks`)
  set current_rock_shape = ( `echo $current_rock_shape  | sed 's/#/@/g'` )
  set current_rock_width = `echo $current_rock_shape[1] | sed 's/ */\n/g' | grep -v '^$' | wc -l `
  set current_rock_ht = $#current_rock_shape
  set rock_ht = `expr $max_ht + 4`
  set rock_ht_tlc = `expr $max_ht + 4 +  $current_rock_ht`
  set rock_line_num = $rock_ht_tlc ## tlc => Top left corner
  set current_rock_line_num = $rock_line_num
  set rock_at_rest = 0
  
  while ( ! $rock_at_rest )
    foreach rock_shape_line ( $current_rock_shape )
      #set print_line = $rock_ht + $rock_line_num
      if ( "$rock_shape_line" == ".@." ) then
         echo "check1"
         set tmp_current_rock_width = 1
         set tmp_rock_left_corner = `expr $rock_left_corner + 1`
         sed -i "$rock_line_num s/\(.\{${tmp_rock_left_corner}\}\).\{${tmp_current_rock_width}\}\(.*\)/\1@\2/g" tmp_file 
      else if ( "$rock_shape_line" == "..@" ) then
         echo "check2"
         set tmp_current_rock_width = 1
         set tmp_rock_left_corner = `expr $rock_left_corner + 2`
         sed -i "$rock_line_num s/\(.\{${tmp_rock_left_corner}\}\).\{${tmp_current_rock_width}\}\(.*\)/\1@\2/g" tmp_file 
      else
        sed -i "$rock_line_num s/\(.\{${rock_left_corner}\}\).\{${current_rock_width}\}\(.*\)/\1${rock_shape_line}\2/g" tmp_file 
      endif
      @ rock_line_num = ( $rock_line_num - 1 )
    end
    tac tmp_file > simulation_file
    grep -A 30 "@" simulation_file
    set rock_line_num = $current_rock_line_num
    set wind_dir = `cat $file | sed 's/ */\n/g' | grep -v '^$' | sed "$wind_dir_num q;d"` 
    @ wind_dir_num = ( $wind_dir_num + 1 )
    echo "Wind dir num = $wind_dir_num"
    if ( $wind_dir_num > $num_winds ) then
       set wind_dir_num = `expr $wind_dir_num % $num_winds`
    endif
    echo "$wind_dir"
    if ( "$wind_dir" == "<"  && `grep "|@\|#@" simulation_file | wc -l` == 0) then
       echo "Hi"
       @ rock_left_corner = ( $rock_left_corner - 1 )
    else if ( "$wind_dir" == ">" && `grep "@|\|@#" simulation_file | wc -l` == 0 ) then
       echo "Hi"
       @ rock_left_corner = ( $rock_left_corner + 1 )
    endif
    echo $rock_left_corner
    sed -i 's/@/./g' tmp_file
    foreach rock_shape_line ( $current_rock_shape )
      #set print_line = $rock_ht + $rock_line_num
      if ( "$rock_shape_line" == ".@." ) then
         echo "check3"
         set tmp_current_rock_width = 1
         set tmp_rock_left_corner = `expr $rock_left_corner + 1`
         sed -i "$rock_line_num s/\(.\{${tmp_rock_left_corner}\}\).\{${tmp_current_rock_width}\}\(.*\)/\1@\2/g" tmp_file 
      else if ( "$rock_shape_line" == "..@" ) then
         echo "check4"
         set tmp_current_rock_width = 1
         set tmp_rock_left_corner = `expr $rock_left_corner + 2`
         sed -i "$rock_line_num s/\(.\{${tmp_rock_left_corner}\}\).\{${tmp_current_rock_width}\}\(.*\)/\1@\2/g" tmp_file 
      else
        sed -i "$rock_line_num s/\(.\{${rock_left_corner}\}\).\{${current_rock_width}\}\(.*\)/\1${rock_shape_line}\2/g" tmp_file 
      endif
      @ rock_line_num = ( $rock_line_num - 1 )
    end
    tac tmp_file > simulation_file
    grep -A  30 "@" simulation_file
    @ current_rock_line_num = ( $current_rock_line_num - 1 )
    set rock_line_num = $current_rock_line_num
    sed -i 's/@/./g' tmp_file
    if ( `grep -A 1 "@" simulation_file | tail -n 2 | sed '/@/ {N; s/\n//g}' | grep "@........#\|@........-" | wc -l ` > 0 ) then
       echo "Rock at Rest"
       set rock_at_rest = 1
       set current_rock_shape = ( `echo $current_rock_shape  | sed 's/#/@/g'` )
    else if ( $current_rock == 1 ) then
       if ( `grep -A 1 "@" simulation_file | tail -n 3 | sed '/@/ {N;N; s/\n//g}' | grep "@........#\|@........-" | wc -l ` > 0 ) then
         echo "Rock at Rest"
         set rock_at_rest = 1
         set current_rock_shape = ( `echo $current_rock_shape  | sed 's/#/@/g'` )
       endif
    endif
    echo ""
  end
  sed -i 's/@/#/g' simulation_file
  tac simulation_file > tmp_file
  grep -A 30 "@" simulation_file
  set tmp = `grep -n "#" tmp_file | tail -n 1 | sed 's/:.*//g'`
  set max_ht = `expr $tmp - 1`
  #echo "$current_rock_shape"
  
  @ current_rock = ( $current_rock + 1 )
  set current_rock = `expr $current_rock % 5`
  @ num = ( $num + 1 )
end
cat simulation_file
