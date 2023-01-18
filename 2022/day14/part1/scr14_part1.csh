#! /usr/bin/csh

set sand_drop_col = `grep "+" cave_structure.txt | sed 's/ */\n/g' | grep -v '^$' | grep -n "+" | awk -F ':' '{print $1}'`
rm -f cave_structure.txt
\cp -f cs cave_structure.txt
set max_depth = `wc -l cave_structure.txt | awk '{print $1}'`

set num = 1
set flag = 0
while ( 1 )
   set current_sand_drop_col = $sand_drop_col
   set at_rest = 0
   set current_depth = 2
   echo $num
   while ( ! $at_rest )
     set current_depth_plus_one = `expr $current_depth + 1`
     if ( $current_depth_plus_one == `expr $max_depth + 1` ) then
        set flag = 1
        break
     endif
     set current_col = `awk -F '' -v col=$current_sand_drop_col '{print $col}' cave_structure.txt`
     set current_col = `echo "$current_col" | sed 's/ */ /g'`
     #set bd_in_current_col = `echo $current_col | sed 's/ /\n/g' | grep -v '^$' | grep -n "\o\|\#" | awk -F ':' '{print $1}' | head -n 1`
     #echo $bd_in_current_col 
     set left_col_index = `expr $current_sand_drop_col - 1` 
     set left_of_current_col = `awk -F '' -v col=$left_col_index '{print $col}' cave_structure.txt`
     set left_of_current_col = `echo "$left_of_current_col" | sed 's/ */ /g'`
     #set bd_at_left_of_current_col = `echo $left_of_current_col | sed 's/ */\n/g' | grep -v '^$' | grep -n "\o\|\#" | awk -F ':' '{print $1}' | head -n 1`
     set rt_col_index = `expr $current_sand_drop_col + 1` 
     set rt_of_current_col = `awk -F '' -v col=$rt_col_index '{print $col}' cave_structure.txt`
     set rt_of_current_col = `echo "$rt_of_current_col" | sed 's/ */ /g'`
     #set bd_at_rt_of_current_col = `echo $rt_of_current_col | sed 's/ */\n/g' | grep -v '^$' | grep -n "\o\|\#" | awk -F ':' '{print $1}' | head -n 1`
     #echo $bd_at_left_of_current_col $bd_at_rt_of_current_col
     if ( $current_col[$current_depth_plus_one] == "." ) then
        @ current_depth = ( $current_depth + 1 )
     else if ( $left_of_current_col[$current_depth_plus_one] == "." ) then
        set current_sand_drop_col = $left_col_index
     else if ( $rt_of_current_col[$current_depth_plus_one] == "." ) then
        set current_sand_drop_col = $rt_col_index
     else
        set at_rest = 1
        set at_rest_depth = $current_depth
        set current_col[$at_rest_depth] = "o"
        echo "$current_col" | sed 's/ */\n/g' | grep -v '^$' > tmp
        awk -i inplace -F '' -v col=$current_sand_drop_col  'BEGIN{OFS=""}; FNR==NR{var[NR]=$1;next}{$col=var[FNR]}1' tmp cave_structure.txt
     endif
   end
   if ( $flag ) then
      break
   endif
   @ num = ( $num + 1 )
end
echo "Part 1: `expr $num - 1`"
