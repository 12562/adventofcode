
set gearIndexes = `echo "$engineSchematic" | sed 's/\(.\)/\1\n/g' | grep -v '^$\|A' | grep -n '.' | grep  '\*' | awk -F ':' '{print $1}'`

if ( $debug ) then
   echo "$gearIndexes"
endif

set sum = 0
foreach idx ( $gearIndexes )
  set possiblePartNumberPositions = ( `expr $idx - $wd - 1` `expr $idx - $wd` `expr $idx - $wd + 1` `expr $idx - 1` `expr $idx + 1` `expr $idx + $wd - 1` `expr $idx + $wd` `expr $idx + $wd + 1` )
  set numParts = 0
  set gearRatio = 1
  set allIdx = ""
  foreach pNPos ( $possiblePartNumberPositions )
    set pNIdx = `echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($pNPos\):" | awk -F ':' '{print $1}'`
    set pN = `echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($pNPos\):" | sed 's/[0-9]\+://g' | sed 's/,//g'`
    if ( $pN != "" ) then
       if ( $debug ) then
          echo "$pNPos : $pN"
          echo ${allIdx} | sed 's/ /\n/g' 
          echo ${allIdx} | sed 's/ /\n/g' | grep '^'"${pNIdx}"'$' 
       endif
       if ( `echo ${allIdx} | sed 's/ /\n/g' | grep '^'"${pNIdx}"'$' | wc -l` == 0 ) then
          set allIdx = "${allIdx} $pNIdx"
          set gearRatio = `echo "$gearRatio * $pN" | bc`
          set numParts = `expr $numParts + 1`
          if ( $debug ) then
             echo "pN: $pN"
             echo $gearRatio
          endif
       else
          continue
       endif 
    endif
    if ( $numParts == 2 ) then
       set sum = `expr $sum + $gearRatio`
       break
    endif
  end
end

echo "Part 2: $sum"
