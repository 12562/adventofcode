#! /usr/bin/csh

set file = $argv[1]

rm -f points slope c input_data points2
cat $file | sed 's/ -> /#/g' | awk -F ',|#' '{print "( "$4" - "$2") / ("$3" - "$1" )"}'  | bc |& awk '{print $NF}' > slope
cat $file | sed 's/ -> /#/g' > input_data 
paste -d ' ' slope input_data  | sed 's/^0 \(.*,\)\(.*\)/\2/g' | sed 's/^zero\(.*#\)\(.*\),.*/\2/g' | awk -F ' |,|#' '/^(1|-1) / {print $3" - ("$1" * "$2")"}; NF==1 {print $0}'  | bc > c
set eqns = `paste -d ' ' slope c input_data | sed 's/^0 \([-0-9]*\).*/y=(\1)/g' | sed 's/^zero \([-0-9]*\).*/x=(\1)/g' | sed 's/^\(1\|-1\) \([-0-9]*\).*/y=(\1*x)+(\2)/g'`
##set sign = `echo $input_data | awk -F '#|,' '{print $1" "$3}' | sed 's/ / < /g' | bc | sed 's/0/-/g' | sed 's/1/+/g'`

set num = 1
while ( $num <= $#eqns ) 
   if ( "$eqns[$num]" =~ x* )  then
      set min_max = `sed "$num q;d" input_data | awk -F '#|,'  '{print $2"\n"$4}' | sort -n`
      #echo "vertical : $eqns[$num] : $min_max : $eqns[$num]"
      seq $min_max[1] $min_max[2]  | sed "s/\(.*\)/\1 $eqns[$num]/g" | sed 's/\([^ ]*\) x=(\([0-9]*\))/\2,\1/g' >> points
   else if ( "$eqns[$num]" =~ *+* ) then
      set min_max = `sed "$num q;d" input_data | awk -F '#|,'  '{print $1"\n"$3}' | sort -n`
      set y = `seq $min_max[1] $min_max[2]  | sed "s/\(.*\)/\1 $eqns[$num]/g" | sed 's/\([^ ]*\) y=\(.*\)x\(.*\)/\2\1\3/g' | bc`
      set x = `seq $min_max[1] $min_max[2]`
      echo "${x}:${y}" | sed 's/:/\n/g' | datamash -t ' ' transpose | sed 's/ /,/g' >> points2
      #echo "slant"
   else if ( "$eqns[$num]" =~ y* ) then
      set min_max = `sed "$num q;d" input_data | awk -F '#|,'  '{print $1"\n"$3}' | sort -n`
      #echo "horizontal : $eqns[$num]"
      seq $min_max[1] $min_max[2]  | sed "s/\(.*\)/\1 $eqns[$num]/g" | sed 's/\([^ ]*\) y=(\([0-9]*\))/\1,\2/g' >> points
   else
      exit
   endif
   @ num = ( $num + 1 )
end


echo "Part 1: `cat points | sort | uniq -d | wc -l`"
echo "Part 2: `cat points points2 | sort | uniq -d | wc -l`"
