#! /usr/bin/csh

set file = $argv[1]
set leftmost = `cat $file | grep -o "[0-9]\+," | sort -n | head -1 | sed 's/,//g'`
set rightmost = `cat $file | grep -o "[0-9]\+," | sort -n | tail -1 | sed 's/,//g'`
set bottommost = `cat $file | grep -o ",[0-9]\+" | sort -n | tail -1 | sed 's/,//g'`
#rm -f x y xy

#set cnt = 1
#set x = ()
#set y = ()
#foreach line ( `cat $file | sed 's/ /_/g'` )
#  set cols = `echo $line | awk -F '->' '{print NF}'`
#  set ctr = 1
#  while ( $ctr < $cols )
#    set start = `echo $line | awk -v ctr=$ctr -F '->' '{print $ctr}' | sed 's/_//g'`
#    set end = `echo $line | awk -v ctr=$ctr -F '->' '{print $(ctr+1)}' | sed 's/_//g'`
#    set start_x = `echo $start | sed 's/,.*//g'`
#    set start_y = `echo $start | sed 's/.*,//g'`
#    set end_x = `echo $end | sed 's/,.*//g'`
#    set end_y = `echo $end | sed 's/.*,//g'`
#    echo "$start_x $start_y $end_x $end_y"
#    if ( $start_x != $end_x ) then
#       if ( $start_x < $end_x ) then
#          set x_ = $start_x
#          set _x = $end_x 
#       else
#          set x_ = $end_x
#          set _x = $start_x 
#       endif
#       while ( $x_ <= $_x )
#         echo $x_ >> x
#         echo $start_y >>  y
#         @ x_ = ( ${x_} + 1 )
#       end
#    else
#       if ( $start_y < $end_y ) then
#          set y_ = $start_y
#          set _y = $end_y 
#       else
#          set y_ = $end_y
#          set _y = $start_y 
#       endif
#       while ( $y_ <= $_y )
#         echo $start_x >>  x
#         echo $y_ >>  y
#         @ y_ = ( $y_ + 1 )
#       end
#    endif
#    @ ctr = ( $ctr + 1 )
#  end
#  @ cnt = ( $cnt + 1 )
#end
#
#set ctr = 1
#set xy = ()
#while ( $ctr < `wc -l x | awk '{print $1}'` )
#  echo "`head -$ctr x | tail -n 1`,`head -$ctr y | tail -n 1`" >> xy
#  @ ctr = ( $ctr + 1 )
#end

set i = 0
set j = $leftmost
while ( $i <= $bottommost ) 
  set j = $leftmost
  while ( $j <= $rightmost )
    #echo "${i},$j"
    if ( `grep "^${j},${i}"'$' xy | wc -l`  > 0 ) then
       echo -n "#"
    else if ( $j == 500 && $i == 0 ) then
       echo -n "+"
    else
       echo -n "."
    endif
    @ j = ( $j + 1 )
  end
  echo ""
  @ i = ( $i + 1 )
end
