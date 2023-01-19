#! /usr/bin/csh

set file = $argv[1]
rm -f runtime_file runtime_file2
set random_draws = ( `head -n 1 $file | sed 's/,/ /g'` )
set num_boards = `grep '^$' $file | wc -l`
tail -n `expr 6 \* $num_boards` $file | sed  ':a; N;N;N;N;N; s/\([0-9]\)\n\([0-9 ]\)/\1 \2/g;N; s/\n \n//g; Ta;' | grep -v '^$' | sed 's/ \+/ /g' | sed 's/^ */:/g' | sed 's/ *$/:/g' | sed 's/ /:/g' > runtime_file
\cp -f runtime_file runtime_file2
foreach random_draw ( $random_draws )
  sed -i "s/:${random_draw}:/:_:/g" runtime_file
  #grep --color "\(^\(\(:[0-9_]\+\)\{5\}:\)\{0,4\}\(:_\)\{5\}:\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}:\)" runtime_file
  if ( `grep --color "\(^\(\(:[0-9_]\+\)\{5\}:\)\{0,4\}\(:_\)\{5\}:\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{4\}:_\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}\)" runtime_file | wc -l` ) then
     set num = $random_draw
     break
  endif
end

set num2 = `grep --color "\(^\(\(:[0-9_]\+\)\{5\}:\)\{0,4\}\(:_\)\{5\}:\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{4\}:_\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}\)" runtime_file | sed 's/:_//g' | sed 's/:/ + /g' | sed 's/^ \++//g' | sed 's/ \++ *$//g' | bc`
echo "Part 1: "`expr $num \* $num2`

foreach random_draw ( $random_draws )
  sed -i "s/:${random_draw}:/:_:/g" runtime_file2
  if ( `grep --color "\(^\(\(:[0-9_]\+:\)\{5\}\)\{0,4\}\(:_\)\{5\}:\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{4\}:_\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}\)" runtime_file2 | wc -l` ) then
     grep --color "\(^:\(\([0-9_]\+:\)\{5\}\)\{0,4\}\(_:\)\{5\}\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{4\}:_\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}\)" runtime_file2 | wc -l | xargs echo 
     set num = $random_draw
     set line_nums = ( `grep -n "\(^:\(\([0-9_]\+:\)\{5\}\)\{0,4\}\(_:\)\{5\}\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{4\}:_\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}\)" runtime_file2 | sed 's?^\([0-9]\+\):.*?\1?g' | sort | uniq` )
     echo $line_nums
     echo " Line nums: $#line_nums"
     @ num_boards = ( $num_boards - $#line_nums )
     if ( ( $num_boards == 2) ) then
        break
     endif
     set str = `echo $line_nums | sed 's/ /d;/g' | sed 's/$/d;/g'`  
     echo "str: $str"
     sed -i "$str" runtime_file2
     echo "Num boards: $num_boards :: Num lines: `wc -l runtime_file2`"
  endif
end
echo $num

grep --color "\(^:\(\([0-9_]\+:\)\{5\}\)\{0,4\}\(_:\)\{5\}\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{4\}:_\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}\)" runtime_file2
set num2 = `grep --color "\(^:\(\([0-9_]\+:\)\{5\}\)\{0,4\}\(_:\)\{5\}\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{4\}:_\)\|\(\(:_\(:[0-9_]\+\)\{4\}\)\{5\}\)" runtime_file2 | sed 's/:_//g' | sed 's/:/ + /g' | sed 's/^ \++//g' | sed 's/ \++ *$//g' | bc`
echo $num2
echo "Part 2: "`expr $num \* $num2`
