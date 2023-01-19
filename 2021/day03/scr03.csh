#! /usr/bin/csh

set cols = "1-`awk -F '' 'END{print NF}' $argv[1]`"
set ones = `cat $argv[1] | sed 's/ */ /g' | sed 's/^ *\| *$//g' | datamash -t ' ' sum $cols`
set zeros = `cat $argv[1] | sed 's/ */ /g' | sed 's/^ *\| *$//g' | sed 's/0/-1/g' | sed 's/1/0/g' | sed 's/-0/-1/g' | datamash -t ' ' sum $cols | sed 's/-//g'`

/usr/bin/echo -e "${ones}\n${zeros}" | datamash -t " " transpose 
set gamma =  `/usr/bin/echo -e "${ones}\n${zeros}" | datamash -t " " transpose | tac | sed 's/ / > /g' | sed 's/^/(/g' | sed 's/$/)/g'  | awk '{print $0="2 ^ "NR-1" * "$0}'  | bc | datamash sum 1` 
set epsilon = `/usr/bin/echo -e "${ones}\n${zeros}" | datamash -t " " transpose | tac | sed 's/ / < /g' | sed 's/^/(/g' | sed 's/$/)/g'  | awk '{print $0="2 ^ "NR-1" * "$0}'  | bc | datamash sum 1`
echo "Part1 : "`expr $gamma \* $epsilon`

set ogr = ( `cat $argv[1]` )
set num = 1
while ( `echo "( $num <= $cols ) || ( $#ogr > 1 )" | bc` )
  set ones = `echo $ogr | sed 's/ /\n/g' |  sed 's/ */ /g' | sed 's/^ *\| *$//g' | datamash -t " " sum $num`
  set zeros = `echo $ogr | sed 's/ /\n/g' | sed 's/ */ /g' | sed 's/^ *\| *$//g' | sed 's/0/-1/g' | sed 's/1/0/g' | sed 's/-0/-1/g' | datamash -t " " sum $num | sed 's/-//g'`
  set most_common = `echo "$ones >= $zeros" | bc`
  set ogr = ( `echo $ogr | sed 's/ /\n/g' | awk -F '' -v var=$most_common -v col=$num '$col==var {print $0}'`)
  @ num = ( $num + 1 )
end

set ogr =  `/usr/bin/echo "$ogr" | sed 's/ */\n/g' | grep -v '^$' | tac | awk '{print $0="2 ^ "NR-1" * "$0}'  | bc | datamash sum 1` 
echo $ogr


set csr = ( `cat $argv[1]` )
set num = 1

while ( `echo "( $num <= $cols ) || ( $#csr > 1 )" | bc` )
  set ones = `echo $csr | sed 's/ /\n/g' |  sed 's/ */ /g' | sed 's/^ *\| *$//g' | datamash -t " " sum $num`
  set zeros = `echo $csr | sed 's/ /\n/g' | sed 's/ */ /g' | sed 's/^ *\| *$//g' | sed 's/0/-1/g' | sed 's/1/0/g' | sed 's/-0/-1/g' | datamash -t " " sum $num | sed 's/-//g'`
  set least_common = `echo "$ones < $zeros" | bc`
  set csr = ( `echo $csr | sed 's/ /\n/g' | awk -F '' -v var=$least_common -v col=$num '$col==var {print $0}'`)
  @ num = ( $num + 1 )
end
set csr =  `/usr/bin/echo "$csr" | sed 's/ */\n/g' | grep -v '^$' | tac | awk '{print $0="2 ^ "NR-1" * "$0}'  | bc | datamash sum 1` 
echo "Part 2: "`echo "$ogr * $csr" | bc`
