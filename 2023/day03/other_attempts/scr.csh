#! /bin/tcsh

set wd = `cat "$1" | awk -F "" "END {print NF}"`
set ht = `cat "$1" | wc -l`

set wd_plus_one = `echo "$wd + 1" | bc -l`
set nums = `cat "$1" | grep -o '\([[:digit:]]\+\)'`
set num_repeat = `echo $nums | sed 's/[0-9]\+/1/g'`
echo $num_repeat
echo "Numbers are: $nums"

set sum = 0
set index = 1
while ( $index <= $#nums )
   set c_num = $nums[$index]
   set num_digits = `echo $c_num | awk -F '' 'END {print NF}'`
   echo "Num digits: $num_digits"
   set neighbor_positions = (  `echo "${num_digits} - ${wd}" | bc -l` `echo "-1 - ${wd}" | bc -l` -1 1 `echo "${wd} - 1 - ${num_digits} + 1" | bc -l` `echo "${wd} + ${num_digits} - ${num_digits} + 1" | bc -l`  )
   set ctr = 0
   while ( $ctr < $num_digits )
         set neighbor_positions = ( $neighbor_positions `echo "-${wd} + $ctr" | bc -l` `echo "${wd} + $ctr - $num_digits + 1" | bc -l` )
         @ ctr = ( $ctr + 1 )
   end
   echo $neighbor_positions
   set c_num_neighbor_line = "`cat $1 | tr '\n' ' ' | sed 's/ //g' | grep -o '\(\(.\)\{'$wd'\}[^0-9]\)\?\('$c_num'\)\([^0-9]\(.\)\{'$wd'\}\)\?' | sed 's/ /\n/g'  | head -n $num_repeat[$index] | tail -n 1`"
   echo "$c_num_neighbor_line"
   echo $c_num
   foreach neighbor_pos ( $neighbor_positions )
     set pos = $neighbor_pos
     if ( $neighbor_pos < 0 ) then
        set neighbor_pos = `echo -1 \* $neighbor_pos | bc -l `
        if ( `echo "$c_num_neighbor_line" | sed "s/$c_num/A/g" | sed 's/ */\n/g' | grep -v '^$' | grep -B $neighbor_pos A | wc -l`  > 1 ) then
           set char = `echo "$c_num_neighbor_line" | sed "s/$c_num/A/g" | sed 's/ */\n/g' | grep -v '^$' | grep -B $neighbor_pos A | head -n 1 `
        else
           echo "$pos :: $c_num"
           continue
        endif
     else
        if ( `echo "$c_num_neighbor_line" | sed "s/$c_num/A/g" | sed 's/ */\n/g' | grep -v '^$' | grep -A $neighbor_pos A | wc -l` > 1 ) then
           set char = `echo "$c_num_neighbor_line" | sed 's/'$c_num'/A/g' | sed 's/ */\n/g' | grep -v '^$' | grep -A $neighbor_pos A | tail -n 1 `
        else
           echo "$neighbor_pos :: $c_num"
           continue
        endif
     endif
     echo "$pos :: $c_num :: $char"
     
     #echo "$c_num_neighbor_line"
     #echo "$char"
     if ( ("$char" != ".")  && (`echo "$char" | grep -o "[[:punct:]]" | wc -l` > 0) ) then
        echo "************************************* $c_num *********************************************"
        @ sum = ( $sum + $c_num )
        break
     endif
   end
   @ num_repeat[$index] = $num_repeat[$index] + 1
   @ index = ( $index + 1 )
   echo $nums | grep -o $c_num
end
echo $sum
