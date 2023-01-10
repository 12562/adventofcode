#! /usr/bin/csh 

rm -f surface_cubes
set file = $argv[1] 
set i = 1 set lst = ( `cat $file` ) 
set total = 0 
set minx = `cat $file | awk -F ',' '{print $1}' | sort -n | head -n 1 | sed 's/$/ - 2/g' | bc -l` 
set miny = `cat $file | awk -F ',' '{print $2}' | sort -n | head -n 1 | sed 's/$/ - 1/g' | bc -l` 
set minz = `cat $file | awk -F ',' '{print $3}' | sort -n | head -n 1 | sed 's/$/ - 1/g' | bc -l`
echo $minx $miny $minz

set maxx = `cat $file | awk -F ',' '{print $1}' | sort -n | tail -n 1 | sed 's/$/ + 2/g' | bc -l`
set maxy = `cat $file | awk -F ',' '{print $2}' | sort -n | tail -n 1 | sed 's/$/ + 1/g' | bc -l`
set maxz = `cat $file | awk -F ',' '{print $3}' | sort -n | tail -n 1 | sed 's/$/ + 1/g' | bc -l`
echo $maxx $maxy $maxz
echo ""

echo "$minx,$miny,$minz" > visited
set queue = ( $minx,$miny,$minz $minx,$miny,$maxz $minx,$maxy,$minz $maxx,$miny,$maxz $maxx,$maxy,$minz $minx,$maxy,$maxz $maxx,$miny,$maxz $maxx,$maxy,$maxz )
while ( $#queue > 0 )
  set n = $queue[1]
  echo "Current: $n"
  echo "$n" >> visited
  set queue = ( `echo $queue[2-]` )
  #echo "checkif3" 
  set current_x = `echo $n | sed 's/,.*//g'` 
  #echo "checkif2" 
  set current_y = `echo $n | grep -o ',[^,]*,' | sed 's/,//g'`
  #echo "checkif1" 
  set current_z = `echo $n | sed 's/.*,//g'`
  #echo "checkif" 
  if ( ($current_x <= $maxx) && ($current_x >= $minx) && ($current_y <= $maxy) && ($current_y >= $miny) && ($current_z <= $maxz) && ($current_z >= $minz) ) then
     set top = "${current_x},`expr $current_y + 1`,${current_z}"
     set bottom = "${current_x},`expr $current_y - 1`,${current_z}"
     set left = "`expr $current_x - 1 `,${current_y},${current_z}"
     set right = "`expr $current_x + 1 `,${current_y},${current_z}"
     set front = "${current_x},${current_y},`expr $current_z - 1`"
     set back = "${current_x},${current_y},`expr $current_z + 1`"
     #echo "check"
     if ( `grep -- '^'"$n"'$' $file ` == "" ) then       
        set num = 0
        #echo "Inside if"
        foreach neighbor ( "$top" "$bottom" "$left" "$right" "$front" "$back" )
            echo "Neighbor : $neighbor"
            if ( `echo "$neighbor" | awk -F ',' '{print NF}'` < 3 ) then
               echo $neighbor
            endif
            if ( (`grep -e '^'"${neighbor}"'$' $file ` == "${neighbor}") ) then
#!( `grep '^'"${neighbor}"'$' visited | wc -l | awk '{print $1}'`) && 
               @ num = ( $num + 1 )
               echo "$neighbor" >> surface_cubes
            endif
        end
        @ total = ( $total + $num )
     endif
     foreach neighbor ( "$top" "$bottom" "$left" "$right" "$front" "$back" )
        set neighbor_x = `echo "$neighbor" | awk -F ',' '{print $1}'`
        set neighbor_y = `echo "$neighbor" | awk -F ',' '{print $2}'`
        set neighbor_z = `echo "$neighbor" | awk -F ',' '{print $3}'`
        echo "Check: $neighbor_x $neighbor_y $neighbor_z"
        if ( ($neighbor_x <= $maxx) && ($neighbor_x >= $minx) && ($neighbor_y <= $maxy) && ($neighbor_y >= $miny) && ($neighbor_z <= $maxz) && ($neighbor_z >= $minz)  && ( `grep '^'"${neighbor}"'$' visited | sort | uniq` != "${neighbor}" ) && ( `echo $queue | sed 's/ /\n/g' | grep '^'"${neighbor}"'$' | sort | uniq` != "${neighbor}" ) && ( `grep '^'"$neighbor"'$' $file | sort | uniq` != "${neighbor}") )  then
#
           set queue = ( $queue $neighbor )
        endif
     end
     #echo "check2"
  endif
  #echo "check3"
  echo $queue
  echo $total
end

echo $total
#echo ""
#set total_cubes = `wc -l $file | awk '{print $1}'`
#echo $total
#echo $total_cubes
#echo `expr $total_cubes \* 6  - $total`
