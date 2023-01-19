#! /usr/bin/csh

set x = `cat $argv[1] | grep forward | awk '{print $2}' | sed ':a;N;s/\n/ + /g; ba' | bc`
set y = `cat $argv[1] | grep "down\|up" | sed 's/down/ + /g' | sed 's/up/ - /g' | sed ':a;N;s/\n//g;ba' | sed 's/^ *\(+\|-\)//g' | bc`
echo "Part1: "`echo "$x * $y" | bc`
set x = 0
set y = 0
set aim = 0
foreach line (`cat $argv[1] | sed 's/ /_/g' `)
  set command = `echo $line | awk -F '_' '{print $1}'`
  set value = `echo $line | awk -F '_' '{print $2}'`
  switch ( $command )
    case "forward":
                    @ x = ( $x + $value )
                    set y = `echo "( $y + ($aim * $value ) )" | bc`
                    breaksw
    case "up":
                    @ aim = ( $aim - $value ) 
                    breaksw
    case "down":
                    @ aim = ( $aim + $value )
                    breaksw
  endsw
end
echo "Part2: "`echo "$x * $y" | bc`
