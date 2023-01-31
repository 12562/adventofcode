#! /usr/bin/csh

set file = $argv[1]
rm -f runtime_file
set num_rows = `cat $file | wc -l`
set num_cols = `cat $file | awk -F '' 'END {print NF}'`
set num_cols_minus_two = `cat $file | awk -F '' 'END {print NF}' | sed 's/$/ - 2/g' | bc`
set num_cols_minus_one = `cat $file | awk -F '' 'END {print NF}' | sed 's/$/ - 1/g' | bc`
set sum = `grep -o 0 $file | wc -l`
set max = `echo "$num_rows * $num_cols" | bc`
set num = 1
set indexes = ()
while ( $num <= $max )
  set value = `cat $file | sed 's/ */\n/g' | grep -v '^$'  | sed "$num q;d"`
  if ( $value != 9 && $value != 0 ) then
     set greater = "[${value}-9]"
     set starting = `echo "$num - $num_cols" | bc`
     set ending = `echo "$num + $num_cols" | bc`
     if ( $starting < 1 ) then
        set starting = `expr $num - 1`
     endif
     if ( $starting < 1 ) then
        set starting = $num
     endif
     if ( $ending > $max ) then
        set ending =  `expr $num + 1`
     endif
     if ( $ending > $max ) then
        set ending = $num
     endif
     set str = ( `cat $file | sed 's/ */\n/g' | grep -v '^$' | sed -n "${starting},${ending} p"` )
     set str = `echo $str | sed 's/ *//g'`
     if ( $num == 1 ) then
        set to_add = `echo $str |  grep -c "${value}${greater}.\{${num_cols_minus_two}\}$greater"`
     else if ( $num == $num_cols ) then
        set to_add = `echo $str |  grep -c "${greater}${value}.\{${num_cols_minus_one}\}$greater"`
     else if ( $num == `echo "($num_rows - 1) * $num_cols + 1" | bc` ) then
        set to_add = `echo $str |  grep -c "$greater.\{${num_cols_minus_one}\}${value}${greater}"`
     else if ( $num == $max ) then
        set to_add = `echo $str |  grep -c "$greater.\{${num_cols_minus_two}\}${greater}${value}"`
     else if ( $num < $num_cols ) then
        set to_add = `echo $str |  grep -c "${greater}${value}${greater}.\{${num_cols_minus_two}\}$greater"`
     else if ( `echo "$num % $num_cols" | bc` == 1 ) then
        set to_add = `echo $str |  grep -c "$greater.\{${num_cols_minus_one}\}${value}${greater}.\{${num_cols_minus_two}\}$greater"`
     else if ( `echo "$num % $num_cols" | bc` == 0 ) then
        set to_add = `echo $str |  grep -c "$greater.\{${num_cols_minus_two}\}${greater}${value}.\{${num_cols_minus_one}\}$greater"`
     else if ( `echo "($num / $num_cols) + 1" | bc` == $num_rows ) then
        set to_add = `echo $str |  grep -c "$greater.\{${num_cols_minus_two}\}${greater}${value}${greater}"`
     else
        set to_add = `echo $str |  grep -c "$greater.\{${num_cols_minus_two}\}${greater}${value}${greater}.\{${num_cols_minus_two}\}$greater"`
     endif
     if ( $to_add ) then
        @ sum = ( $sum + $value + 1 )
        set indexes = ( $indexes $num )
     endif
  else if ( $value == 0 ) then
     set indexes = ( $indexes $num )
  endif
  @ num = ( $num + 1 )
end

echo "Part 1 : $sum"
set basin_size = ()
foreach index ( $indexes )
   set queue = ( $index )
   set visited = ()
   set sum = 0
   while ( $#queue )
     set current = $queue[1]
     set visited = ( $current $visited )
     @ sum += 1
     set queue = `echo $queue[2-]`
     set neighbors = ()
     set true_neighbors = ()
     if ( $current == 1 ) then
        set neighbors = ( 2 `echo "$current + $num_cols" | bc` )
     else if ( $current == $num_cols ) then
        set neighbors = ( `echo "$current - 1" | bc` `echo "$current + $num_cols" | bc` )
     else if ( $current == `echo "($num_rows - 1) * $num_cols + 1" | bc` ) then
        set neighbors = ( `echo "$current - $num_cols" | bc` `echo "$current + 1" | bc` )
     else if ( $current == $max ) then
        set neighbors = ( `echo "$current - $num_cols" | bc` `echo "$current - 1" | bc` )
     else if ( $current < $num_cols ) then
        set neighbors = ( `echo "$current - 1" | bc` `echo "$current + 1" | bc` `echo "$current + $num_cols" | bc` )
     else if ( `echo "$current % $num_cols" | bc` == 1 ) then
        set neighbors = ( `echo "$current - $num_cols" | bc` `echo "$current + 1" | bc` `echo "$current + $num_cols" | bc` )
     else if ( `echo "$current % $num_cols" | bc` == 0 ) then
        set neighbors = ( `echo "$current - $num_cols" | bc` `echo "$current - 1" | bc` `echo "$current + $num_cols" | bc` )
     else if ( `echo "($current / $num_cols) + 1" | bc` == $num_rows ) then
        set neighbors = ( `echo "$current - $num_cols" | bc` `echo "$current - 1" | bc` `echo "$current + 1" | bc` )
     else
        set neighbors = ( `echo "$current - $num_cols" | bc` `echo "$current - 1" | bc` `echo "$current + 1" | bc` `echo "$current + $num_cols" | bc` )
     endif
     foreach neighbor ( $neighbors )
        set neighbor_value = `cat $file | sed 's/ */\n/g' | grep -v '^$'  | sed "$neighbor q;d"`
        if ( ($neighbor_value != 9 ) && (`echo $visited | sed 's/ /\n/g' | grep -c "^$neighbor"'$'` == 0 ) && (`echo $queue | sed 's/ /\n/g' | grep -c "^$neighbor"'$'` == 0 )) then
           set true_neighbors = ( $true_neighbors $neighbor )
        endif
     end
     set queue = ( $queue $true_neighbors ) 
   end
   set basin_size = ( $basin_size $sum )
end
echo "Part 2 : "`echo $basin_size | sed 's/ /\n/g' | sort -n | tail -n 3 | sed 'N;N; s/\n/ * /g' | bc`
