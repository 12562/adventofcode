#! /usr/bin/tcsh

alias dbg 'if ($debug) printf "%s" "\!*"'

set file = $1
set debug = $2

set res = 50
set cnt = 0
set cnt2 = 0
set rotations = `sed 's/L/- /g; s/R/+ /g; s/ //g' $file`
foreach rotation ( $rotations )
  switch ($rotation)
      case +*:
          set sign = +
          set isNeg = 0
          set plainNum = $rotation:q:s/+//
      breaksw

      case -*:
          set sign = -
          set isNeg = 1
          set plainNum = $rotation:q:s/-//
      breaksw

      default:
          echo "Invalid rotation: $rotation"
          exit 1
  endsw

  set prevRes = $res

  @ res = $res $sign $plainNum
  dbg "${sign}${plainNum} :: $res :: "

  if ( $plainNum >= 100 ) then
     @ div = $plainNum / 100
     @ cnt2 = $cnt2 + $div
     if ( $isNeg ) then
        @ res = $res + (($div + 1) * 100)
        @ modNum = $plainNum % 100
        @ modPrevRes = $prevRes % 100
        dbg " ::check4:: mPR: $modPrevRes :: mN: $modNum :: "
        if (($modPrevRes > 0) && ($modPrevRes < $modNum)) then
           @ cnt2 = $cnt2 + 1
           dbg " ::check6:: "
        endif
     else
        dbg " ::check3:: "
     endif
  endif 
  
  if ( $res < 0 ) then
     @ res = $res + 100
     dbg " ::check5:: "
     if ( ($prevRes != 0) ) then
        @ cnt2 = $cnt2 + 1
        dbg " ::check:: "
     endif
  else if ( $res == 100 ) then
     set res = 0
  else if ( $res > 100 ) then
     @ res = $res % 100
     @ modNum = $plainNum % 100
     @ modPrevRes = $prevRes % 100
     @ tmpSum = $modNum + $modPrevRes
     if ( $tmpSum > 100 && (${isNeg} == 0) ) then
        @ cnt2 = $cnt2 + 1
        dbg " ::check7:: "
     endif
     dbg " ::check2:: "
  endif

 
  if ( $res == 0 ) then
     @ cnt = ( $cnt + 1 )
  endif
  dbg " New res: $res :: cnt: $cnt :: cnt2: $cnt2"
end
echo "Part 1: $cnt"
@ total = $cnt + $cnt2
echo "Part 2: $total"
