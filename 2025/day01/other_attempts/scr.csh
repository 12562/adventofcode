#! /usr/bin/tcsh

set file = $1
set debug = $2

set res = 50
set cnt = 0
set cnt2 = 0
foreach num ( `cat $file | sed 's/L/- /g' | sed 's/R/ + /g'  | sed 's/ //g'` )
  set prevRes = $res
  set res = `echo "$res $num" | bc -l`
  if ( $debug ) then
     echo -n "$num :: $res :: "
  endif

  if ( `echo "$num" | sed 's/+//g'` <= -100 ) then
     set div = `echo "($num * -1) / 100" | bc`
     set res = `echo "$res + (($div + 1) * 100)" | bc`
     set cnt2 = `echo "$cnt2 + $div" | bc`
     set modNum = `echo " -($num) - ((-($num) / 100) * 100)" | bc`
     set modPrevRes = `echo "$prevRes - (($prevRes / 100) * 100)" | bc`
     if ( $debug ) then
        echo -n " ::check4:: "
        echo -n " :: mPR: $modPrevRes :: mN: $modNum :: "
     endif
     if (($modPrevRes > 0) && ($modPrevRes < $modNum)) then
        set cnt2 = `echo "$cnt2 + 1" | bc`
        if ( $debug ) then
           echo -n " ::check6:: "
        endif
     endif
  else if ( `echo "$num" | sed 's/+//g'` >= 100 ) then
     if ( $debug ) then
        echo -n " ::check3:: "
     endif
     set div = `echo "($num / 100)" | sed 's/+//g' | bc`
     set cnt2 = `echo "$cnt2 + $div" | bc`
  endif 
  
  if ( $res < 0 ) then
     set res = `echo "$res + 100" | bc`
     if ( $debug ) then
        echo -n " ::check5:: "
     endif
     if ( ($prevRes != 0) ) then
        set cnt2 = `echo "$cnt2 + 1" | bc`
        if ( $debug ) then
           echo -n " ::check:: "
        endif
     endif
  else if ( $res == 100 ) then
     set res = 0
  else if ( $res > 100 ) then
     set div = `echo "($res / 100)" | bc`
     set res = `echo "$res - ($div * 100)" | bc`
     set num = `echo $num | sed 's/+//g'`
     set modNum = `echo "$num - (($num / 100) * 100)" | bc`
     set modPrevRes = `echo "$prevRes - (($prevRes / 100) * 100)" | bc`
     if ( `echo "$modNum + $modPrevRes" | bc` > 100 ) then
        set cnt2 = `echo "$cnt2 + 1" | bc`
        echo -n " ::check7:: "
     endif
     if ( $debug ) then
        echo -n " ::check2:: "
     endif
  endif

  if ( $debug ) then
     echo -n " New res: $res :: "
  endif 
 
  if ( $res == 0 ) then
     @ cnt = ( $cnt + 1 )
  endif
  if ( $debug ) then
     echo "cnt: $cnt :: cnt2: $cnt2"
  endif
end
echo $cnt
echo "$cnt + $cnt2" | bc
