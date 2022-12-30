#! /usr/bin/csh

set cycle = 0
set X = 1
set strength = 0
foreach line ( `cat $argv[1] | sed 's/ /_/g'` ) 

   if ( `echo $line | grep  "noop" | wc -l ` > 0 ) then
      @ cycle = ( $cycle + 1 )
      if ( $cycle == 20 || $cycle == 60 || $cycle == 100 || $cycle == 140 || $cycle == 180 || $cycle == 220 ) then
         @ strength = ( $strength + ($X * $cycle) )
      endif
   endif

   if ( `echo $line | grep  "addx" | wc -l ` > 0 ) then
      set ctr = 1
      while ( $ctr <= 2 )
        @ cycle = ( $cycle + 1 )
        if ( $cycle == 20 || $cycle == 60 || $cycle == 100 || $cycle == 140 || $cycle == 180 || $cycle == 220 ) then
           @ strength = ( $strength + ($X * $cycle) )
        endif
        @ ctr = ( $ctr + 1 )
      end
      @ X = ( $X + `echo $line | awk -F '_' '{print $2}'` )
   endif
end
echo $strength
