#! /usr/bin/csh

set file = $argv[1]
set num = 0
set num2 = 0
set total = `cat $file | wc -l`
foreach line ( `cat $file | sed 's/ /_/g'`)
  set min = `echo $line | awk -F '-' '{print $1}'`
  set max = `echo $line | awk -F '_|-' '{print $2}'`
  set letter = `echo $line | awk -F '_|:' '{print $2}'`
  set pass = `echo $line | awk -F '_|:' '{print $4}'`
  set num_inst = `echo $pass | grep -o "$letter" | wc -l`
  if ( ($num_inst >= $min) && ($num_inst <= $max) ) then
     @ num += 1
  endif
  set password = (`echo $pass | sed 's/ */ /g'`)
  if ( ("$password[$min]" == "$letter" && "$password[$max]" != "$letter") || ("$password[$max]" == "$letter" && "$password[$min]" != "$letter")) then
     @ num2 += 1
  endif
end
echo "Part 1: $num"
echo "Part 2: $num2"
