set Hx = 0
set Hy = 0
set xmax = 0
set xmin = 0
set ymax = 0
set ymin = 0
set RED = '\033[0;31m'
set GREEN = '\033[0;32m'
set BLUE = '\033[0;34m'
set YELLOW = '\033[1;33m'
set NC = '\033[0m'

set file = $argv[1]
set dirs = `cat input9.txt | awk '{print $1}'`
set dists = `cat input9.txt | awk '{print $2}'`
set ctr = 1
while ( $ctr <= $#dirs ) 
  #echo $line
  #set dir = `echo $line | awk -F '_' '{print $1}'`
  set dir = $dirs[$ctr]
  #set dist = `echo $line | awk -F '_' '{print $2}'`
  set dist = $dists[$ctr]
  echo "$dir $dist"
  if ( $dir == "U" ) then
     set Hy = `expr $Hy - $dist`
  else if ( $dir == "L" ) then 
     set Hx = `expr $Hx - $dist`
  else if ( $dir == "R" ) then 
     set Hx = `expr $Hx + $dist`
  else if ( $dir == "D" ) then 
     set Hy = `expr $Hy + $dist`
  endif
  #echo "x: $Hx :: y : $Hy"
  if ( $Hx > $xmax ) then
     set xmax = $Hx
  endif
  if ( $Hx < $xmin ) then
     set xmin = $Hx
  endif
  if ( $Hy > $ymax ) then
     set ymax = $Hy
  endif
  if ( $Hy < $ymin ) then
     set ymin = $Hy
  endif
  @ ctr = ( $ctr + 1 )
end
echo "Xmax: $xmax :: Xmin: $xmin :: Ymax: $ymax :: Ymin: $ymin"
#set cols = `expr $xmax - $xmin + 1`
#set rows = `expr $ymax - $ymin + 1`

#set i = $ymin
#set j = $xmin
#
#while ( $i <= $ymax )
#  if ( $i < 0 ) then
#     set tmp_i = `echo $i | sed 's/-/_/g'`
#  else
#     set tmp_i = $i
#  endif
#  set row$tmp_i = ()
#  set j = $xmin
#  while ( $j <= $xmax )
#    set tmp = `eval echo \$row${tmp_i}`
#    set row$tmp_i = ( $tmp "." ) 
#    @ j =  ( $j + 1 )
#  end
#  #eval echo \$row$tmp_i
#  @ i = ( $i + 1 )
#end

echo "**************"

set x = ( 0 0 0 0 0 0 0 0 0 0 )
set y = ( 0 0 0 0 0 0 0 0 0 0 )
rm -f res_file*
set num = 1
while ( $num <= $#dirs ) 
  echo $num
  #set dir = `echo $line | awk -F '_' '{print $1}'`
  set dir = $dirs[$num]
  #set dist = `echo $line | awk -F '_' '{print $2}'`
  set dist = $dists[$num]
  set count = 0
  echo "$dir :: $dist"
  while ( $count < $dist )
    if ( $dir == "U" ) then
       set tmp = $y[1]
       @ tmp = ( $tmp - 1 ) 
       set y[1] = $tmp
    else if ( $dir == "L" ) then
       set tmp = $x[1]
       @ tmp = ( $tmp - 1 )
       set x[1] = $tmp
    else if ( $dir == "R" ) then
       set tmp = $x[1]
       @ tmp = ( $tmp + 1 )
       set x[1] = $tmp
    else if ( $dir == "D" ) then
       set tmp = $y[1]
       @ tmp = ( $tmp + 1 )
       set y[1] = $tmp
    endif
    set i = 2
    while ( $i <= 10 )
      set iminusone = `expr $i - 1`
      set x_diff = `expr $x[$iminusone] - $x[$i]`
      set y_diff = `expr $y[$iminusone] - $y[$i]`
      if ( $x_diff < 0 ) then
         set x_sign = "-"
      else
         set x_sign = "+"
      endif
      if ( $y_diff < 0 ) then
         set y_sign = "-"
      else
         set y_sign = "+"
      endif   
      if ( (` echo $x_diff | sed 's/-//g'` > 1) &&  (`echo $y_diff | sed 's/-//g'` > 1) ) then
         set tmp = $x[$i]
         @ tmp = ( $tmp $x_sign 1 )
         set x[$i] = $tmp
         set tmp = $y[$i]
         @ tmp = ( $tmp $y_sign 1 )
         set y[$i] = $tmp
      else 
         if ( ` echo $x_diff | sed 's/-//g'` > 1 ) then
           set tmp = $x[$i]
           @ tmp = ( $tmp $x_sign 1 )
           set x[$i] = $tmp
           set y[$i] = $y[$iminusone]
         endif
         if ( `echo $y_diff | sed 's/-//g'` > 1 ) then
           set tmp = $y[$i]
           @ tmp = ( $tmp $y_sign 1 )
           set y[$i] = $tmp
           set x[$i] = $x[$iminusone]
         endif
      endif
      @ i = ( $i + 1 )
    end
    echo "x:$x[10]_y:$y[10]" >> res_file
    #set ctr_i = $ymin
    #while ( $ctr_i <= $ymax )
    #  set tmp = ()
    #  set ctr_j = $xmin
    #  while ( $ctr_j <= $xmax )
    #    set mycount = 1
    #    set flag = 0
    #    set ctrij = 0
    #    while ( $mycount <= 10 )
    #      if ( ($y[$mycount] == $ctr_i) && ($x[$mycount] == $ctr_j) && ("x${ctr_j}y$ctr_i" != $ctrij) ) then
    #         set tmp = ( $tmp `expr $mycount - 1`  )
    #         set flag = 1
    #         set ctrij = "x${ctr_j}y$ctr_i"
    #      endif
    #      @ mycount = ( $mycount + 1 )
    #    end
    #    if ( ! $flag ) then
    #         set tmp = ( $tmp "." )
    #    endif
    #    @ ctr_j = ( $ctr_j + 1 )
    #  end
    #  echo $tmp
    #  @ ctr_i = ( $ctr_i + 1 )
    #end
    #echo ""
    @ count = ( $count + 1 )
  end
  #echo "x: $x :: y: $y" 
  @ num = ( $num + 1 )
end
cat res_file | sort | uniq | wc -l

set i = $ymin
while ( $i <= $ymax )
  set tmp = ()
  set j = $xmin
  while ( $j <= $xmax )
    if ( $i == 0 && $j == 0 ) then
       set tmp = ( $tmp "s" )
    else if ( `grep "x:${j}_y:$i" res_file | wc -l ` > 0 ) then
       set tmp = ( $tmp "#" )
    else
       set tmp = ( $tmp "." )
    endif
    @ j = ( $j + 1 )
  end
  #set row$i = $tmp
  #eval echo \$row$i
  if ( `echo $tmp | sed "s/ */\n/g" | grep "s" | wc -l ` > 0 ) then
    echo "${tmp}"
  else
    echo $tmp
  endif
  @ i = ( $i + 1 )
end
