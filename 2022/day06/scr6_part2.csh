#! /usr/bin/csh

set a = (`cat input6.txt | sed 's/ */ /g'`)
set num = 1
while ( $num <= $#a ) 
  @ end_num = ( $num + 13 )
  if ( `echo "$a[$num-$end_num]" | sed 's/ /\n/g' | sort | uniq | wc -l` == 14 ) then
     echo $end_num
     exit
  endif
  @ num = ( $num + 1 )
end
