#! /usr/bin/csh

set cycle = 0
set X = 1
set arr = ()
set pos = 0
#foreach line ( `cat $argv[1] | sed 's/ /_/g' | head -n 1`) 
foreach line ( `cat $argv[1] | sed 's/ /_/g' `) 

   if ( `echo $line | grep  "noop" | wc -l ` > 0 ) then
      @ cycle = ( $cycle + 1 )
        #echo "pos: $pos :: X: $X"
        set Xminusone = `expr $X - 1`
        set Xplusone = `expr $X + 1`
      if ( ($pos == $Xminusone) || ($pos == $X) || ($pos == $Xplusone) ) then
         set arr = ( $arr "#" )
      else
         set arr = ( $arr . )
      endif
      @ pos = ( $pos + 1 )
      if ( $cycle == 40 || $cycle == 80 || $cycle == 120 || $cycle == 160 || $cycle == 200 || $cycle == 240 ) then
        echo $arr
        set arr = () 
        set pos = 0
      endif
   endif

   if ( `echo $line | grep  "addx" | wc -l ` > 0 ) then
      set ctr = 1
      while ( $ctr <= 2 )
        @ cycle = ( $cycle + 1 )
        #echo "pos: $pos :: X: $X"
        set Xminusone = `expr $X - 1`
        set Xplusone = `expr $X + 1`
        if ( ($pos == $Xminusone) || ($pos == $X) || ($pos == $Xplusone) ) then
           set arr = ( $arr "#" )
        else
           set arr = ( $arr . )
        endif
        @ pos = ( $pos + 1 )
        if ( $cycle == 40 || $cycle == 80 || $cycle == 120 || $cycle == 160 || $cycle == 200 || $cycle == 240 ) then
            echo $arr
            set arr = ()
            set pos = 0
        endif
        @ ctr = ( $ctr + 1 )
      end
      @ X = ( $X + `echo $line | awk -F '_' '{print $2}'` )
   endif
end
