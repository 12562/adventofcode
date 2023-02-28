

set file = $argv[1]
set num = `wc -l $file | awk '{print $1}'`
set var = `cat min | awk -F ':' '{print $1}'`
foreach val ( `echo $var | sed 's/_/ /g'` )
 #echo "Val $val"
 set row = `echo "( $val - 1 + $num ) / $num" | bc`
 set col = `echo "$val % $num " | bc`
 if ( $row == 0 ) then
    set row = $num
 endif
 if ( $col == 0 ) then
    set col = $num
 endif
 #echo "$row $col"
 sed "$row q;d" $file  | awk -F '' -v col=$col '{print $col}' 
end
