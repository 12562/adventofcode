#! /usr/bin/csh

set file = $argv[1]
set starting_items = (`cat $file | grep Starting | awk -F ':' '{print $2}' | sed 's/ //g'` )
set ctr = 1
while ( $ctr <= $#starting_items ) 
  echo $starting_items[$ctr] | sed 's/,/\n/g' > monkey$ctr
  @ ctr = ( $ctr + 1 )
end
set operation = (`cat $file | grep Operation | awk -F ':' '{print $2}' | sed 's/ //g'`)
#set operation = `grep Operation input11.txt | awk -F ':' '{print $2}' | sed 's/ new = old //g' | awk '{print $1}'`
#set values = `grep Operation input11.txt | awk -F ':' '{print $2}' | sed 's/ new = old //g' | awk '{print $2}'`

set test = (`grep Test $file | awk -F ':' '{print $2}' | awk '{print $3}'`)
set iftrue = (`grep "If true" $file | awk -F ':' '{print $2}' | awk '{print $4}'`)
set iffalse = (`grep "If false" $file | awk -F ':' '{print $2}' | awk '{print $4}'`)

set lcm = `echo $test  | sed 's/ / \* /g' | bc -l `
echo $lcm


set inspected = (`echo $test | sed 's/[0-9]*/0/g'`)
#echo $inspected
#echo $starting_items | sed 's/ /\n/g'
set round = 1
set num_rounds = 10000
while ( $round <= $num_rounds )
  set i = 1
  while ( $i <= $#starting_items ) 
    set multiple_items_worry_levels = (`cat monkey$i `)
    #echo "monkey$i"
    #cat monkey$i
    #echo "$multiple_items_worry_levels"
    set current_op = "$operation[$i]"
    #set current_value = "$values[$i]"
    set current_test = "$test[$i]"
    set current_iftrue = "$iftrue[$i]"
    set current_iffalse = "$iffalse[$i]"
    set current_inspected = $inspected[$i]
    #echo "ins:  $inspected"
    set inner_ctr  = 1
    set num_lines = `wc -l monkey$i | awk '{print $1}'`
    set inspected[$i] = `expr $current_inspected + $num_lines` 
    #echo "Size : `stat -c "%s" monkey$i`"
    if (  `stat -c "%s" monkey$i` > 1 ) then
      while ( $inner_ctr <= $num_lines )
          set individual_item_worry_level = `cat monkey$i | head -n $inner_ctr | tail -n 1`
          #echo "hi: $individual_item_worry_level"
          #if ( "$current_op" == "*" && "$current_value" != "old" ) then
          #   echo "check_"
          #   set new_worry_level = `echo "$individual_item_worry_level"  | sed 's/^\\(\|\\)$//g' | sed 's/\(+\)/\1 '$current_value' \\*/g' | sed 's/^/'$current_value' \\* /g' | sed 's/^/\\( /g' | sed "s/"'$'"/ \\)/g"`
          #   echo "$new_worry_level"
          #else if ( "$current_op" == "*" && "$current_value" == "old" ) then
          #   echo "check__"
          #   set terms = `echo "$individual_item_worry_level" | grep -o "[0-9]\+"`
          #   set myctr = 1
          #   while ( $myctr <= $#terms )
          #     while ( $myctr2 <= $#terms )
          #        set new_worry_level = ( $new_worry_level + ($terms[$myctr] \* $terms[$myctr2]) )
          #     end
          #   end
          #   set new_worry_level = "`echo $new_worry_level | sed 's/^+//g'`"
          #else
          #   echo "check___"
          #   set new_worry_level = `echo "$individual_item_worry_level" | sed 's/^\\(\|\\)$//g'  | sed 's/$/ + '$current_value'/g' | sed 's/^/\\( /g' | sed "s/"'$'"/ \\)/g"` 
          #endif
          set new_worry_level = ( `echo "$current_op" | sed 's/new=//g' | sed 's/old/'"$individual_item_worry_level"'/g' | sed 's/\(*\|+\)/ \1 /g'  | bc -l`)  #| sed 's/$/ \\)/g' | sed 's/^/\\( /g'`  )
          #echo "$new_worry_level"
          #echo "hi3"
          set worry_level_after_bored = `expr $new_worry_level % $lcm`
          #echo "hi2:"
          #echo "$worry_level_after_bored"
          #set mod_op = `echo "$worry_level_after_bored"  | sed 's/ \((\|)\)/ \\\1/g' | sed 's/\([0-9]\+\)/\1 % '$current_test'/g' | sed 's/$/ % '$current_test'/g'`
          #set mod_op = `echo "$worry_level_after_bored"  | sed 's/\([0-9]\+\)/\1 % '$current_test'/g' | sed 's/$/ % '$current_test'/g'`
          #echo "$mod_op"
          #echo "`expr $mod_op`"
          if ( `expr $worry_level_after_bored % $current_test` == 0 ) then
             set index = `expr $current_iftrue + 1`
             if ( `cat monkey$index | wc -l | awk '{print $1}'` == 0 ) then
                echo "$worry_level_after_bored" > monkey$index
             else
                echo "$worry_level_after_bored" >> monkey$index
             endif
          else
             set index = `expr $current_iffalse + 1`
             #echo "$starting_items[$index]"
             if ( `cat monkey$index | wc -l | awk '{print $1}'` == 0 ) then
                echo "$worry_level_after_bored" > monkey$index
             else
                echo "$worry_level_after_bored" >> monkey$index
             endif
          endif
          @ inner_ctr = ( $inner_ctr + 1 )
      end
    endif
    rm -f monkey$i
    touch monkey$i
    @ i = ( $i + 1 )
  end
  #echo $starting_items | sed 's/ /\n/g'
  if ( `expr $round % 200` == 0 ) then
     echo "Round : $round"
  endif
  @ round = ( $round + 1 )
end
echo $inspected
echo $inspected | sed 's/ /\n/g' | sort  -n | tail -n 2 | sed 'N; s/\n/\*/g' | bc -l
