
set part = 1
set num_steps = 10
set file = $argv[1]

compute:
tail -n+3 $file | sort > reference_file
echo "`head -n1 $file | grep -oP '.(?=.)'`:`head -n1 $file | grep -oP '(?<=.).'`" | sed 's/:/\n/g' | datamash transpose -t ' ' | sed 's/ //g' | sort | uniq -c | sed 's/^[ \t]\+//g' > runfile
head -n1 $file  | grep -o '.' | uniq -c | sed 's/^[ \t]\+//g' | awk '{print $2" "$1}' > char_sum
set num = 1
while ( $num <= $num_steps )
  awk '{print $2}' runfile | paste -sd'|' | xargs -I {} grep -E "({}) " reference_file | sed 's/\([A-Z]\)\([A-Z]\) -> \([A-Z]\)/\3/g' > tmp3
  paste -d' ' tmp3 runfile | sed 's/\(\(.\) \([0-9]\+\)\).*/\1/g' | datamash -s -t' ' groupby 1 sum 2 > tmp4
  cat char_sum tmp4 | datamash -s -t' ' groupby 1 sum 2 > tmp5
  \cp -f tmp5 char_sum
  
  awk '{print $2}' runfile | paste -sd'|' | xargs -I {} grep -E "({}) " reference_file | sed 's/\([A-Z]\)\([A-Z]\) -> \([A-Z]\)/\1\3\2/g' > tmp
  paste -d' ' tmp runfile | sed 's/\(.\)\(.\)\(.\) \([0-9]\+\).*/\4 \1\2\n\4 \2\3/g' > tmp2
  cat tmp2 | datamash -s -t' ' groupby 2 sum 1 | awk '{print $2" "$1}' | sort -k 2 > runfile
  @ num = ( $num + 1 )
end

set max = `cat char_sum | sort -n -k 2 | tail -n1 | awk '{print $2}'`
set min = `cat char_sum | sort -n -k 2 | head -n1 | awk '{print $2}'`
echo "Part ${part}: "`echo "$max - $min" | bc`
rm -f reference_file runfile tmp3 tmp4 tmp5 tmp tmp2 char_sum
if ( $part == 1 ) then
   set num_steps = 40 part = 2
   goto compute
endif
