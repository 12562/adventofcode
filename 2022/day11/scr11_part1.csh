#! /usr/bin/csh

set file = $argv[1]
set starting_items = (`cat $file | grep Starting | awk -F ':' '{print $2}' | sed 's/ //g'` )
set operation = (`cat $file | grep Operation | awk -F ':' '{print $2}' | sed 's/ //g'`)
set test = (`grep Test $file | awk -F ':' '{print $2}' | awk '{print $3}'`)
set iftrue = (`grep "If true" $file | awk -F ':' '{print $2}' | awk '{print $4}'`)
set iffalse = (`grep "If false" $file | awk -F ':' '{print $2}' | awk '{print $4}'`)

set inspected = (`echo $test | sed 's/[0-9]*/0/g'`)
#echo $inspected
#echo $starting_items | sed 's/ /\n/g'
set round = 1
set num_rounds = 20
while ( $round <= $num_rounds )
  set i = 1
  while ( $i <= $#starting_items ) 
    set multiple_items_worry_levels = (`echo $starting_items[$i] | sed 's/,/ /g'`)
    #echo $multiple_items_worry_levels
    set current_op = "$operation[$i]"
    set current_test = "$test[$i]"
    set current_iftrue = "$iftrue[$i]"
    set current_iffalse = "$iffalse[$i]"
    set current_inspected = $inspected[$i]
    set inspected[$i] = `expr $current_inspected + $#multiple_items_worry_levels` 
    #echo "ins:  $inspected"
    foreach individual_item_worry_level ($multiple_items_worry_levels) 
        set new_worry_level = ( `echo "$current_op" | sed 's/new=//g' | sed 's/old/'$individual_item_worry_level' /g'  | sed 's/\(\*\|+\)/\1 /g' | bc -l `  )
        set worry_level_after_bored = `expr $new_worry_level / 3`
        if ( `expr $worry_level_after_bored % $current_test` == 0 ) then
           set index = `expr $current_iftrue + 1`
           if ( $starting_items[$index] == "" ) then
              set starting_items[$index] = "$worry_level_after_bored"
           else
              set starting_items[$index] = "$starting_items[$index],$worry_level_after_bored"
           endif
        else
           set index = `expr $current_iffalse + 1`
           if ( $starting_items[$index] == "" ) then
              set starting_items[$index] = "$worry_level_after_bored"
           else
              set starting_items[$index] = "$starting_items[$index],$worry_level_after_bored"
           endif
        endif
    end
    set starting_items[$i] = ""
    @ i = ( $i + 1 )
  end
  #echo $starting_items | sed 's/ /\n/g'
  @ round = ( $round + 1 )
end
echo $inspected | sed 's/ /\n/g' | sort  -n | tail -n 2 | sed 'N; s/\n/\*/g' | bc -l
