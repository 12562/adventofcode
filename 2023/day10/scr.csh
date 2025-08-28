#! /usr/bin/tcsh

set file = "$1"
set debug = $2

set wd = `cat $file | sed 's/ */ /g' | awk 'END {print NF}'`
set ht = `cat $file | wc -l`

set symbols = (`cat $file | sed 's/./& /g' | tr -s ' ' '\n' | grep -v '^$'`)
set symbolsType = ( $symbols )

#set elems = ( -${wd} ${wd} "|" "F" "7" "|" "J" "L" -1 1 "-" "L" "F" "-" "J" "7" 1 ${wd} "-" "J" "7" "|" "J" "L" -1 -${wd} "-" "F" "L" "|" "7" "F" -1 ${wd} "-" "L" "F" "|" "L" "J" -${wd} 1 "|" "7" "F" "-" "J" "7" )
set esss = ( -1 -${wd} 1 ${wd} )

#set frst = `cat $file | sed 's/ */\n/g'  | grep -v '^$' | grep -n S | awk -F ':' '{print $1}'`
set frst = `echo $symbols | sed 's/ /\n/g'  | grep -v '^$' | grep -n S | awk -F ':' '{print $1}'`
set symbolsType[$frst] = 0 # Loop Element

if ( $debug ) then
   echo "$wd $ht"
   echo "First: $frst"
endif

set ctr = 1
set left = 1
set top = 2
set right = 3
set bottom = 4

set stack = ()
while ( $ctr <= $#esss )
  #set pos = `expr ${frst} + $esss[$ctr]`
  @ pos = ${frst} + $esss[$ctr]

  if ( ($pos >= 1) && ($pos <= $#symbols) ) then
     #set symbl = `cat $file | sed 's/ */\n/g' | grep -v '^$' | head -n $pos | tail -n 1`
     set symbl = $symbols[$pos]

     if ( $debug ) then
        echo "$ctr :: $pos :: $symbl"
     endif

     if ( ($ctr == $left) && ("$symbl" == "-" || "$symbl" == "F" || "$symbl" == "L") ) then
        set stack = ( $stack ${pos}:${frst}:1 )
        set facing = "E"
     else if ( ($ctr == $top) && ("$symbl" == "|" || "$symbl" == "F" || "$symbl" == 7)) then
        set stack = ( $stack ${pos}:${frst}:1 )
        set facing = "N"
     else if ( ($ctr == $right) && ("$symbl" == "-" || "$symbl" == "J" || "$symbl" == 7)) then
        set stack = ( $stack ${pos}:${frst}:1 )
        set facing = "W"
     else if ( ($ctr == $bottom) && ("$symbl" == "|" || "$symbl" == "J" || "$symbl" == "L")) then
        set stack = ( $stack ${pos}:${frst}:1 )
        set facing = "S"
     endif
     
     if ( $debug ) then
        echo $stack
     endif
  endif

  @ ctr = ( $ctr + 1 )
end

if ( $debug ) then
   echo "$#stack : $stack"
endif

while ( $#stack )
  #set stackEntry = ( `echo ${stack[1]} | sed 's/:/ /g` )
  set stackEntry = ( ${stack[1]:gas/:/ /} )
  set curr = $stackEntry[1]
  set prev = $stackEntry[2]
  set cntr = $stackEntry[3]
  #set curr = `echo $stack[1] | awk -F ':' '{print $1}'`
  #set prev = `echo $stack[1] | awk -F ':' '{print $2}'`
  #set cntr = `echo $stack[1] | awk -F ':' '{print $3}'`
  #set stack = `echo $stack[2-]`
  set stack = ( $stack[2-] )

  set symbolsType[$curr] = 0 # Loop Element => 0
  if ( $debug ) then
     echo "*************************"
     echo "Set $curr to be loop element"
     #echo $symbolsType
  endif

  if ( $curr > $prev ) then
     if ( $curr - $prev == 1 ) then
        set facing = "W"
     else
        set facing = "S"
     endif
  else
     if ( $prev - $curr == 1 ) then
        set facing = "E"
     else
        set facing = "N"
     endif
  endif

  #set currSymbol = `cat $file | sed 's/ */\n/g' | grep -v '^$' | head -n $curr | tail -n 1`
  set currSymbol = $symbols[$curr]
  #set prevSymbol = `cat $file | sed 's/ */\n/g' | grep -v '^$' | head -n $prev | tail -n 1`
  set prevSymbol = $symbols[$prev]

  if ( $debug ) then
     echo "Current: $curr, Previous: $prev, Stack: $stack $#stack"
     echo "Current: $curr, Previous: $prev, Current Symbol: $currSymbol"
  endif

  set next = ""
  if ( "$currSymbol" == "|" ) then
     #set currElemSet = `echo $elems[1-8]`
     set currElemSet = ( -${wd} ${wd} "|" "F" "7" "|" "J" "L" -1 1 )
  else if ( "$currSymbol" == "-" ) then
     #set currElemSet = `echo $elems[9-16]`
     set currElemSet = ( -1 1 "-" "L" "F" "-" "J" "7" -${wd} ${wd} )
  else if ( "$currSymbol" == "F" ) then
     #set currElemSet = `echo $elems[17-24]`
     set currElemSet = ( 1 ${wd} "-" "J" "7" "|" "J" "L" -1 -${wd} )
  else if ( "$currSymbol" == "J" ) then
     #set currElemSet = `echo $elems[25-32]`
     set currElemSet = ( -1 -${wd} "-" "F" "L" "|" "7" "F" 1 ${wd} )
  else if ( "$currSymbol" == "7" ) then
     #set currElemSet = `echo $elems[33-40]`
     set currElemSet = ( -1 ${wd} "-" "L" "F" "|" "L" "J" 1 -${wd} )
  else if ( "$currSymbol" == "L" ) then
     #set currElemSet = `echo $elems[41-48]` 
     set currElemSet = ( -${wd} 1 "|" "7" "F" "-" "J" "7" ${wd} -1 )
  endif

  #set firstNeigh = `expr $curr + $currElemSet[1]`
  @ firstNeigh = $curr + $currElemSet[1]
  if ( $firstNeigh >= 1 ) then
     #set fNS = `cat $file | sed 's/ */\n/g' | grep -v '^$' | head -n $firstNeigh | tail -n 1`
     set fNS = $symbols[$firstNeigh]

     if ( $debug ) then
        echo "fNS: $fNS"
     endif

     if ( ($firstNeigh != $prev) && ("$fNS" == "$currElemSet[3]" || "$fNS" == "$currElemSet[4]" || "$fNS" == "$currElemSet[5]") ) then
        set next = ( $next $firstNeigh )
     endif
  endif
  #set secndNeigh = `expr $curr + $currElemSet[2]`
  @ secndNeigh = $curr + $currElemSet[2]
  #if ( $secndNeigh <= `expr $wd \* $ht` ) then
  if ( $secndNeigh <= $#symbols ) then
     #set sNS = `cat $file | sed 's/ */\n/g' | grep -v '^$' | head -n $secndNeigh | tail -n 1`
     set sNS = $symbols[$secndNeigh]

     if ( $debug ) then
        echo "sNS: $sNS"
     endif

     if ( ($secndNeigh != $prev) && ("$sNS" == "$currElemSet[6]" || "$sNS" == "$currElemSet[7]" || "$sNS" == "$currElemSet[8]") ) then
        set next = ( $next $secndNeigh )
     endif
  endif

  @ thirdNeigh = $curr + $currElemSet[9]
  @ forthNeigh = $curr + $currElemSet[10]

  set thirdNotLE = -1
  set forthNotLE = -1
  if ( ($thirdNeigh >= 1) && ( $thirdNeigh <= $#symbols ) ) then
     @ thirdNotLE = "$symbolsType[$thirdNeigh]" != 0
  endif
  if ( ($forthNeigh >= 1) && ( $forthNeigh <= $#symbols ) ) then
     @ forthNotLE = "$symbolsType[$forthNeigh]" != 0
  endif

  @ currSymblNotSvn = ( $currSymbol != 7 ) 
  @ currSymblNotEff = ( $currSymbol != "F" )
  @ currSymblNotEll = ( $currSymbol != "L" )
  @ currSymblNotJay = ( $currSymbol != "J" )

  if ( $debug ) then
     echo "CHECK1 $currSymblNotSvn $currSymblNotEff $currSymblNotEll $currSymblNotJay"
     echo "CHECK2 ${thirdNeigh}:$thirdNotLE ${forthNeigh}:$forthNotLE"
  endif

  if ( $facing == "N" ) then
     if ( ($thirdNeigh >= 1) && ( $thirdNeigh <= $#symbols ) ) then
        @ symbolsType[$thirdNeigh] = ( (-($currSymblNotSvn) & -($thirdNotLE) & (-1)) | (!($currSymblNotSvn) & $thirdNotLE & 1) )
     endif
     if ( ($forthNeigh >= 1) && ( $forthNeigh <= $#symbols ) ) then
        @ symbolsType[$forthNeigh] = ( (-(!($currSymblNotEff)) & -($forthNotLE) & (-1)) | ($currSymblNotEff & $forthNotLE & 1) )
     endif
  else if ( $facing == "E" ) then
     if ( ($thirdNeigh >= 1) && ( $thirdNeigh <= $#symbols ) ) then
        @ symbolsType[$thirdNeigh] = ( (-(!($currSymblNotEll)) & -($thirdNotLE) & (-1)) | ($currSymblNotEll & $thirdNotLE & 1) )
     endif
     if ( ($forthNeigh >= 1) && ( $forthNeigh <= $#symbols ) ) then
        @ symbolsType[$forthNeigh] = ( (-($currSymblNotEff) & -($forthNotLE) & (-1)) | (!($currSymblNotEff) & $forthNotLE & 1) )
     endif
  else if ( $facing == "S" ) then
     if ( ($thirdNeigh >= 1) && ( $thirdNeigh <= $#symbols ) ) then
        @ symbolsType[$thirdNeigh] = ( (-(!($currSymblNotJay)) & -($thirdNotLE) & (-1)) | ($currSymblNotJay & $thirdNotLE & 1) )
     endif
     if ( ($forthNeigh >= 1) && ( $forthNeigh <= $#symbols ) ) then
        @ symbolsType[$forthNeigh] = ( (-($currSymblNotEll) & -($forthNotLE) & (-1)) | (!($currSymblNotEll) & $forthNotLE & 1) )
     endif
  else
     if ( ($thirdNeigh >= 1) && ( $thirdNeigh <= $#symbols ) ) then
        @ symbolsType[$thirdNeigh] = ( ((-$currSymblNotJay) & (-$thirdNotLE) & (-1)) | (!($currSymblNotJay) & $thirdNotLE & 1) )
     endif
     if ( ($forthNeigh >= 1) && ( $forthNeigh <= $#symbols ) ) then
        @ symbolsType[$forthNeigh] = ( (-(!($currSymblNotSvn)) & (-$forthNotLE) & (-1)) | ($currSymblNotSvn & $forthNotLE & 1) )
     endif
  endif

  if ( $debug ) then
     echo "firstNeigh:$firstNeigh secndNeigh:$secndNeigh"
     if ( ($thirdNeigh >= 1) && ( $thirdNeigh <= $#symbols ) ) then
        echo "thirdNeighSymblType:$symbolsType[$thirdNeigh]"
     endif
     if ( ($forthNeigh >= 1) && ( $forthNeigh <= $#symbols ) ) then
        echo "forthNeighSymblType: $symbolsType[$forthNeigh]"
     endif
     echo "Next: $next"
  endif

  if ( ("$fNS" == "S" || "$sNS" == "S") && ($cntr != 1) ) then
     echo -n "Part 1: "
     echo "($cntr + 1) / 2" | bc
     break
  else if ( !($cntr % 1000) && $debug ) then
     echo $cntr
  endif

  if ( ("$next" != "") && ("$next" != $prev) ) then
     @ newcntr = $cntr + 1
     #set stack = ( `echo "$next" | sed 's/ /\n/g' | grep -v '^'"$prev"'$'`:${curr}:`expr $cntr + 1` $stack )
     set stack = ( "${next}:${curr}:${newcntr}" $stack )
  endif
  
  if ( $debug ) then
     echo ">> Stack: $stack :: $#stack"
     echo "*************************"
  endif
end

set queue = ( `echo $symbolsType | sed 's/ /\n/g' | grep -n '^1' |  awk -F ':' '{print $1}'` )

while ( $#queue )
  set current = $queue[1]
  set queue = ( $queue[2-] )
  @ neigh1 = ( $current + $wd )
  @ neigh2 = ( $current - $wd )
  @ neigh3 = ( $current + 1   )
  @ neigh4 = ( $current - 1   )

  set neighsToAdd = ()

  if ( $debug ) then
     echo "Check2: $neigh1 $neigh2 $neigh3 $neigh4"
  endif

  if ( ($neigh1 >= 1) && ($neigh1 <= $#symbols)) then
     if ( "$symbolsType[$neigh1]" != 0 ) then
        if ( $symbolsType[$neigh1] != 1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh1 )
        endif
        @ symbolsType[$neigh1] = 1
     endif
  endif
  if ( ($neigh2 >= 1) && ($neigh2 <= $#symbols)) then
     if ( "$symbolsType[$neigh2]" != 0 ) then
        if ( "$symbolsType[$neigh2]" != 1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh2 )
        endif
        @ symbolsType[$neigh2] = 1
     endif
  endif
  if ( ($neigh3 >= 1) && ($neigh3 <= $#symbols)) then
     if ( "$symbolsType[$neigh3]" != 0 ) then
        if ( "$symbolsType[$neigh3]" != 1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh3 )
        endif
        @ symbolsType[$neigh3] = 1
     endif
  endif
  if ( ($neigh4 >= 1) && ($neigh4 <= $#symbols)) then
     if ( "$symbolsType[$neigh4]" != 0 ) then
        if ( "$symbolsType[$neigh4]" != 1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh4 )
        endif
        @ symbolsType[$neigh4] = 1
     endif
  endif

  set queue = ( $queue $neighsToAdd )
end

set queue = ( `echo $symbolsType | sed 's/ /\n/g' | grep -n '^-1' |  awk -F ':' '{print $1}'` )

while ( $#queue )
  set current = $queue[1]
  set queue = ( $queue[2-] )
  @ neigh1 = ( $current + $wd )
  @ neigh2 = ( $current - $wd )
  @ neigh3 = ( $current + 1   )
  @ neigh4 = ( $current - 1   )

  if ( $debug ) then
     echo "Check2: $neigh1 $neigh2 $neigh3 $neigh4"
  endif

  set neighsToAdd = ()
  if ( ($neigh1 >= 1) && ($neigh1 <= $#symbols) ) then
     if ( "$symbolsType[$neigh1]" != 0 ) then
        if ( "$symbolsType[$neigh1]" != -1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh1 )
        endif
        @ symbolsType[$neigh1] = -1
     endif
  endif
  if ( ($neigh2 >= 1) && ($neigh2 <= $#symbols)) then
     if ( "$symbolsType[$neigh2]" != 0 ) then
        if ( "$symbolsType[$neigh2]" != -1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh2 )
        endif
        @ symbolsType[$neigh2] = -1
     endif
  endif
  if ( ($neigh3 >= 1) && ($neigh3 <= $#symbols)) then
     if ( "$symbolsType[$neigh3]" != 0 ) then
        if ( "$symbolsType[$neigh3]" != -1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh3 )
        endif
        @ symbolsType[$neigh3] = -1
     endif
  endif
  if ( ($neigh4 >= 1) && ($neigh4 <= $#symbols)) then
     if ( "$symbolsType[$neigh4]" != 0 ) then
        if ( "$symbolsType[$neigh4]" != -1 ) then
           set neighsToAdd = ( $neighsToAdd $neigh4 )
        endif
        @ symbolsType[$neigh4] = -1
     endif
  endif

  set queue = ( $queue $neighsToAdd )
end

if ( $debug ) then
   echo $symbolsType | sed 's/-1/2/g' | sed 's/ //g' | sed "s/\(.\{${wd}\}\)/\1\n/g"
endif

echo -n "Part 2: "
if ( $symbolsType[$#symbolsType] == -1 ) then 
   echo $symbolsType | sed 's/ /\n/g' | grep -c '^1'
else
   echo $symbolsType | sed 's/ /\n/g' | grep -c '^-1' 
endif
