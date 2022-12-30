#! /usr/bin/csh

set file = "input15.txt"
set sensors_x = ()
set sensors_y = ()
set beacons = ()
set mds = ()
foreach line ( `cat $file | sed 's/ /_/g'` )
  set sensor_x = `echo $line | awk -F '_' '{print $3}' | grep -o '[-0-9]\+'` 
  set sensor_y = `echo $line | awk -F '_' '{print $4}' | grep -o '[-0-9]\+'` 
  set sensors_x = ( $sensors_x $sensor_x ) 
  set sensors_y = ( $sensors_y $sensor_y ) 

  set beacon_x = `echo $line | awk -F '_' '{print $9}' | grep -o '[-0-9]\+'`
  set beacon_y = `echo $line | awk -F '_' '{print $10}' | grep -o '[-0-9]\+'`
  set beacons = ( $beacons "x${beacon_x}y${beacon_y}" )

  set xdist = `expr $beacon_x - $sensor_x | sed 's/-//g'`
  set ydist = `expr $beacon_y - $sensor_y | sed 's/-//g'`
  set md = `expr $xdist + $ydist`
  set mds = ( $mds $md )
end

set file = "result2"
set mainctr = 1
foreach line ( `cat $file | sed 's/[ \t]*//g'`)
   echo "$mainctr : $line"
   set flag = 1
   set x = `echo $line | grep -o "x[0-9]\+y" | sed 's/x\|y//g'` 
   set y = `echo $line | grep -o 'y[0-9]\+$' | sed 's/x\|y//g'` 
   set ctr = 1
   while ( $ctr <= $#sensors_x )
     set xdist = `echo "$x - $sensors_x[$ctr]" | bc | sed 's/-//g'`
     set ydist = `echo "$y - $sensors_y[$ctr]" | bc | sed 's/-//g'`
     set dist = `echo "$xdist + $ydist" | bc`
     if ( $dist <= $mds[$ctr] ) then
        set flag = 0
     endif 
     @ ctr = ( $ctr + 1 )
   end
   if ( $flag ) then
      echo $line >> final_result
   endif
   @ mainctr = ( $mainctr + 1 )
end
