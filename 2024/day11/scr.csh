#! /usr/bin/tcsh

set max = 5
set ctr = 0

set arr = `cat $1`
echo $arr
while ( $ctr < $max ) 
      set new_nums = ()
      echo $ctr
      foreach num ( $arr )
         echo "NUm: $num"
         if ( $num == 0 ) then
            set new_nums = ( $new_nums 1 ) 
         else if ( (`echo $num | sed 's/ */\n/g' | grep -v '^$' | wc -l` % 2)  == 0 ) then
            set half_num_digits = `echo $num | sed 's/ */\n/g' | grep -v '^$' | wc -l | sed 's/$/ \/ 2 /g' | bc `
            #echo "NUm half digits: $half_num_digits"
            set new_nums = ( $new_nums `echo $num | sed 's/\([0-9]\{'${half_num_digits}'\}\)\(.*\)/\1 \2/g' | sed 's/\(^0\+\| 0\+\)\([^0 ]\)/ \2/g' | sed 's/^0\+ \| 0\+ \| 0\+$/ 0 /g' ` )
         else
            set new_nums = ( $new_nums `echo "$num * 2024" | bc -l ` )
         endif
      end
      set arr = ( $new_nums )
      #echo $arr
      @ ctr = ( $ctr + 1 )
end

echo "Final:$arr"
