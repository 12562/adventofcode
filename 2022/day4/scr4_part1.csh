set count = 0
set _line_ = 1
foreach line (`cat input4.txt`)
  set flag = 0
  set first_pair_lower = `echo $line | sed "s/-.*//g"`
  set first_pair_higher = `echo $line | awk -F ',' '{print $1}' | awk -F '-' '{print $2}'`
  set second_pair_lower = `echo $line | sed "s/.*,//g" | sed "s/-.*//g"`
  set second_pair_higher = `echo $line | sed "s/.*-//g"`
  if ( $first_pair_lower >= $second_pair_lower && $first_pair_higher <= $second_pair_higher ) then
      set flag = 1
      echo "$line : First in second : $_line_"
  endif
  if ( $second_pair_lower >= $first_pair_lower && $second_pair_higher <= $first_pair_higher ) then
      set flag = 1
      echo "$line : Second in first : $_line_"
  endif
  if ( $flag ) then
      @ count = ( $count + 1 )
  endif
  @ _line_ = ( $_line_ + 1 )
end
echo $count
