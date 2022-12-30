#! /usr/bin/csh

rm -f without_beacon
set file = "$argv[1]"
set row = $argv[2]
set minx = 0
set miny = 0
set maxx = 0
set maxy = 0
set j = 0
set i = 0
set overallmaxx = 0
set overallmaxy = 0
set sensors = ()
set beacons = ()
set mds = ()
foreach line ( `cat $file | sed 's/ /_/g'` )
  set sensor_x = `echo $line | awk -F '_' '{print $3}' | grep -o '[0-9]\+'`
  set sensor_y = `echo $line | awk -F '_' '{print $4}' | grep -o '[0-9]\+'`
  #set sensors = ( $sensors "x${sensor_x}y${sensor_y}" ) 

  set beacon_x = `echo $line | awk -F '_' '{print $9}' | grep -o '[0-9]\+'`
  set beacon_y = `echo $line | awk -F '_' '{print $10}' | grep -o '[0-9]\+'`
  set beacons = ( $beacons "x${beacon_x}y${beacon_y}" )

  set xdist = `expr $beacon_x - $sensor_x | sed 's/-//g'`
  set ydist = `expr $beacon_y - $sensor_y | sed 's/-//g'`
  set md = `expr $xdist + $ydist`
  #set mds = ( $mds $md )
  
  set minx = `expr $sensor_x - $md`
  set miny = `expr $sensor_y - $md`
  set maxx = `expr $sensor_x + $md`
  set maxy = `expr $sensor_y + $md`
  echo $minx $maxx
  
  #set ctrx = $minx
  #set ctry = $miny
  if ( $row >= $miny && $row <= $maxy ) then 
     set ctrx = $minx
     set ctry = $row
     set ydistance = `expr $ctry - $sensor_y | sed 's/-//g'`
     #while ( $ctry <= $maxy ) 
       set dist_x = `expr $md - $ydistance`
       if ( $minx < `expr $sensor_x - $dist_x` ) then
         set ctrx = `expr $sensor_x - $dist_x`
         set maxx = `expr $sensor_x + $dist_x`
       else
         set ctrx = $minx
       endif
       while ( $ctrx <= $maxx )  
         set xdistance = `expr $ctrx - $sensor_x | sed 's/-//g'`
         if ( ($row == $ctry) && ( `expr $xdistance + $ydistance` <= $md ) ) then
            echo "x${ctrx}y${ctry}" >> without_beacon
         endif
         @ ctrx = ( $ctrx + 1 )
       end
     #  @ ctry = ( $ctry + 1 )
     #end
  endif

  #if ( $minx < $j ) then
  #  set j = $minx
  #endif

  #if ( $miny < $i ) then
  #  set i = $miny
  #endif
  #
  #if ( $maxx > $overallmaxx ) then
  #  set overallmaxx = $maxx
  #endif

  #if ( $maxy > $overallmaxy ) then
  #  set overallmaxy = $maxy
  #endif

end

cat without_beacon | sort | uniq  > wb
echo $beacons | sed 's/ /\n/g'  | grep "y$row" > b

cat wb b | sort | uniq -u | wc -l
  
#echo $i $j $overallmaxx $overallmaxy
#set minj = $j
  

#while ( $i <= $overallmaxy )
#  set j = $minj
#  printf %-4d "${i}" 
#  while ( $j <= $overallmaxx ) 
#    set tmp_i = `echo $i | sed 's/-//g'`
#    set tmp_j = `echo $j | sed 's/-//g'`
#    if ( `echo $sensors | sed 's/ /\n/g' | grep '^x'${j}y${i}'$' | wc -l` ) then
#       echo -n 'S'
#    else if ( `echo $beacons | sed 's/ /\n/g' | grep '^x'${j}y${i}'$' | wc -l` ) then
#       echo -n 'B' 
#    #else if ( `expr $tmp_i + $tmp_j | sed 's/-//g' ` <= $md ) then
#    else if ( `grep '^x'${j}y${i}'$' without_beacon | wc -l `) then
#       echo -n '#'
#    else 
#       echo -n '.'
#    endif
#    @ j = ( $j + 1 )
#  end
#  echo ''
#  @ i = ( $i + 1 )
#end
