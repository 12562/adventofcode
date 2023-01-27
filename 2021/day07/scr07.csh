
set file = $argv[1]
set max = 1000000000000000000000000

set i = 1
while ( 1 )
  set res = `cat $file  | sed 's/,/\n/g' | sed 's/$/ - '"$i"'/g' | bc | sed 's/-//g' | datamash sum 1`
  if ( `echo "$res < $max" | bc` ) then
     set max = $res
  else
     break
  endif 
  @ i = ( $i + 1 )
end
echo "Part 1 : $max"

set max = 1000000000000000000000000
set i = 1
while ( 1 )
  set res = `cat $file  | sed 's/,/\n/g' | sed 's/$/ - '"$i"'/g' | bc | sed 's/-//g' | sed 's/\(.*\)/(\1 * (\1 + 1)) \/ 2 /g' | bc | datamash sum 1`
  if ( `echo "$res < $max" | bc` ) then
     set max = $res
  else
     break
  endif 
  @ i = ( $i + 1 )
end
echo "Part 2 : $max"
