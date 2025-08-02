set first = `cat $1 | awk '{print $1}' | sort`
set secnd = `cat $1 | awk '{print $2}' | sort  | sed 's/^/-/g'`

echo -n "Part 1: "
echo "$first\n$secnd" | datamash -t " " transpose | bc -l | sed 's/-//g' | datamash sum 1 | sed 's/-//g'

set b1 = `cat $1 | awk '{print $1}' | sort | uniq -c | sed 's/\([0-9]\+\) *\([0-9]\+\)/\1*\2/g' | bc -l`
set b2 = `cat $1 | awk '{print $1}' | sort | uniq -c | sed 's/\([0-9]\+\) *\([0-9]\+\)/\2/g' `
set a = `cat $1 | awk '{print $2}' | sort | uniq -c | sed 's/^[ \t]*//g'`
set b = `echo "$b1\n$b2" | datamash -t " " transpose`
echo -n "Part 2: "
echo $b $a | sed 's/\([0-9]\+ [0-9]\+\) /\1\n/g' | sort -k 2 | awk '\!count[$2]++ {save[$2] = $1; next} count[$2] == 2 {print $1 * save[$2]; delete save[$2] }' | datamash sum 1
