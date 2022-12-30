#! /usr/bin/csh

set file = $argv[1]
set starting_items = (`cat $file | grep Starting | awk -F ':' '{print $2}' | sed 's/ //g'` )
set operation = (`cat $file | grep Operation | awk -F ':' '{print $2}' | sed 's/ //g'`)
set test = (`grep Test $file | awk -F ':' '{print $2}' | awk '{print $3}'`)
set iftrue = (`grep "If true" $file | awk -F ':' '{print $2}' | awk '{print $4}'`)
set iffalse = (`grep "If false" $file | awk -F ':' '{print $2}' | awk '{print $4}'`)
set lcm = `echo $test | sed 's/ / \* /g' | bc -l`
echo $lcm
set inspected = (`echo $test | sed 's/[0-9]*/0/g'`)
#echo $inspected
#echo $starting_items | sed 's/ /\n/g'
set round = 1 
set num_rounds = 10000
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
    echo "set old = ($multiple_items_worry_levels)" > tmp
    #echo "$current_op" | grep "old\*old" 
    if ( `echo "$current_op" | grep -o "old\*old" ` ==  "old*old" ) then
       yes "new = old * old" | head -n $#multiple_items_worry_levels | grep -n old | sed 's/\(*\|+\)/ \\\1 /g' | sed 's/\([^:]*\):\(.*= \)old/\1:expr \\( $old[\1]/g' | sed 's/\(.\):\(.*\)old/\2 $old[\1]/g'  | sed 's/$/ \\\) % '$lcm'/g' >> tmp
    else
       yes "$current_op" | head -n $#multiple_items_worry_levels | grep -n old | sed 's/\(*\|+\)/ \\\1 /g' | sed 's/\([^:]*\):\(.*\)old/expr \\\( $old[\1]/g' | sed 's/$/ \\\) % '$lcm'/g' >> tmp
    endif
    #cat tmp
    set multiple_items_worry_levels = (`csh tmp` )
    #echo $multiple_items_worry_levels
    #echo "ins:  $inspected"
    foreach individual_item_worry_level ($multiple_items_worry_levels) 
        #set new_worry_level = ( `echo "$current_op" | sed 's/new=//g' | sed 's/old/'$individual_item_worry_level' /g'  | sed 's/\(\*\|+\)/\1 /g' | bc -l `  )
        #set worry_level_after_bored = `expr $new_worry_level % $lcm`
        if ( `expr $individual_item_worry_level % $current_test` == 0 ) then
           set index = `expr $current_iftrue + 1`
           if ( $starting_items[$index] == "" ) then
              set starting_items[$index] = "$individual_item_worry_level"
           else
              set starting_items[$index] = "$starting_items[$index],$individual_item_worry_level"
           endif
        else
           set index = `expr $current_iffalse + 1`
           if ( $starting_items[$index] == "" ) then
              set starting_items[$index] = "$individual_item_worry_level"
           else
              set starting_items[$index] = "$starting_items[$index],$individual_item_worry_level"
           endif
        endif
    end
    set starting_items[$i] = ""
    @ i = ( $i + 1 )
  end
  #echo $starting_items | sed 's/ /\n/g'
  @ round = ( $round + 1 )
  if ( `expr $round % 200` == 0 ) then
     echo $round
  endif
end
echo $inspected | sed 's/ /\n/g' | sort  -n | tail -n 2 | sed 'N; s/\n/\*/g' | bc -l
