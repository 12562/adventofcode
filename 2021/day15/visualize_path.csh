
set file = $argv[1]
rm -f check
rm -f lst
set num_rows = `wc -l $file | awk '{print $1}'`
set num_cols = `awk -F '' 'END {print NF}' $file`
set num = `expr $num_rows \* $num_cols`
set next_num = `sed "$num q;d" prev` 
touch lst
while ( $num != 1 )
  echo $num >> lst
  set num = `sed "$num q;d" prev`
end
set num = `expr $num_rows \* $num_cols`
while ( $num >= 1 )
  set row = `echo $num | sed 's/\(.*\)/'"(\1 + $num_cols - 1) \/ $num_cols/g" | bc`
  set col = `echo $num | sed 's/$/'" % $num_cols/g" | bc`
  if ( $col == 0 ) then
    set col = $num_cols
  endif
  set to_print = `sed "$row q;d"  $file | awk -F '' -v col=$col '{print $col}'`
  if ( `cat lst | grep -c "^$num"'$'`)  then
     /usr/bin/echo -e "\e[1;31m ${to_print} \e[0m" >> check
     #set next_num = `sed "$num q;d" prev` 
  else
     echo "$to_print" >> check
  endif
  if ( `expr $num % $num_cols` == 1 ) then
     echo ":"  >> check
  endif
  @ num -= 1
end
tac check | paste -sd ' ' | sed 's/:/\n/g' | sed 's/ //g'
