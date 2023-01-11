#! /usr/bin/tcsh

set priorities = 0
set i = 1
foreach line (`cat input3.txt`)
  if ( $i == 4 ) then
     set i = 1
     set priority = 0
  endif
  if ( $i == 1 ) then
     set first_string = `echo $line | sed "s/ */\n/g" | sort | uniq`
  else if ( $i == 2 ) then
     set second_string = `echo $line | sed "s/ */\n/g" | sort | uniq`
  else
     set third_string = `echo $line | sed "s/ */\n/g" | sort | uniq`
  endif
  @ i = ( $i + 1 ) 
  if ( $i == 4 ) then
     echo $first_string
     echo $second_string
     echo $third_string
     set letter = `echo "$first_string $second_string $third_string " | sed 's/ /\n/g' | sort | uniq -c | grep 3 | awk '{print $2}'`
     echo $letter
     set tmp = `echo "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" | sed "s/ */\n/g"`  
     set priority = `echo $tmp | sed 's/ /\n/g' | grep -n "$letter" | sed "s/:.*//g"` 
     set priorities = `expr $priorities + $priority`
  endif
end
echo $priorities
    
