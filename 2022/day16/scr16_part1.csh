#! /usr/bin/csh

set file = "$argv[1]"

set nodes = ()
set neighbor_nodes = ()
set rates = ()
foreach line (`cat $file | sed 's/, /,/g' | sed 's/ /_/g'`)
  set nodes = ( $nodes `echo $line | awk -F '_' '{print $2}'` )
  set neighbor_nodes = ( $neighbor_nodes `echo $line | awk -F '_' '{print $NF}'` )
  set rates = ( $rates `echo $line | awk -F '_' '{print $5}' | awk -F = '{print $2}' | sed 's/;//g'` )
end

echo $nodes
echo $neighbor_nodes
echo $rates

set stack = ( AA )
set visited = ()
set time_elapsed = 0
set time_left = 30
set pressure_released = 0

while ( $#stack > 0 )
  set current = $stack[1]
  echo -n "$current "
  #echo "Current : $current"
  set position = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$current'$' |  sed 's/:.*//g'`
  set visited = ( $visited $current )
  #echo "Visited : $visited"
  set stack = `echo $stack[2-]`
  #echo "Stack after deletion: $stack"
  set neighbors = `echo $neighbor_nodes[$position] | sed 's/,/ /g'`
  set true_neighbors = ()
  foreach neighbor ( $neighbors )
    if ( `echo $visited | sed 's/ /\n/g' | grep '^'$neighbor'$' | wc -l ` ==  0 ) then
       set true_neighbors = ( $true_neighbors $neighbor  ) 
    endif
  end
  set max_rate = 0
  set sorted_tn = ()
  set i = 1
  while ( $i <= $#true_neighbors )
    set j = `expr $i + 1`
    set posi = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$true_neighbors[$i]'$' | sed 's/:.*//g'`
    while ( $j <= $#true_neighbors )
      set posj = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$true_neighbors[$j]'$' | sed 's/:.*//g'`
      #echo "Rate J: $rates[$posj] :: Rate I: $rates[$posi]"
      if ( $rates[$posj] > $rates[$posi] ) then
         #echo "check"
         set temp = $true_neighbors[$i]
         set true_neighbors[$i] = $true_neighbors[$j]
         set true_neighbors[$j] = $temp
      endif
      @ j = ( $j + 1 )
    end
    @ i = ( $i + 1 )
  end 
  set stack = ( $true_neighbors $stack )
  #echo "Stack : $stack"
end
echo ""
