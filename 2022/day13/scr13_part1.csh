#! /usr/bin/csh

set file = $argv[1]
set result = 0
set pair = 1
foreach line ( `cat $file | grep -v '^$' | sed 'N; s/\n/_/g' | sed 's/\[/\(/g' | sed 's/\]/\)/g'`)
  #set line = `echo $line | sed 's/(/( /g' | sed 's/)/ )/g'`
  #set var = `echo $line | sed 's/,/ /g' `
  set first = (`echo $line | awk -F '_' '{print $1}' | sed 's/,/) (/g'  | sed 's/) (/)_(/g'`)
  set second = (`echo $line | awk -F '_' '{print $2}' | sed 's/,/) (/g' | sed 's/) (/)_(/g'`)
  echo "************************"
  echo "First:${first}::Second:${second}-"
  set num_first = `echo $first | grep -o ")_("  | grep -n ')' | tail -n 1  | sed 's/:.*/ + 1/g'  | bc -l`
  set num_second = `echo $second | grep -o ")_("  | grep -n ')' | tail -n 1  | sed 's/:.*/ + 1/g'  | bc -l`
  echo "Num first: $num_first :: Num second: $num_second"
  if ( $num_first == "" ) then
     set num_first = 1
  endif
  if ( $num_second == "" ) then
     set num_second = 1
  endif
  if ( $num_first > $num_second ) then
     #echo check
     set num = $num_first
     #echo $num
  else
     #echo check2
     set num = $num_second
     #echo $num
  endif
  set ctr = 1
  #echo $num
  while ( $ctr <= $num )
     set flag = 0
     set first_item = ""
     set second_item = ""
     #echo "************************"
     #echo "$first" | grep -o -e '\((\+[^(]*)_\)' -e '\((\+[^(]*)\+-\)' 
     #echo "  "
     #echo "$second" | grep -o -e '\((\+[^(]*)_\)' -e '\((\+[^(]*)\+-\)'
     #echo "************************"
     #set first_item = `echo $first | grep -o -e '\((\+[^(]*)_\)' -e '\((\+[^(]*)\+\-\)' | head -n $ctr | tail -n 1 `
     #set second_item = `echo $second | grep -o -e '\((\+[^(]*)_\)' -e '\(\((\)\+[^(]*\()\)\+\-\)' | head -n $ctr | tail -n 1 `
     set first_item = `echo $first | grep -o "(\+[0-9]*)"  | grep -n ')' | grep "^${ctr}:" | sed 's/.*://g'`
     set second_item = `echo $second| grep -o "(\+[0-9]*)"  | grep -n ')' | grep "^${ctr}:" | sed 's/.*://g'`
     echo $first_item
     echo $second_item
     #echo "check3"
     if ( (`echo "$first_item" | grep "[0-9]\+" | wc -l` > 0) && (`echo "$second_item" | grep "[0-9]\+" | wc -l` > 0) ) then
        #echo "in1"
        set first_number = `echo $first_item | grep -o "[0-9]\+" `
        set second_number = `echo $second_item | grep -o "[0-9]\+" `
        #echo "$first_number - $second_number"
        if ( $first_number < $second_number ) then
           set flag = 1
           echo "First number less than second number"
           break
        else if ( $first_number > $second_number ) then
           echo "First number greater than second number"
           break
        endif
        #echo "c1"
     else if ( (`echo "$first_item" | grep "[0-9]\+" | wc -l` > 0) && (`echo $second_item | grep "[0-9]\+" | wc -l`  == 0) ) then
        #echo "c2"
        echo "No second number"
        break
     else if ( (`echo $first_item | grep "[0-9]\+" | wc -l` == 0) && (`echo $second_item | grep "[0-9]\+" | wc -l`  > 0) ) then
        echo "No first number"
        set flag = 1
        break
     else if ( `echo $first_item | grep -o "(" | wc -l`  > `echo $second_item | grep -o "(" | wc -l` ) then
        #echo "c3"
        echo "Number of first item chunks greater than second item chunks"
        break
     else if ( `echo $first_item | grep -o "(" | wc -l`  < `echo $second_item | grep -o "(" | wc -l` ) then
        echo "Number of first item chunks less than second item chunks"
        set flag = 1
     endif
     #echo "First item:${first_item}::Second item:${second_item}"
     @ ctr = ( $ctr + 1 )
  end
  if ( $flag ) then
     echo $pair 
     set result = `expr $pair + $result `
  endif
  echo $line | grep --color "("
  #echo "************************"
  @ pair = ( $pair +  1 )
end
echo $result
