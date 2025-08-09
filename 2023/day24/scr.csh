#!/usr/bin/tcsh

set file = $1
set debug = $2

set num_hailstones = `wc -l $file | awk '{print $1}'`
if ( $file == "test_input.txt" ) then
 set testAreaMinX = 7
 set testAreaMinY = 7
 set testAreaMaxX = 27
 set testAreaMaxY = 27
else
 set testAreaMinX = 200000000000000
 set testAreaMinY = 200000000000000
 set testAreaMaxX = 400000000000000
 set testAreaMaxY = 400000000000000
endif

echo "hailStoneX hailstoneC hailstoneY hailStoneM XFutureSymbol YFutureSymbol" > firstHailstone
cat $file | tail -n `expr $num_hailstones - 1` | grep -n '.' | awk -F ':' '{print "seq "$1" | xargs -I {} echo \""$2"\""}' | tcsh | awk '{gsub(/,/,"",$0); if($5 > 0){xChange = "gteq"} else {xChange = "lteq"}; if($6 > 0){yChange = "gteq"} else {yChange = "lteq"}; print $1" "$2 - (($6 / $5) * $1)" "$2" "($6 / $5)" "xChange" "yChange;} ' >> firstHailstone
echo "hailStoneX hailstoneC hailstoneY hailStoneM XFutureSymbol YFutureSymbol" > secondHailstone
seq `expr $num_hailstones - 1` | sed 's/^/cat '$file' \| head -n/g' | tcsh | awk '{gsub(/,/,"",$0); if($5 > 0){xChange = "gteq"} else {xChange = "lteq"}; if($6 > 0){yChange = "gteq"} else {yChange = "lteq"}; print $1" "$2 - (($6 / $5) * $1)" "$2" "($6 / $5)" "xChange" "yChange;} ' >> secondHailstone

echo -n "Part 1: "
paste firstHailstone secondHailstone | tail -n `echo "((($num_hailstones - 1) * ($num_hailstones)) / 2)" | bc` | sed 's/[ \t]\+/ /g' | awk -v xMin=$testAreaMinX -v xMax=$testAreaMaxX -v yMin=$testAreaMinY -v yMax=$testAreaMaxY '{ \
            if ($4 != $10) { \
               x = (-($2 - $8)/($4 - $10)); \
               if ( $5 == "gteq" ) { \
                  futureXFirstHailstone = (x >= $1) \
               } else { \
                  futureXFirstHailstone = (x <= $1) \
               } \
               if ( $11 == "gteq" ) { \
                  futureXSecndHailstone = (x >= $7) \
               } else { \
                  futureXSecndHailstone = (x <= $7) \
               } \
               if ( (x >= xMin) && (x<=xMax) && (futureXFirstHailstone) && (futureXSecndHailstone)) { \
                  y = ($4 * x) + $2; \
                  if ( $6 == "gteq" ) { \
                     futureYFirstHailstone = (y >= $3) \
                  } else { \
                     futureYFirstHailstone = (y <= $3) \
                  } \
                  if ( $12 == "gteq" ) { \
                     futureYSecndHailstone = (y >= $9) \
                  } else { \
                     futureYSecndHailstone = (y <= $9) \
                  } \
                  if ((y >= yMin) && (y<=yMax) && (futureYFirstHailstone) && (futureYSecndHailstone)) { \
                     print 1 \
                  } else { \
                     print 0 \
                  } \
               } else { \
                  print 0 \
               } \
            } else { \
               print 0 \
            } \
         }' | datamash sum 1


set eqns = `cat $file | sed 's/ \+//g' | sed 's/\([,@]\)\([0-9]\+\)/\1\+\2/g' | sed 's/+\([0-9]\+,\)+\([0-9]\+@\)/\1\2/g' | sed 's/-/_/g' | sed 's/+/-/g' | sed 's/_/+/g' | head -n3 | sed 's/@/,/g' | awk -F ',' '{print "("$1"-a)/(A"$4")\n("$2"-b)/(B"$5")\n("$3"-c)/(C"$6")"}'`
echo "a, b, c, A, B, C := xcas.new_vars();" > solve_equation.giac
echo "eq1 := $eqns[1] = $eqns[3];" >> solve_equation.giac
echo "eq2 := $eqns[2] = $eqns[3];" >> solve_equation.giac
echo "eq3 := $eqns[4] = $eqns[6];" >> solve_equation.giac
echo "eq4 := $eqns[5] = $eqns[6];" >> solve_equation.giac
echo "eq5 := $eqns[7] = $eqns[9];" >> solve_equation.giac
echo "eq6 := $eqns[8] = $eqns[9];" >> solve_equation.giac
echo "L := solve([eq1, eq2, eq3, eq4, eq5, eq6], [a,b,c,A,B,C]);" >> solve_equation.giac
echo "print("\""Solution:"\"", L[0][0]+L[0][1]+L[0][2])" >> solve_equation.giac

giac <solve_equation.giac >& output.log

#cat output.log | grep "Solution:," | awk -F ',' '{print $2}'
echo "Part 2: "`cat output.log | grep list | sed 's/list\[\[//g' | sed 's/]]//g' | sed 's/\],\[/\n/g' | awk -F ',' '{if ((int($4) == $4) && (int($5) == $5) && (int($6) == $6)) {print $1+$2+$3}}'`
rm -f solve_equation.giac output.log firstHailstone secondHailstone
