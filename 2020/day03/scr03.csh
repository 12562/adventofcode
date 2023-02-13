#! /usr/bin/csh

set file = $argv[1]

set ht = `cat $file | wc -l`
set width = `cat $file | awk -F '' 'END {print NF}'`
set slope = 1
set x_slopes = ( 1 3 5 7 1 )
set y_slopes = ( 1 1 1 1 2 )
set trees = ( 0 0 0 0 0 )
while ( $slope <= $#x_slopes )
  set x_slope = $x_slopes[$slope]
  set y_slope = $y_slopes[$slope]
  set x = 1
  set y = 1
  while ( $y <= $ht )
    set x = `echo "($x + $x_slope) % $width" | bc` 
    if ( ! $x ) then
       set x = $width
    endif
    @ y = ( $y + $y_slope )
    set obj = `cat $file | sed "$y q;d" | awk -v var=$x -F '' '{print $var}'`
    if ( "$obj" == "#" ) then
       set tmp = $trees[$slope]
       set trees[$slope] = `expr $tmp + 1`
    endif
  end
  @ slope += 1
end
echo "Part 1: $trees[2]"
echo "Part 2: "`echo $trees | sed 's/ / * /g' | bc`
