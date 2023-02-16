#! /usr/bin/csh

set file = $argv[1]
set var = `cat $file | sed 's/\([0-9]\)/\1 /g'`
set num_cols = `cat $file | awk -F '' 'END {print NF}'`
set num_rows = `cat $file | wc -l`
set total = `expr $num_rows \* $num_cols`
set steps = 1
set num_steps = 100
set num_flashes = 0
while ( 1 ) 
  set var = `echo $var | sed 's/ /\n/g' | awk  -n '/[0-9]/ {print ($1 + 1) % 10};'`
  set zero_pos = `echo $var | sed 's/ /\n/g' | grep -n 0 | awk -F ':' '{print $1}'`
  set pos = `echo $var | sed 's/ /\n/g' | grep -n 0 | awk -F ':' '{print $1}' | awk -v total=$total -v num_cols=$num_cols '$1%num_cols != 1 && $1>num_cols {print $1 - num_cols - 1"\n"};  $1>num_cols {print $1 - num_cols"\n"}; $1%num_cols != 0 && $1>num_cols {print $1 - num_cols + 1"\n"}; $1%num_cols != 1 {print $1 - 1"\n"}; $1%num_cols != 0 {print $1 + 1"\n"}; $1%num_cols != 1 && $1 <= total - num_cols {print $1 + num_cols - 1"\n"};  $1 <= total - num_cols {print $1 + num_cols"\n"}; $1%num_cols != 0 && $1+num_cols <= total {print $1 + num_cols + 1}' | awk -v col=$num_cols -v row=$num_rows '$1>0 && $1<=col*row {print $1}' | sort -n`
  while ( $#pos )
     #echo "Pos: $pos"
     set to_add = `seq $total | paste -sd" " | sed 's/$/'" $pos"'/g' | sed 's/ /\n/g' | sort -n | uniq -c | awk '{print $1 - 1}'`
     set var = `echo $var | sed 's/0/-99/g'`
     set var = `echo "${var}:${to_add}" | sed 's/:/\n/g' | datamash -t ' ' sum 1-$total | sed 's/-[0-9]\+/0/g' | sed 's/1[1-9]/10/g' | sed 's/ /\n/g' | sed 's/$/ % 10 /g' | bc`
     #echo "Zero pos : $zero_pos"
     #echo $var | sed 's/ //g' | sed "s/\([0-9]\{$num_cols\}\)/\1\n/g"
     set new_zero_pos = `echo $var | sed 's/ /\n/g' | grep -n 0 | awk -F ':' '{print $1}'`
     set new_zero_pos = `echo "$zero_pos $new_zero_pos" | sed 's/ /\n/g' | sort -n | uniq -u`
     set pos = `echo $new_zero_pos | sed 's/ /\n/g' | awk -v total=$total -v num_cols=$num_cols '$1%num_cols != 1 && $1>num_cols {print $1 - num_cols - 1"\n"};  $1>num_cols {print $1 - num_cols"\n"}; $1%num_cols != 0 && $1>num_cols {print $1 - num_cols + 1"\n"}; $1%num_cols != 1 {print $1 - 1"\n"}; $1%num_cols != 0 {print $1 + 1"\n"}; $1%num_cols != 1 && $1 <= total - num_cols {print $1 + num_cols - 1"\n"};  $1 <= total - num_cols {print $1 + num_cols"\n"}; $1%num_cols != 0 && $1+num_cols <= total {print $1 + num_cols + 1}' | awk -v col=$num_cols -v row=$num_rows '$1>0 && $1<=col*row {print $1}' | sort -n`
     #set new_pos = `echo "$pos $new_pos" | sed 's/ /\n/g' | sort -n | uniq -u`
     #echo $new_zero_pos
     set zero_pos = `echo "$zero_pos $new_zero_pos" | sed 's/ /\n/g' | sort -n | uniq`
  end
  set  num_flashes = `expr $num_flashes + $#zero_pos`
  if ( $steps == 100 ) then
     echo "Part 1: $num_flashes"
  else if ( `echo $var | sed 's/ //g' | grep '^0\+$' | wc -l` ) then
     break
  endif
  @ steps = ( $steps + 1 )
end
echo "Part 2: $steps"
