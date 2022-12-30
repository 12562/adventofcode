#! /usr/bin/csh

set file = $argv[1]
set i = 1
set lst = ( `cat $file` )
while ( $i <= $#lst )
  set faces$i = ( "front" "back" "top" "bottom" "left" "right" )
  set current_x = `echo $lst[$i] | sed 's/,.*//g'` 
  set current_y = `echo $lst[$i] | grep -o ',[^,]*,' | sed 's/,//g'`
  set current_z = `echo $lst[$i] | sed 's/.*,//g'`
  set current = `eval echo \$faces$i`
  set j = 1
  set considered = `eval echo \$faces$j`
  echo "$current_x $current_y $current_z"
  while ( $j < $i )
    echo "$i : $current"
    echo "$j : $considered"
    set considered_x = `echo $lst[$j] | sed 's/,.*//g'` 
    set considered_y = `echo $lst[$j] | grep -o ',[^,]*,' | sed 's/,//g'`
    set considered_z = `echo $lst[$j] | sed 's/.*,//g'`
    set considered = `eval echo \$faces$j`
    if ( ($considered_x == $current_x) && ($considered_y == $current_y) ) then
       if ( $considered[3] == "top" ) then
          set considered[3] = $i
          set current[4] = $j
          break 
       else if ( $considered[4] == "bottom" ) then
          set considered[4] = $i
          set current[3] = $j
          break
       else
        @ j = ( $j + 1 )
         continue
       endif
    else if ( ($considered_y == $current_y) && ($considered_z == $current_z) ) then
       if ( $considered[5] == "left" ) then
          set considered[5] = $i
          set current[6] = $j
          break
       else if ( $considered[6] == "right" ) then
          set considered[6] = $i
          set current[5] = $j
          break
       else
        @ j = ( $j + 1 )
         continue
       endif
    else if ( ($considered_z == $current_z) && ($considered_x == $current_x) ) then
       if ( $considered[1] == "front" ) then
          set considered[1] = $i
          set current[2] = $j
          break
       else if ( $considered[2] == "back" ) then
          set considered[2] = $i
          set current[1] = $j
          break
       else
        @ j = ( $j + 1 )
         continue
       endif
    endif
    @ j = ( $j + 1 )
  end
#  echo "hi"
  set faces$i = ( $current )
#  echo "hi1"
  set faces$j = ( $considered )
#  echo "hi2"
  @ i = ( $i + 1 ) 
end

echo ""

set ctr = 1
set total = 0
while ( $ctr <= $#lst )
  echo -n "${ctr}:"
  eval echo \$faces$ctr
  set num = `eval echo \$faces$ctr | grep -o "top\|bottom\|left\|right\|front\|back" | sed 's/ /\n/g' | wc -l | awk '{print $1}'`
  @ total = ( $total + $num )
  @ ctr = ( $ctr + 1 )
end

echo ""
echo $total
