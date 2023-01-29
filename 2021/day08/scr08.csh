#! /usr/bin/csh

set file = $argv[1]

echo "Part 1 : "`cat $file | awk -F '|' '{print $2}' | sed 's/ /\n/g' | grep -v '^ *$' | sed 's/./1 + /g' | sed 's/ *+ *$//g' | bc | grep "2\|4\|3\|7" | wc -l`

set sum = 0
set ctr = 1
set num_lines = `cat $file | wc -l`
foreach line (`cat $file | sed 's/ /_/g'`)
while ( $ctr <= $num_lines )
   set line = `sed "$ctr q;d" $file`
   set notes = (`echo $line | awk -F '|' '{print $1}'`)
   set values = (`echo $line | awk -F '|' '{print $2}'`)
   set indexes = ( 0 0 0 0 0 0 0 0 0 0 )
   set indexes[1] = `echo $notes | sed 's/ /\n/g' | awk '{print length}' | grep -n 2 | sed 's/:.*//g'`
   set indexes[4] = `echo $notes | sed 's/ /\n/g' | awk '{print length}' | grep -n 4 | sed 's/:.*//g'`
   set indexes[7] = `echo $notes | sed 's/ /\n/g' | awk '{print length}' | grep -n 3 | sed 's/:.*//g'`
   set indexes[8] = `echo $notes | sed 's/ /\n/g' | awk '{print length}' | grep -n 7 | sed 's/:.*//g'`
   set zero_six_nine_index = `echo $notes | sed 's/ /\n/g' | awk '{print length}' | grep -n 6 | sed 's/:.*//g'`
   set two_three_five_index = `echo $notes | sed 's/ /\n/g' | awk '{print length}' | grep -n  5 | sed 's/:.*//g'`
   set one_chars = `echo $notes[$indexes[1]] | sed 's/\(.\)\(.\)/\1 \2/g'`
   set four_chars = $notes[$indexes[4]]
   set seven_chars = $notes[$indexes[7]]
   foreach ind ( $two_three_five_index )
      if ( `echo $notes[$ind] | grep "$one_chars[1]" | grep "$one_chars[2]" | wc -l` ) then
         set indexes[3] = $ind
      endif
   end
   set two_five = (`echo $two_three_five_index | sed 's/ /\n/g' | grep -v "^$indexes[3]"'$'`)
   if ( `echo "$notes[$two_five[1]]$four_chars" | sed 's/\(.\)/\1\n/g' | sort | uniq -d | wc -l` == 3 ) then
      set indexes[5] = $two_five[1]
      set indexes[2] = $two_five[2]
   else
      set indexes[2] = $two_five[1]
      set indexes[5] = $two_five[2]
   endif
   foreach ind ( $zero_six_nine_index )
      if ( `echo "$notes[$ind]$four_chars" | sed 's/\(.\)/\1\n/g' | sort | uniq -d  | wc -l` == 4 ) then
         set indexes[9] = $ind
      endif
   end
   set zero_six = (`echo $zero_six_nine_index | sed 's/ /\n/g' | grep -v "^$indexes[9]"'$'`)
   if ( `echo "$notes[$zero_six[1]]$seven_chars" | sed 's/\(.\)/\1\n/g' | sort | uniq -d | wc -l` == 3 ) then
       set indexes[10] = $zero_six[1]
       set indexes[6] = $zero_six[2]
   else
       set indexes[10] = $zero_six[2]
       set indexes[6] = $zero_six[1]
   endif
   set new_notes = ()
   foreach note ( $notes )
     set new_note = ( `echo $note | sed 's/\(.\)/\1\n/g' | grep -v '^$' | sort` )
     set new_note = `echo $new_note | sed 's/ //g'`
     set new_notes = ( $new_notes $new_note )
   end
   set add_value = ()
   foreach value ( $values )
     set new_value = ( `echo $value | sed 's/\(.\)/\1\n/g' | grep -v '^$' | sort` )
     set new_value = `echo $new_value | sed 's/ //g'`
     set index = `echo $new_notes | sed 's/ /\n/g' | grep -n "^$new_value"'$' | sed 's/:.*//g'`
     set actual_value = `echo $indexes | sed 's/ /\n/g' | grep -n "^$index"'$' | sed 's/:.*//g'`
     if ( $actual_value == 10 ) then
        set actual_value = 0
     endif
     set add_value = ( $add_value $actual_value )
   end
   @ sum = ( $sum + `echo $add_value | sed 's/ //g'` )
   @ ctr = ( $ctr + 1 )
end
echo "Part2 : $sum"
