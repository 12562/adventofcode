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
foreach line ( `cat $file | sed 's/ /_/g'` ) 
  echo $line
  set dir = `echo $line | awk -F '_' '{print $1}'`
  set dist = `echo $line | awk -F '_' '{print $2}'`
  if ( $dir == "U" ) then
     set Hy = `expr $Hy - $dist`
  else if ( $dir == "L" ) then 
     set Hx = `expr $Hx - $dist`
  else if ( $dir == "R" ) then 
     set Hx = `expr $Hx + $dist`
  else if ( $dir == "D" ) then 
     set Hy = `expr $Hy + $dist`
  endif
  echo "x: $Hx :: y : $Hy"
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
end
echo "Xmax: $xmax :: Xmin: $xmin :: Ymax: $ymax :: Ymin: $ymin"
set cols = `expr $xmax - $xmin + 1`
set rows = `expr $ymax - $ymin + 1`

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

set Hx = 0
set Hy = 0
set Tx = 0
set Ty = 0
rm -f res_file
foreach line ( `cat $file | sed 's/ /_/g'` )
  set dir = `echo $line | awk -F '_' '{print $1}'`
  set dist = `echo $line | awk -F '_' '{print $2}'`
  set count = 0
  echo "$line :: $dir :: $dist"
  while ( $count < $dist )
    if ( $dir == "U" ) then
       set Hy = `expr $Hy - 1`
       if ( `expr  $Ty - $Hy ` > 1 ) then
          set Ty = `expr $Ty - 1`
          set Tx = $Hx
       endif
    else if ( $dir == "L" ) then
       set Hx = `expr $Hx - 1`
       if ( `expr  $Tx - $Hx ` > 1 ) then
          set Tx = `expr $Tx - 1`
          set Ty = $Hy
       endif
    else if ( $dir == "R" ) then
       set Hx = `expr $Hx + 1`
       if ( `expr  $Hx - $Tx ` > 1 ) then
          set Tx = `expr $Tx + 1`
          set Ty = $Hy
       endif
    else if ( $dir == "D" ) then
       set Hy = `expr $Hy + 1`
       if ( `expr  $Hy - $Ty ` > 1 ) then
          set Ty = `expr $Ty + 1`
          set Tx = $Hx
       endif
    endif
    echo "x:${Tx}_y:$Ty" >> res_file
    @ count = ( $count + 1 )
    #set i = $ymin
    #while ( $i <= $ymax )
    #  set tmp = ()
    #  set j = $xmin
    #  while ( $j <= $xmax )
    #    if ( $Ty == $i && $Tx == $j ) then
    #       set tmp = ( $tmp "T" )
    #    else if ( $Hy == $i && $Hx == $j ) then
    #       set tmp = ( $tmp "H" )
    #    else
    #       set tmp = ( $tmp "." )
    #    endif
    #    @ j = ( $j + 1 )
    #  end
    #  #set row$i = $tmp
    #  #eval echo \$row$i
    #  #echo $tmp
    #  @ i = ( $i + 1 )
    #end
    #echo ""
  end
  echo "Hx: $Hx :: Hy: $Hy :: Tx: $Tx :: Ty: $Ty" 
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
    echo -e "${RED}${tmp}${NC}"
  else
    echo $tmp
  endif
  @ i = ( $i + 1 )
end
