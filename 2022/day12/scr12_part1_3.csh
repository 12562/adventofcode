#! /usr/bin/csh


set file = $argv[1]
set num_rows = `wc -l $file  | awk '{print $1}'`
set num_cols = `cat $file | awk -F '' 'END {print NF}'`

rm -f prev S visited
set str =  ( `cat $file | xargs echo `  )
echo $str
set a = 1
set b = 2
set c = 3
set d = 4
set e = 5
set f = 6
set g = 7
set h = 8
set i = 9
set j = 10
set k = 11
set l = 12
set m = 13
set n = 14
set o = 15
set p = 16
set q = 17
set r = 18
set s = 19
set t = 20
set u = 21
set v = 22
set w = 23
set x = 24
set y = 25
set z = 26
set ctr = 1

set source = `echo "($argv[2] - 1) * $num_cols + 1" | bc -l`
#`echo $str | sed 's/ //g' | sed 's/ */\n/g' | grep "[a-zA-Z]" | grep -n S | awk -F ':' '{print $1}'`
set dest = `echo $str | sed 's/ //g' | sed 's/ */\n/g' | grep "[a-zA-Z]" | grep -n E | awk -F ':' '{print $1}'`

set str = `echo $str | sed 's/S/a/g'`
set str = `echo $str | sed 's/E/z/g'`
set num_per_str = `echo $str[1] | sed 's/ */ /g'`
set num_str = `expr $#str \* $#num_per_str`
echo $num_str
echo $str | sed 's/ */\n/g' | grep "[a-zSE]" | grep -n "[a-zSE]" | sed 's/:.*//g' > prev

set queue = ()
set queue = ( $source )
echo $queue
touch visited
set flag = 0
while ( $#queue > 0 ) 
  #echo "Queue : $queue"
  set current = $queue[1] 
  #echo "Current : $current"
  echo $current >> visited
  if ( $current == $dest ) then
     echo "Has path"
     set flag = 1
     break
  endif
  set queue = `echo $queue[2-]`
  set possible_neighs_current = ( `expr $current - 1`   `expr $current + 1`  `expr $current + $num_cols`  `expr $current - $num_cols` )
  set true_neighbors = ()
  foreach neighbor ( $possible_neighs_current ) 
    if ( ($neighbor <= 0) || ($neighbor > $num_str ) || (`echo $queue | sed 's/ /\n/g' | grep "^$neighbor"'$' | wc -l ` > 0 ) || (`grep "^"$neighbor'$' visited | wc -l` > 0)) then
       continue
    else
       set neighbor_row = `echo  "$neighbor / $num_cols" | bc -l  | jq '.|ceil'`
       set neighbor_col = `expr $neighbor % $num_cols`
       if ( $neighbor_col == 0 ) then
          set neighbor_col = 8
       endif
       set neighbor_char = `echo $str[$neighbor_row] | sed 's/ */\n/g' | grep "[a-z]" | head -n $neighbor_col | tail -n 1`
       #echo "Neighbor: $neighbor :: $neighbor_row :: $neighbor_col :: $neighbor_char"
       set num_neighbor = `eval echo \$$neighbor_char`
       set current_row = `echo  "$current / $num_cols" | bc -l  | jq '.|ceil'`
       set current_col = `expr $current % $num_cols`
       if ( $current_col == 0 ) then
          set current_col = 8
       endif
       set current_char = `echo $str[$current_row] | sed 's/ */\n/g' | grep "[a-z]" | head -n $current_col | tail -n 1`
       #echo "current: $current :: $current_row :: $current_col :: $current_char"
       set num_current = `eval echo \$$current_char`
       #echo $num_current
       #echo $num_neighbor
       if (  $num_neighbor > `expr $num_current + 1`  ) then
          continue
       else
          set true_neighbors = ( $true_neighbors $neighbor )
       endif
    endif
  end 
  #echo $true_neighbors
  foreach neighbor  ( $true_neighbors )
    sed -i "s/^${neighbor}"'$'"/${current}/g" prev
  end
  set queue = ( $queue $true_neighbors )  
end
if ( ! $flag ) then
  echo "No path"
else
  touch S
  set u = $dest
  while ( $u != $source )
    echo $u >> S
    #echo $u
    set u = `cat prev | head -n $u | tail -n 1`
  end
  echo `wc -l S`
  #cat S | xargs echo
endif
