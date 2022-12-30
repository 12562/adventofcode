#! /usr/bin/tcsh

set priorities = 0
foreach line (`cat input3.txt`)
  set num_cols = `echo $line | sed 's/ */\n/g' | sed '/^$/d' | wc -l`
  set half = `expr $num_cols / 2`
  set first_string = `echo $line | sed 's/ */\n/g' | sed '/^$/d' | head -n $half | sort | uniq`
  set second_string = `echo $line | sed 's/ */\n/g' | sed '/^$/d' | tail -n $half | sort | uniq`
  set letter = `echo "$first_string $second_string " | sed 's/ / \n/g' | sort | uniq -d`
  echo "$line :: $letter"
  set tmp = `echo "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" | sed "s/ */\n/g"`  
  set priority = `echo $tmp | sed 's/ /\n/g' | grep -n "$letter" | sed "s/:.*//g"` 
  echo $priority
  set priorities = `expr $priorities + $priority`
end
echo $priorities
    
