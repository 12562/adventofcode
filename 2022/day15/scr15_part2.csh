#! /usr/bin/csh

rm -f perimeter_coords*
set file = "$argv[1]"
set maxcoord = $argv[2]
set minx = 0
set miny = 0
set maxx = 0
set maxy = 0
set sensors = ()
set beacons = ()
set mds = ()
set ctr = 1
foreach line ( `cat $file | sed 's/ /_/g'` )
  set sensor_x = `echo $line | awk -F '_' '{print $3}' | grep -o '[-0-9]\+'`
  set sensor_y = `echo $line | awk -F '_' '{print $4}' | grep -o '[-0-9]\+'`
  #set sensors = ( $sensors "x${sensor_x}y${sensor_y}" ) 

  set beacon_x = `echo $line | awk -F '_' '{print $9}' | grep -o '[-0-9]\+'`
  set beacon_y = `echo $line | awk -F '_' '{print $10}' | grep -o '[-0-9]\+'`
  set beacons = ( $beacons "x${beacon_x}y${beacon_y}" )

  set xdist = `expr $beacon_x - $sensor_x | sed 's/-//g'`
  set ydist = `expr $beacon_y - $sensor_y | sed 's/-//g'`
  set md = `expr $xdist + $ydist`
  #set mds = ( $mds $md )
  
  #set minx = `expr $sensor_x - $md`
  #set miny = `expr $sensor_y - $md`
  #set maxx = `expr $sensor_x + $md`
  #set maxy = `expr $sensor_y + $md`
  set minx = 0
  set miny = 0
  set maxx = $maxcoord
  set maxy = $maxcoord
  echo $minx $maxx $minx $maxx
  
  set ctrx = `expr $sensor_x + $md + 1` 
  set ctry = $sensor_y
  while ( $ctrx >= $sensor_x )
    if ( ($ctrx >= $minx) && ($ctrx <= $maxx) && ($ctry >= $miny) && ($ctry <= $maxy ) ) then
       echo "x${ctrx}y${ctry}" >> perimeter_coords$ctr
    endif
    @ ctrx = ( $ctrx - 1 )
    @ ctry = ( $ctry + 1 )
  end
  #@ ctrx = ( $ctrx + 1 )
  @ ctry = ( $ctry - 2 ) 

  while ( $ctrx >= `expr $sensor_x - $md - 1` )
    if ( ($ctrx >= $minx) && ($ctrx <= $maxx) && ($ctry >= $miny) && ($ctry <= $maxy ) ) then
       echo "x${ctrx}y${ctry}" | grep "x\([1-3]\?[0-9]\{0,6\}\|4000000\)y" | grep "y\([1-3]\?[0-9]\{0,6\}\|4000000\)"'$' >> perimeter_coords$ctr
    endif
    @ ctrx = ( $ctrx - 1 )
    @ ctry = ( $ctry - 1 )
  end
  @ ctrx = ( $ctrx + 2 )
  while ( $ctrx <= $sensor_x )
    if ( ($ctrx >= $minx) && ($ctrx <= $maxx) && ($ctry >= $miny) && ($ctry <= $maxy ) ) then
       echo "x${ctrx}y${ctry}" | grep "x\([1-3]\?[0-9]\{0,6\}\|4000000\)y" | grep "y\([1-3]\?[0-9]\{0,6\}\|4000000\)"'$' >> perimeter_coords$ctr
    endif
    @ ctrx = ( $ctrx + 1 )
    @ ctry = ( $ctry - 1 )
  end
  @ ctry = ( $ctry - 2 ) 
  while ( $ctrx < `expr $sensor_x + $md + 1` )
    if ( ($ctrx >= $minx) && ($ctrx <= $maxx) && ($ctry >= $miny) && ($ctry <= $maxy ) ) then
       echo "x${ctrx}y${ctry}" | grep "x\([1-3]\?[0-9]\{0,6\}\|4000000\)y" | grep "y\([1-3]\?[0-9]\{0,6\}\|4000000\)"'$' >> perimeter_coords$ctr
    endif
    @ ctrx = ( $ctrx + 1 )
    @ ctry = ( $ctry + 1 )
  end
  @ ctr = ( $ctr + 1 )
end

cat perimeter_coords* | sort | uniq -c | sort | grep '^ *4'
