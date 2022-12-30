#! /usr/bin/csh

set file = $argv[1]
set i = 1
set lst = ( `cat $file` )
set total = 0
while ( $i <= $#lst )
  set current_x = `echo $lst[$i] | sed 's/,.*//g'` 
  set current_y = `echo $lst[$i] | grep -o ',[^,]*,' | sed 's/,//g'`
  set current_z = `echo $lst[$i] | sed 's/.*,//g'`

  set top = "${current_x},`expr $current_y + 1`,${current_z}"
  set bottom = "${current_x},`expr $current_y - 1`,${current_z}"
  set left = "`expr $current_x - 1 `,${current_y},${current_z}"
  set right = "`expr $current_x + 1 `,${current_y},${current_z}"
  set front = "${current_x},${current_y},`expr $current_z - 1`"
  set back = "${current_x},${current_y},`expr $current_z + 1`"
 
  set num = `grep -e '^'"${top}"'$' -e '^'"${bottom}"'$' -e '^'"$left"'$' -e '^'"$right"'$' -e '^'"$front"'$' -e '^'"$back"'$' $file | wc -l | awk '{print $1}'`
  #echo $num
  @ total = ( $total + $num )
  @ i = ( $i + 1 )
end

echo ""
set total_cubes = `wc -l $file | awk '{print $1}'`
echo $total
echo $total_cubes
echo `expr $total_cubes \* 6  - $total`
