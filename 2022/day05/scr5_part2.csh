#! /usr/bin/tcsh

set i = 1
set num_cols = `sed -n '/\[/p' input5.txt | sed 's/    / \[_\]/g' | awk '{print NF}' | head -n 1`
while ( $i <= $num_cols )
  set col$i = (`sed -n '/\[/p' input5.txt | sed 's/    / \[_\]/g' | awk -v col=$i '{print $col}' | sed 's/\[\|\]\|_//g' | tac `)
  eval echo \$"col$i"
  @ i = ( $i + 1 )
end

set cnt = 1
foreach line (`cat input5.txt | grep "move"  | sed 's/ /_/g' `)
 echo "*****************"
 echo $line
 set num_move = `echo $line | awk -F "_" '{print $2}'`
 set from = `echo $line | awk -F '_' '{print $4}'`
 set to = `echo $line | awk -F '_' '{print $6}'`
 echo -n "From: "
 eval echo \$"col$from"
 echo -n "To: "
 eval echo \$"col$to"
 set num = 0
 set from_tmp = `eval echo \$col$from`
 set to_tmp = `eval echo \$col$to`
 if ( $num_move == 1 ) then
    while ( $num < $num_move )
      set to_tmp = ( $to_tmp $from_tmp[$#from_tmp] )
      set from_tmp[$#from_tmp] = ""
      @ num = ( $num + 1 )
    end
 else
    set from_tmp = `eval echo \$col$from`
    set to_tmp = `eval echo \$col$to`
    set start_index = `expr $#from_tmp - $num_move + 1`
    set end_index = $#from_tmp
   echo $start_index $end_index
    set to_tmp = ( $to_tmp $from_tmp[${start_index}-${end_index}] )
    while ( $num < $num_move )
      set index =  `expr $#from_tmp - $num`
      set from_tmp[$index] = ""
      @ num = ( $num + 1 )
    end
 endif
 set col$from =  ( $from_tmp )
 set col$to =  ( $to_tmp )
 echo $cnt
 
 echo -n "Final From: "
 eval echo \$"col$from"
 echo -n "Final To: "
 eval echo \$"col$to"
 echo "*****************"
 @ cnt = ( $cnt + 1 )
end

echo ""

set i = 1
while ( $i <= $num_cols )
  eval echo \$"col$i"
  @ i = ( $i + 1)
end
echo ""
echo  -n "Ans: "
set i = 1
while ( $i <= $num_cols )
  set tmp = `eval echo \$col$i`
  eval echo -n "$tmp[$#tmp]"
  @ i = ( $i + 1 )
end
echo ""
