#! /usr/bin/tcsh

set file = "$1"
set debug = "$2"

set wd = `cat $file | sed 's/\(.\)/\1 /g' | awk 'END {print NF}'`
set engineSchematic = `cat $file | sed ':a; N; s/\n/A/g ; ta'`
set symbolIndexes = `echo "$engineSchematic" | sed 's/\(.\)/\1\n/g' | grep -v '^$\|A' | grep -n '.' | grep -v '\.\|:[0-9]' | awk -F ':' '{print $1}'`

if ( $debug ) then
   echo "$symbolIndexes"
   echo "*****************************************************************************************\n\n\n"
   echo "*****************************************************************************************\n\n\n"
   echo "*****************************************************************************************\n\n\n"
endif

set possiblePartNumbers = `echo "$engineSchematic" | sed 's/\([^A]\)/\1\n/g' | grep -n '.' | sed 's/.*:\(A\)\?\./_/g' | sed 's/\([0-9]\+:\)A\(.*\)/_\n\1\2/g' | sed 's/.*:[^0-9]/_/g' | sed ':a; N; s/\n/,/g; ta' | sed 's/\(,_\)\+/\n/g' | sed 's/^,//g'`

if ( $debug ) then
   echo "$possiblePartNumbers" | sed 's/ /\n/g'
endif

set possiblePartNumberPositions = ""
foreach idx ( $symbolIndexes )
  set possiblePartNumberPositions = "`expr $idx - $wd - 1`\|`expr $idx - $wd`\|`expr $idx - $wd + 1`\|`expr $idx - 1`\|`expr $idx + 1`\|`expr $idx + $wd - 1`\|`expr $idx + $wd`\|`expr $idx + $wd + 1`\|"$possiblePartNumberPositions
end

set possiblePartNumberPositions = `echo "$possiblePartNumberPositions" | sed 's/\|$//g'`
if ( $debug ) then
   echo "$possiblePartNumberPositions"

echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($possiblePartNumberPositions\):" 
echo "*****************************************************************************************\n\n\n"
echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($possiblePartNumberPositions\):" | sed 's/[0-9]\+://g'
echo "*****************************************************************************************\n\n\n"
echo "*****************************************************************************************\n\n\n"
endif

echo "Part 1: "`echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($possiblePartNumberPositions\):" | sed 's/[0-9]\+://g' | sed 's/,//g' | datamash sum 1`

set gearIndexes = `echo "$engineSchematic" | sed 's/\(.\)/\1\n/g' | grep -v '^$\|A' | grep -n '.' | grep  '\*' | awk -F ':' '{print $1}'`

if ( $debug ) then
   echo "$gearIndexes"
endif

set sum = 0
foreach idx ( $gearIndexes )
  set possiblePartNumberPositions = "`expr $idx - $wd - 1`\|`expr $idx - $wd`\|`expr $idx - $wd + 1`\|`expr $idx - 1`\|`expr $idx + 1`\|`expr $idx + $wd - 1`\|`expr $idx + $wd`\|`expr $idx + $wd + 1`"
  set partNums = `echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($possiblePartNumberPositions\):" | sort | uniq | sed 's/[0-9]\+://g' | sed 's/,//g'`
  if ( $#partNums == 2 ) then
     @ sum = $sum + `echo "$partNums" | sed 's/ / * /' | bc`
  endif 
  #set numParts = 0
  #set gearRatio = 1
  #set allIdx = ""
  #foreach pNPos ( $possiblePartNumberPositions )
  #  set pNIdx = `echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($pNPos\):" | awk -F ':' '{print $1}'`
  #  set pN = `echo "$possiblePartNumbers" | sed 's/ /\n/g' | grep -n "\(^\|,\)\($pNPos\):" | sed 's/[0-9]\+://g' | sed 's/,//g'`
  #  if ( $pN != "" ) then
  #     if ( $debug ) then
  #        echo "$pNPos : $pN"
  #        echo ${allIdx} | sed 's/ /\n/g' 
  #        echo ${allIdx} | sed 's/ /\n/g' | grep '^'"${pNIdx}"'$' 
  #     endif
  #     if ( `echo ${allIdx} | sed 's/ /\n/g' | grep '^'"${pNIdx}"'$' | wc -l` == 0 ) then
  #        set allIdx = "${allIdx} $pNIdx"
  #        set gearRatio = `echo "$gearRatio * $pN" | bc`
  #        set numParts = `expr $numParts + 1`
  #        if ( $debug ) then
  #           echo "pN: $pN"
  #           echo $gearRatio
  #        endif
  #     else
  #        continue
  #     endif 
  #  endif
  #  if ( $numParts == 2 ) then
  #     set sum = `expr $sum + $gearRatio`
  #     break
  #  endif
  #end
end

echo "Part 2: $sum"
