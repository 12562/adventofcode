#! /usr/bin/csh

set file = $argv[1]
rm -f runtime_file
set num_rows = `cat $file | wc -l`
set num_cols = `cat $file | awk -F '' 'END {print NF}'`
set num_cols_minus_two = `cat $file | awk -F '' 'END {print NF}' | sed 's/$/ - 2/g' | bc`
set num_cols_minus_one = `cat $file | awk -F '' 'END {print NF}' | sed 's/$/ - 1/g' | bc`
set num_zeros = `grep -c -o 0 $file`
set max = `echo "$num_rows * $num_cols" | bc`
set num = 1
while ( $num <= $max )
  set value = `cat $file | sed 's/ */\n/g' | grep -v '^$'  | sed "$num q;d"`
  if ( $value != 9 && $value != 0 ) then
     set starting = `echo "$num - $num_cols" | bc`
     set ending = `echo "$num + $num_cols" | bc`
     if ( $starting < 1 ) then
        set starting = `expr $num - 1`
     endif
     if ( $starting < 1 ) then
        set starting = $num
     endif
     if ( $ending > $max ) then
        set ending =  `expr $num + 1`
     endif
     if ( $ending > $max ) then
        set ending = $num
     endif
     set str = ( `cat $file | sed 's/ */\n/g' | grep -v '^$' | sed -n "${starting},${ending} p"` )
     echo $str | sed 's/ *//g' >> runtime_file
  endif
  @ num = ( $num + 1 )
end

set ctr = 1
set ctr2 = 1
set indexes = ( 0 0 0 0 0 0 0 0 )
foreach num ( `cat $file | sed 's/ */\n/g' | grep -v '^$'`)
  echo $num
  if ( ($num != 9)  && ($num != 0) ) then
     #set numplusone = `expr $num + 1`
     set greater = "[${num}-9]"
     if ( $ctr == 1 ) then
        set to_add = `sed "$ctr2 q;d" runtime_file |  grep -o "${num}${greater}.\{${num_cols_minus_two}\}$greater" | wc -l`
     else if ( $ctr == $num_cols ) then
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "${greater}${num}.\{${num_cols_minus_one}\}$greater" | wc -l`
     else if ( $ctr == `echo "($num_rows - 1) * $num_cols + 1" | bc` ) then
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "$greater.\{${num_cols_minus_one}\}${num}${greater}" | wc -l`
     else if ( $ctr == $max ) then
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "$greater.\{${num_cols_minus_two}\}${greater}${num}" | wc -l`
     else if ( $ctr < $num_cols ) then
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "${greater}${num}${greater}.\{${num_cols_minus_two}\}$greater" | wc -l`
     else if ( `echo "$ctr % $num_cols" | bc` == 1 ) then
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "$greater.\{${num_cols_minus_one}\}${num}${greater}.\{${num_cols_minus_two}\}$greater" | wc -l`
     else if ( `echo "$ctr % $num_cols" | bc` == 0 ) then
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "$greater.\{${num_cols_minus_two}\}${greater}${num}.\{${num_cols_minus_one}\}$greater" | wc -l`
     else if ( `echo "($ctr / $num_cols) + 1" | bc` == $num_rows ) then
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "$greater.\{${num_cols_minus_two}\}${greater}${num}${greater}" | wc -l`
     else
        set to_add = `sed "$ctr2 q;d"  runtime_file |  grep -o "$greater.\{${num_cols_minus_two}\}${greater}${num}${greater}.\{${num_cols_minus_two}\}$greater" | wc -l`
     endif
     set tmp = $indexes[$num]
     set indexes[$num] = `expr $tmp + $to_add`
     @ ctr2 = ( $ctr2 + 1 )
  endif
  @ ctr = ( $ctr + 1 )
end
echo "ctr: $ctr :: ctr2 : $ctr2"
echo "NUm zeros: $num_zeros"
echo $indexes
expr $num_zeros + 2 \* $indexes[1] + 3 \* $indexes[2] + 4 \* $indexes[3] + 5 \* $indexes[4] + 6 \* $indexes[5] + 7 \* $indexes[6] + 8 \* $indexes[7] + 9 \* $indexes[8]
