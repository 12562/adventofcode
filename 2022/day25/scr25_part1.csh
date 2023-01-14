#! /usr/bin/csh

set sum = 0
foreach num ( `cat $argv[1]` )
  set var = `echo $num | sed 's/ */ /g'`
  seq $#var | tac | sed 's/$/ - 1/g' | bc | sed 's/^/5 ^ /g' | bc > to_mult
  echo $num | sed 's/ */ /g' | sed 's/\-/\-1/g' | sed 's/\=/-2/g' | sed 's/ /\n/g' | grep -v '^$' > tmp_num
  set decimal_sum = `paste -d '*' to_mult tmp_num | sed ':a;N;s/\n/ + /g;ba' | bc`
  set sum = `echo "$sum + $decimal_sum" | bc `
  #echo $num | sed 's/ */\n/g' | grep -v '^$'
end
echo $sum
set num = $sum
set snafu = ""
set flag = 0
set ctr = 1
set modnum = `echo $num | sed 's/-//g'`
set power = `echo "l($modnum) / l(5)" | bc -l | sed 's/\..*//g'` 
while ( ($num != 0) || ($power != -1))
   set modnum = `echo $num | sed 's/-//g'`
   set startnum = $num
   echo "Num: $num"
   echo "MOdnum: $modnum"
   if ( $power == "" ) then
      set power = 0
   endif
   if ( ! $flag ) then
      set power = `echo $power | sed 's/$/ + 1/g' | bc `
   endif
   echo "check: $power"
   set poweroffive = `echo "5 ^ $power" | bc`
   echo "check"
   if ( `echo "$num > 0" | bc` ) then
      set diff = `echo "$poweroffive - $num" | bc`
      set moddif = `echo $diff | sed 's/-//g'`
      set diff2 = `echo "2 * $poweroffive  - $num" | bc`
      set moddif2 = `echo $diff2 | sed 's/-//g'`
      echo "diff: $diff :: diff2 $diff2"
      if ( (`echo "$moddif2 < $modnum" | bc`) && (`echo "$moddif2 < $moddif" | bc`)  ) then
         echo "check3"
         set snafu = "${snafu}2"
         set num = `echo "$num - 2 * $poweroffive" | bc`
         set flag = 1
      else if ( (`echo "$moddif < $modnum" | bc`) && (`echo "$moddif >= 0" | bc`) ) then
         echo "check4"
         set snafu = "${snafu}1"
         set num = `echo "$num - $poweroffive" | bc`
         set flag = 1
      else
         set flag = 1
         echo "check2"
      endif
   else if ( `echo "$num < 0" | bc` ) then
      echo "Less than"
      set diff = `echo "-$poweroffive - $num" | bc`
      set moddif = `echo $diff | sed 's/-//g'`
      set diff2 = `echo "-2 * $poweroffive - $num" | bc`
      set moddif2 = `echo $diff2 | sed 's/-//g'`
      echo "diff: $diff :: diff2 $diff2"
      if ( (`echo "$moddif2 < $modnum" | bc`) && (`echo "$moddif2 < $moddif" | bc`)  ) then
         set snafu = "${snafu}="
         set num = `echo "$num + 2 * $poweroffive" | bc`
         set flag = 1
         echo "check5"
      else if ( (`echo "$moddif < $modnum" | bc`) && (`echo "$moddif >= 0" | bc`) ) then
         set snafu = "${snafu}-"
         set num = `echo "$num + $poweroffive" | bc`
         set flag = 1
         echo "check6"
      else
         set flag = 1
         echo "check8"
      endif
   endif
endif
   if ( ($num == $startnum)  ) then
      set snafu = "${snafu}0"
   endif
   echo "NUM: $num"
   @ ctr = ( $ctr + 1 )
   @ power = ( $power - 1 )
end
echo $snafu | sed 's/^0\+//g'
