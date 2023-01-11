#! /usr/bin/csh

set file = $argv[1]
set width = `cat $file | sed 's/ */ /g' | awk 'END {print NF}'`
set height = `cat $file | wc -l `

set num_ht = 1
set num_wd = 1
while ( $num_ht <= $height )
 set col${num_ht} = (`cat $file | sed 's/ */ /g' | awk -v var=$num_ht '{print $var}'` )
 @ num_ht = ( $num_ht + 1 )
end

while ( $num_wd <= $width )
 set row${num_wd} = ( `cat $file | sed 's/ */ /g' | head -n $num_wd | tail -n 1` )
 @ num_wd = ( $num_wd + 1 )
end


set i = 2
set j = 2
set count = 0
while ( $i <= `expr $height - 1` )
  set j = 2
  while ( $j <= `expr $width - 1` )
    set visible = 0
    #echo "hi__"
    #eval echo \$col$j
    set tmp = `eval echo \$col$j`
    echo $tmp
    set tree_ht = $tmp[$i]
    set row = 1
    while ( $row < $i ) 
      if ( $tmp[$row] >= $tree_ht ) then
         set top_visible = 0
         break
      else
 ## Top visibility
         set top_visible = 1
      endif
      @ row = ( $row + 1 )
    end
    echo "Top: $top_visible"
    set row = $height
    while ( $row > $i ) 
      if ( $tmp[$row] >= $tree_ht ) then
         set bottom_visible = 0
         break
      else
 ## Bottom visibility
         set bottom_visible = 1
      endif
      @ row = ( $row - 1 )
    end
    echo "Bottom: $bottom_visible"
    #echo $i
    #eval echo \$row"$i"
    set tmp = `eval echo \$row"$i"`
    echo $tmp
    #echo "hi"
    set colmn = 1
    while ( $colmn < $j ) 
      if ( $tmp[$colmn] >= $tree_ht ) then
         set left_visible = 0
         break
      else
 ## Left visibility
         set left_visible = 1
      endif
      @ colmn = ( $colmn + 1 )
    end
    echo "Left: $left_visible"
    set colmn = $width 
    while ( $colmn > $j ) 
      if ( $tmp[$colmn] >= $tree_ht ) then
         set right_visible = 0
         break
      else
 ## Right visibility
         set right_visible = 1
      endif
      @ colmn = ( $colmn - 1 )
    end
    echo "Right: $right_visible"
    if ( $top_visible == 1 || $left_visible == 1 || $bottom_visible == 1 || $right_visible == 1) then
       @ count = ( $count + 1 )
    endif
    echo "[$i][$j]::${tree_ht}::$visible"
    @ j = ( $j + 1 )
  end
  @ i = ( $i + 1 )
end
echo `expr $width + $width + $height + $height + $count - 4`
