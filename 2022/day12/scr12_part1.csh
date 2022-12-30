#! /usr/bin/csh


set file = $argv[1]
set num_rows = `wc -l $file  | awk '{print $1}'`
set num_cols = `cat $file | awk -F '' 'END {print NF}'`

set str =  ( `cat $file | xargs echo | sed 's/ //g' | sed 's/ */\n/g'`  )
echo $str
set S = "b"
set a = "b"
set b = "c"
set c = "d"
set d = "e"
set e = "f"
set f = "g"
set g = "h"
set h = "i"
set i = "j"
set j = "k"
set k = "l"
set l = "m"
set m = "n"
set n = "o"
set o = "p"
set p = "q"
set q = "r"
set r = "s"
set s = "t"
set t = "u"
set u = "v"
set v = "w"
set w = "x"
set x = "y"
set y = "z"
set z = "z"
set ctr = 1

set source = `echo $str | sed 's/ */\n/g' | grep "[a-zA-Z]" | grep -n S | awk -F ':' '{print $1}'`
set dest = `echo $str | sed 's/ */\n/g' | grep "[a-zA-Z]" | grep -n E | awk -F ':' '{print $1}'`

set str = `echo $str | sed 's/S/a/g'`
set str = `echo $str | sed 's/E/z/g'`


set stack = ()
set stack = ( $source )
echo $stack
set visited = ()
set flag = 0
while ( $#stack > 0 ) 
  echo "Queue : $stack"
  set current = $stack[1] 
  echo "Current : $current"
  set visited = ( $visited $current )
  if ( $current == $dest ) then
     echo "Has path"
     echo $step
     set flag = 1
  endif
  set stack = `echo $stack[2-]`
  set possible_neighs_current = ( `expr $current - 1`   `expr $current + 1`  `expr $current + $num_cols`  `expr $current - $num_cols` )
  set true_neighbors = ()
  foreach neighbor ( $possible_neighs_current ) 
    if ( ($neighbor <= 0) || ($neighbor > $#str ) || (`echo $visited | sed 's/ /\n/g' | grep "^$neighbor"'$' | wc -l ` > 0)) then
       continue
    else if ( ( $str[$neighbor] != $str[$current] ) && ($str[$neighbor] != `eval echo \$$str[$current]`)  ) then
       continue
    else
       set true_neighbors = ( $true_neighbors $neighbor )
    endif
  end 
  echo $true_neighbors
  set stack = ( $stack $true_neighbors )  
end
if ( ! $flag ) then
  echo "No path"
endif
