#! /usr/bin/csh

set file = $argv[1]
set result = 0
set pair = 1
foreach line ( `cat $file | grep -v '^$' | sed 'N; s/\n/_/g' | sed 's/\[/\(/g' | sed 's/\]/\)/g'`)
  #set line = `echo $line | sed 's/(/( /g' | sed 's/)/ )/g'`
  #set var = `echo $line | sed 's/,/ /g' `
  set first = (`echo $line | awk -F '_' '{print $1}'  | sed 's/,/) (/g'  | sed 's/) (/)_(/g'`)
  set second = (`echo $line | awk -F '_' '{print $2}' | sed 's/,/) (/g' | sed 's/) (/)_(/g'`)
  set first = ( "($first)" )
  set second = ( "($second)" )
  set lvl = 1
  set flag = 0
  set num_first = (`csh scr "${first[$lvl]}" 0`)
  set num_second = (`csh scr "${second[$lvl]}" 0`)
  if ( $num_first > $num_second ) then
    set num = ( $num_first )
  else
    set num = ( $num_second )
  endif
  set ctr = ( 1 )
  echo "************************"
  process:
  set flag = $flag
  echo ""
  echo "Process called"
  echo "First:${first}::Second:${second}::LVL: ${lvl}::CTR: ${ctr}::NUM: ${num}::flag: ${flag}"
  #echo $#first
  #echo $#second
  echo ${first[$lvl]}
  echo ${second[$lvl]}
  if ( $lvl != $#ctr ) then
    set num_first = ( $num_first `csh scr "${first[$lvl]}" 0` )
    set num_second = ( $num_second `csh scr "${second[$lvl]}" 0`)
    echo "Num first: $num_first :: Num second: $num_second"
    if ( $num_first[$lvl] > $num_second[$lvl] ) then
       set num = ( $num $num_first[$lvl] )
    else
       set num = ( $num $num_second[$lvl] )
    endif
    set ctr = ( $ctr 1 )
  endif
  echo "**First:${first}::Second:${second}::LVL: ${lvl}::CTR: ${ctr}::NUM: ${num}"
  #echo $num
  while ( $ctr[$lvl] <= $num[$lvl] )
     set first_item = ""
     set second_item = ""
     echo "***First:${first}::Second:${second}::LVL: ${lvl}::CTR: ${ctr}::NUM: ${num}"
     #echo "************************"
     #echo "$first" | grep -o -e '\((\+[^(]*)_\)' -e '\((\+[^(]*)\+-\)' 
     #echo "  "
     #echo "$second" | grep -o -e '\((\+[^(]*)_\)' -e '\((\+[^(]*)\+-\)'
     #echo "************************"
     #set first_item = `echo $first | grep -o -e '\((\+[^(]*)_\)' -e '\((\+[^(]*)\+\-\)' | head -n $ctr | tail -n 1 `
     #set second_item = `echo $second | grep -o -e '\((\+[^(]*)_\)' -e '\(\((\)\+[^(]*\()\)\+\-\)' | head -n $ctr | tail -n 1 `
     set first_item = `csh scr "${first[$lvl]}" $ctr[$lvl]`
     set second_item = `csh scr "${second[$lvl]}" $ctr[$lvl]`
     echo "First item: $first_item :: $lvl"
     echo "Second item: $second_item :: $lvl"
     echo "check3"
     if ( ( `echo "$first_item" | grep '^[0-9]\+$' | wc -l` > 0  ) && ( `echo "$second_item" | grep '^[0-9]\+$' | wc -l ` > 0 ) ) then
        echo "one"
        if ( "$first_item" < "$second_item" ) then
           set flag = 1
           echo "Left side is smaller"
           break
        else if ( "$first_item" > "$second_item" ) then
           echo "Right side is smaller"
           set flag = 0
           break
        else
           set flag = 0.5
        endif
     else if ( ( `echo "$first_item" | grep '^(' | wc -l` > 0) && (`echo "$second_item" | grep '^(' | wc -l` > 0 ) ) then
        echo "two"
        set first = ( $first "$first_item" )
        set second = ( $second "$second_item" )
        @ lvl = ( $lvl + 1 )
        goto process 
     else if ( ( `echo "$first_item" | grep '^(' | wc -l` == 0 ) && (`echo "$second_item" | grep '^(' | wc -l` > 0 )  && ( "$first_item" != "" ) ) then
        echo "three"
        set first_item = "($first_item)"
        set first = ( $first "$first_item" )
        set second = ( $second "$second_item" )
        @ lvl = ( $lvl + 1 )
        goto process
     else if ( ( `echo "$second_item" | grep '^(' | wc -l` == 0 ) && (`echo "$first_item" | grep '^(' | wc -l` > 0 ) && ( "$second_item" != "" ) )  then
        echo "four"
        set second_item = "($second_item)"
        set first = ( $first "$first_item" )
        set second = ( $second "$second_item" )
        @ lvl = ( $lvl + 1 )
        goto process
     else
        echo "five"
        echo "$first_item :: $second_item"
        if ( "$first_item" == "" && "$second_item" != "" ) then
           set flag = 1
           echo "Left side ran out of items"
           break
        else if ( "$first_item" != "" && "$second_item" == "" ) then
           set flag = 0
           echo "Right side ran out of items" 
           break
        else 
           set flag = 0.5
        endif
     endif
     #echo "CTR : $ctr[$lvl] :: LVL: $lvl"
     set val = $ctr[$lvl]
     set ctr[$lvl] = `expr $val + 1` 
     echo "CTR : $ctr :: LVL: $lvl :: NUM: $num"
  end
  if ( $flag == 0.5 ) then
     echo "pointfive"
     @ lvl = ( $lvl - 1 )
     #echo "lvl: $lvl :: first: $first r $#first :: second: $second r $#second"
     set first = ( ${first[1-$lvl]} )
     set second = ( ${second[1-$lvl]} )
     #echo "check2"
     set num_first = ( $num_first[1-$lvl] )
     set num_second = ( $num_second[1-$lvl] )
     #echo "check"
     set val = $ctr[$lvl]
     set ctr[$lvl] = `expr $val + 1`
     set ctr = ( $ctr[1-$lvl] )
     set num = ( $num[1-$lvl] )
     #echo "num: $num :: ctr: $ctr"
     goto process
  endif
  if ( $flag ) then
     echo $pair 
     set result = `expr $pair + $result `
  endif
  echo $line | grep --color "("
  echo "************************"
  @ pair = ( $pair +  1 )
end
echo $result



         
#     if ( (`echo "$first_item" | grep "[0-9]\+" | wc -l` > 0) && (`echo "$second_item" | grep "[0-9]\+" | wc -l` > 0) ) then
#        echo "in1"
#        set first_number = `echo $first_item | grep -o "[0-9]\+" `
#        set second_number = `echo $second_item | grep -o "[0-9]\+" `
#        echo "$first_number - $second_number"
#        if ( $first_number < $second_number ) then
#           set flag = 1
#           echo "First number less than second number"
#           break
#        else if ( $first_number > $second_number ) then
#           echo "First number greater than second number"
#           break
#        endif
#        echo "c1"
#     else if ( (`echo "$first_item" | grep "[0-9]\+" | wc -l` > 0) && (`echo "$second_item" | grep "[0-9]\+" | wc -l`  == 0) ) then
#        echo "c2"
#        echo "No second number"
#        break
#     else if ( (`echo "$first_item" | grep "[0-9]\+" | wc -l` == 0) && (`echo "$second_item" | grep "[0-9]\+" | wc -l`  > 0) ) then
#        echo "No first number"
#        set flag = 1
#        break
#     else if ( `echo "$first_item" | grep -o "(" | wc -l`  > `echo "$second_item" | grep -o "(" | wc -l` ) then
#        echo "c3"
#        echo "Number of first item chunks greater than second item chunks"
#        break
#     else if ( `echo "$first_item" | grep -o "(" | wc -l`  < `echo "$second_item" | grep -o "(" | wc -l` ) then
#        echo "Number of first item chunks less than second item chunks"
#        set flag = 1
#     endif
#     echo "First item:${first_item}::Second item:${second_item}"
#     @ ctr = ( $ctr + 1 )
#  end
