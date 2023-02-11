#! /usr/bin/csh

set file = $argv[1]
echo "Part 1: "`cat $file | sort -n | awk '{print $1"\n"2020 - $1}' | sort | uniq -d | sed 'N;s/\n/ \* /g' | bc`

set lst = `cat $file | sort -n | awk '{print 2020 - $1}'`
foreach num ( $lst )
  set mynum = `expr 2020 - $num`
  set other_two = ( `cat $file | sort -n | awk '{print $1"\n"'$num' - $1}' | sort | uniq -d`  )
  if ( $#other_two == 2 ) then
     break
  endif
end
echo "Part 2: "`echo "$mynum $other_two"  | sed 's/ / \* /g' | bc`
