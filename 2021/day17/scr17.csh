#! /usr/bin/csh

rm -f possible_vels
set file = $argv[1]
set T_area = `cat $file | grep -o "[0-9-]\+" `
set x = (`echo $T_area[1-2] | sed 's/ /\n/g' | sort -n | xargs seq` )
set y = (`echo $T_area[3-4] | sed 's/ /\n/g' | sort -n | xargs seq | sed 's/-//g'` )
set all_steps = () flag = 0
foreach var ( $x "delim" $y )
  if ( $var == "delim" ) then
     set x_steps = ( $all_steps ) all_steps = () flag = 1
     continue
  else 
    set i = 1
    set steps = ( ${var}_1 )
    while ( `echo "($i * ($i+1)) / 2" | bc` < $var )
      if ( ! `echo "($var - (($i)*($i+1)/2)) % ($i+1)" | bc` ) then
         set tmp = `echo "($var - (($i)*($i+1)/2)) / ($i+1)" | bc`
         if ( $tmp == 1 && $flag ) then
            set steps = ( $steps 0_`expr $i + 2` 1_`expr $i + 1` ) 
         else if ( $flag ) then
            set steps = ( $steps ${tmp}_`expr $i + 1` ) 
         else
            set steps = ( $steps `expr ${tmp} + $i`_`expr $i + 1` )
         endif
      endif
      @ i += 1
    end
    set all_steps = ( $all_steps $steps )
  endif
end
set y_steps = ( $all_steps ) 

set all_vels = ()
foreach x ( $x_steps )
  set xstep = `echo $x | awk -F '_' '{print $2}' | sed 's/.*_//g'`
  set xvel = `echo $x | awk -F '_' '{print $1}' | sed 's/_.*//g'`
  foreach y ( $y_steps )
     set yvel = `echo $y | awk -F '_' '{print $1}' | sed 's/_.*//g'`
     set ystep = `echo $y | awk -F '_' '{print $2}' | sed 's/.*_//g'`
     set diff = `echo "( $xstep - $ystep) " | bc` 
     set y_final_vel = `echo "$yvel + $ystep - 1" | bc`
     if ( $xstep == $ystep && ( `seq $yvel $y_final_vel | paste -sd"+" | bc` <= `echo $T_area[3] | sed 's/-//g'`) ) then
        if ( $yvel == 0 ) then
          echo "${xvel},${yvel}"  >> possible_vels
        else
          echo "${xvel},-${yvel}"  >> possible_vels
        endif
     else if ( `echo "$diff % 2" | bc` && ($xstep > 3) && ($xstep > $ystep) && ($yvel < `echo $T_area[3] | sed 's/-//g'` ) && (`echo "($diff / 2) + 1" | bc` == $yvel) ) then
        echo ${xvel},`expr $diff / 2`  >> possible_vels
     else if ( ($xvel == $xstep) && ($xstep > 3) && ($yvel > 1 ) && ( `seq $yvel $y_final_vel | paste -sd"+" | bc` <= `echo $T_area[3] | sed 's/-//g'`) ) then
        echo ${xvel},`expr ${yvel} - 1` >> possible_vels
     endif
  end
end
echo "Part 1: "`echo "($T_area[3] + 1) * ($T_area[3]) / 2" | bc`
echo "Part 2: "`cat possible_vels | sort  | uniq | wc -l`
rm -f possible_vels
