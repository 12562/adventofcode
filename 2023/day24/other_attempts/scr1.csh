#!/usr/bin/tcsh

set file = $1
set debug = $2

set num_hailstones = `wc -l $file | awk '{print $1}'`
if ( $debug ) then
   echo "Number of hailstones : $num_hailstones"
endif

set X_change = `cat $file | awk '{print $5}' | sed 's/,//g'`
set Y_change = `cat $file | awk '{print $6}' | sed 's/,//g'`

set hailstoneX = `cat $file | awk '{print $1}' | sed 's/,//g'`
set hailstoneC = `cat $file | awk '{print $2" - (("$6"/"$5") * "$1")"}' | sed 's/,//g' | bc -l`
set hailstoneY = `cat $file | awk '{print $2}' | sed 's/,//g'`
set hailstoneM = `cat $file | awk '{print $6"/"$5}' | sed 's/,//g'`

set first_hailstone_path = 1
set secnd_hailstone_path = 2

if ( $file == "test_input.txt" ) then
 set testAreaMinX = 7
 set testAreaMinY = 7
 set testAreaMaxX = 27
 set testAreaMaxY = 27
else
 set testAreaMinX = 200000000000000
 set testAreaMinY = 200000000000000
 set testAreaMaxX = 400000000000000
 set testAreaMaxY = 400000000000000
endif

set numCrossPath = 0

while ($first_hailstone_path < $num_hailstones)
  set secnd_hailstone_path = `expr $first_hailstone_path + 1`
  if ( $X_change[$first_hailstone_path] > 0 ) then
     set X_first_future_symbol =  ">="
  else
     set X_first_future_symbol = "<="
  endif
  if ( $Y_change[$first_hailstone_path] > 0 ) then
     set Y_first_future_symbol = ">="
  else
     set Y_first_future_symbol = "<="
  endif
  while ( $secnd_hailstone_path <= $num_hailstones ) 
    if ( $debug ) then
       echo "I: $first_hailstone_path :: II: $secnd_hailstone_path"
    endif
    if ( `echo "$hailstoneM[$first_hailstone_path]" | bc -l` == `echo "$hailstoneM[$secnd_hailstone_path]" | bc -l`) then
       @ secnd_hailstone_path += 1
       continue
    else
       if ( $X_change[$secnd_hailstone_path] > 0 ) then
          set X_secnd_future_symbol =  ">="
       else
          set X_secnd_future_symbol = "<="
       endif
       if ( $Y_change[$secnd_hailstone_path] > 0 ) then
          set Y_secnd_future_symbol = ">="
       else
          set Y_secnd_future_symbol = "<="
       endif
     
       echo "- (($hailstoneC[$first_hailstone_path] - $hailstoneC[$secnd_hailstone_path]) / ($hailstoneM[$first_hailstone_path] - $hailstoneM[$secnd_hailstone_path]))" 
       set x = `echo "- (($hailstoneC[$first_hailstone_path] - $hailstoneC[$secnd_hailstone_path]) / ($hailstoneM[$first_hailstone_path] - $hailstoneM[$secnd_hailstone_path]))" | bc -l`
       
       if ( (`echo "$x >= $testAreaMinX" | bc -l`) && (`echo "$x <= $testAreaMaxX" | bc -l`) && (`echo "$x $X_first_future_symbol $hailstoneX[$first_hailstone_path]" | bc -l`) && (`echo "$x $X_secnd_future_symbol $hailstoneX[$secnd_hailstone_path]" | bc -l`)) then
          set y = `echo "($hailstoneM[$first_hailstone_path] * $x) + $hailstoneC[$first_hailstone_path]" | bc -l`
          if ( (`echo "$y >= $testAreaMinY" | bc -l`) && (`echo "$y <= $testAreaMaxY" | bc -l`) && (`echo "$y $Y_first_future_symbol $hailstoneY[$first_hailstone_path]" | bc -l`) && (`echo "$y $Y_secnd_future_symbol $hailstoneY[$secnd_hailstone_path]" | bc -l`)) then
             echo "====> x: $x :: y : $y"
             @ numCrossPath += 1
          endif
       endif
    endif
    @ secnd_hailstone_path += 1
  end 
  @ first_hailstone_path += 1
  echo "I: $first_hailstone_path :: II: $secnd_hailstone_path"
end

echo $numCrossPath
