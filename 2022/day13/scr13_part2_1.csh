#! /usr/bin/csh

set file = $argv[1]
#cat $file | grep -v '^$' | sed 's/\[/\(/g' | sed 's/\]/\)/g' > reference_file
#cat $file | grep -v '^$' | sed 's/\[/\(/g' | sed 's/\]/\)/g' > reference_file2
#echo "((2))" >> reference_file
#echo "((2))" >> reference_file2
#echo "((6))" >> reference_file
#echo "((6))" >> reference_file2
set num_packets = `wc -l reference_file | awk '{print $1}'`
set current_packet = 1
while ( $current_packet <= $num_packets )
  set comparison_packet = `expr $current_packet + 1`
  echo $current_packet
  while ( $comparison_packet < $num_packets)
    echo $comparison_packet
    set comp_packet = `expr $comparison_packet + 1`
    set org_format_first = `cat reference_file | head -n $comparison_packet | tail -n 1`
    set first = (`echo $org_format_first | sed 's/,/) (/g'  | sed 's/) (/)_(/g'`)
    set org_format_second = `cat reference_file | head -n $comp_packet | tail -n 1`
    set second = (`echo $org_format_second | sed 's/,/) (/g' | sed 's/) (/)_(/g'`)
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
    ###############################
    #echo "************************"
    ###############################
    process:
      ###############################
      #echo ""
      #echo "Process called"
      #echo "First:${first}::Second:${second}::LVL: ${lvl}::CTR: ${ctr}::NUM: ${num}::flag: ${flag}"
      #echo ${first[$lvl]}
      #echo ${second[$lvl]}
      ###############################
      set flag = $flag
      if ( $lvl != $#ctr ) then
         set num_first = ( $num_first `csh scr "${first[$lvl]}" 0` )
         set num_second = ( $num_second `csh scr "${second[$lvl]}" 0`)
         ###############################
         #echo "Num first: $num_first :: Num second: $num_second"
         ###############################
         if ( $num_first[$lvl] > $num_second[$lvl] ) then
            set num = ( $num $num_first[$lvl] )
         else
            set num = ( $num $num_second[$lvl] )
         endif
         set ctr = ( $ctr 1 )
      endif
      ###############################
      #echo "**First:${first}::Second:${second}::LVL: ${lvl}::CTR: ${ctr}::NUM: ${num}"
      ###############################
      while ( $ctr[$lvl] <= $num[$lvl] )
        set first_item = ""
        set second_item = ""
        ###############################
        #echo "***First:${first}::Second:${second}::LVL: ${lvl}::CTR: ${ctr}::NUM: ${num}"
        ###############################
        set first_item = `csh scr "${first[$lvl]}" $ctr[$lvl]`
        set second_item = `csh scr "${second[$lvl]}" $ctr[$lvl]`
        ###############################
        #echo "First item: $first_item :: $lvl"
        #echo "Second item: $second_item :: $lvl"
        #echo "check3"
        ###############################
        if ( ( `echo "$first_item" | grep -o '^[0-9]\+$' ` ) && ( `echo "$second_item" | grep -o '^[0-9]\+$'`) ) then
          ###############################
          #echo "one"
          ###############################
          if ( "$first_item" < "$second_item" ) then
             ###############################
             #echo "Left side is smaller : Right order"
             ###############################
             set flag = 1
             break
          else if ( "$first_item" > "$second_item" ) then
             ###############################
             #echo "Right side is smaller : Wrong order"
             ###############################
             set flag = 0
             break
          else
             set flag = 0.5
          endif
        else if ( ( "$first_item" =~ \(* ) && ( "$second_item" =~ \(* ) ) then
          ###############################
          #echo "two"
          ###############################
          set first = ( $first "$first_item" )
          set second = ( $second "$second_item" )
          @ lvl = ( $lvl + 1 )
          goto process 
        else if ( ( "`echo "$first_item" | grep -o '^.' `" != "(" ) && ( "$second_item" =~ \(* )  && ( "$first_item" != "" ) ) then
          ###############################
          #echo "three"
          ###############################
          set first_item = "($first_item)"
          set first = ( $first "$first_item" )
          set second = ( $second "$second_item" )
          @ lvl = ( $lvl + 1 )
          goto process
        else if ( ( "`echo "$second_item" | grep -o '^.' `" != "(" ) && ( "$first_item" =~ \(* ) && ( "$second_item" != "" ) )  then
          ###############################
          #echo "four"
          ###############################
          set second_item = "($second_item)"
          set first = ( $first "$first_item" )
          set second = ( $second "$second_item" )
          @ lvl = ( $lvl + 1 )
          goto process
        else
          ###############################
          #echo "five"
          #echo "$first_item :: $second_item"
          ###############################
          if ( "$first_item" == "" && "$second_item" != "" ) then
             ###############################
             #echo "Left side ran out of items : Right order"
             ###############################
             set flag = 1
             break
          else if ( "$first_item" != "" && "$second_item" == "" ) then
             ###############################
             #echo "Right side ran out of items : Wront order" 
             ###############################
             set flag = 0
             break
           else 
             set flag = 0.5
           endif
        endif
        ###############################
        #echo "CTR : $ctr[$lvl] :: LVL: $lvl"
        ###############################
        set val = $ctr[$lvl]
        set ctr[$lvl] = `expr $val + 1` 
        ###############################
        #echo "CTR : $ctr :: LVL: $lvl :: NUM: $num"
        ###############################
      end
      if ( $flag == 0.5 ) then
        ###############################
        #echo "pointfive"
        ###############################
        @ lvl = ( $lvl - 1 )
        ###############################
        #echo "lvl: $lvl :: first: $first r $#first :: second: $second r $#second"
        ###############################
        set first = ( ${first[1-$lvl]} )
        set second = ( ${second[1-$lvl]} )
        ###############################
        #echo "check2"
        ###############################
        set num_first = ( $num_first[1-$lvl] )
        set num_second = ( $num_second[1-$lvl] )
        ###############################
        #echo "check"
        ###############################
        set val = $ctr[$lvl]
        set ctr[$lvl] = `expr $val + 1`
        set ctr = ( $ctr[1-$lvl] )
        set num = ( $num[1-$lvl] )
        ###############################
        #echo "num: $num :: ctr: $ctr"
        ###############################
        goto process
      endif
      if ( ! $flag ) then
        sed -i "$comparison_packet s/.*/$org_format_second/g" reference_file
        sed -i "$comp_packet s/.*/$org_format_first/g" reference_file
      endif
    #echo "************************"
    @ comparison_packet = ( $comparison_packet +  1 )
  end
  @ current_packet = ( $current_packet +  1 )
end
set divider_packet1 = `grep -n '^((2))$' reference_file | sed 's/:.*//g'`
set divider_packet2 = `grep -n '^((6))$' reference_file | sed 's/:.*//g'`
set decoder_key = `expr $divider_packet1 \* $divider_packet2`
echo $decoder_key
