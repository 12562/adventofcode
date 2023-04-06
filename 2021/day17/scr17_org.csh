#! /usr/bin/csh

rm -f res3
set file = $argv[1]
set T_area = `cat $file | grep -o "[0-9-]\+" `
set x = (`echo $T_area[1-2] | sed 's/ /\n/g' | sort -n | xargs seq` )
set y = (`echo $T_area[3-4] | sed 's/ /\n/g' | sort -n | xargs seq | sed 's/-//g'` )
#`echo $T_area[1-2] | sed 's/ /\n/g' | sort -n | tail -n1`
#set y = `echo $T_area[3-4] | sed 's/ /\n/g' | sort -n | head -n1 | sed 's/-//g'`
echo $x $y
set all_steps = ()
set flag = 0
foreach var ( $x "check" $y )
  if ( $var == "check" ) then
     set x_steps = ( $all_steps )
     echo $all_steps | sed 's/ /\n/g' | awk -F '_' '{print $2"_"$1}' | sort  -n | awk -F '_' '{print $2"_"$1}' | paste -sd" "
     #echo $all_steps | sed 's/ /\n/g' | sed 's/_.*//g' | sort -n | uniq -c
     set all_steps = ()
     set flag = 1
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
    #echo $steps | sed 's/ /\n/g' |  awk -F '_' '{print "seq "$1" "$1+$2" | paste -sd_"}' | csh
    #echo " "
  endif
end
echo " "
set y_steps = ( $all_steps ) 
echo $all_steps | sed 's/ /\n/g' | awk -F '_' '{print $2"_"$1}' | sort  -n | awk -F '_' '{print $2"_"$1}' | paste -sd" "
#echo $all_steps | sed 's/ /\n/g' | sed 's/_.*//g' | sort -n | uniq -c
set all_vels = ()
foreach x ( $x_steps )
  set xstep = `echo $x | awk -F '_' '{print $2}' | sed 's/.*_//g'`
  set xvel = `echo $x | awk -F '_' '{print $1}' | sed 's/_.*//g'`
  foreach y ( $y_steps )
     set yvel = `echo $y | awk -F '_' '{print $1}' | sed 's/_.*//g'`
     set ystep = `echo $y | awk -F '_' '{print $2}' | sed 's/.*_//g'`
     set diff = `echo "( $xstep - $ystep) " | bc` 
     set y_final_vel = `echo "$yvel + $ystep - 1" | bc`
     if ( $yvel == "" || $ystep == "" || $diff == "" || $y_final_vel == "" ) then
        echo "$yvel $ystep $diff $y_final_vel"
        exit
     endif
     if ( $xstep == $ystep && ( `seq $yvel $y_final_vel | paste -sd"+" | bc` <= `echo $T_area[3] | sed 's/-//g'`) ) then
        if ( $yvel == 0 ) then
         if ( $xvel == 24 || $xvel == 25 || $xvel == 26 ) then
        echo "check1:: $xstep $xvel $ystep $yvel"
        endif
          echo "${xvel},${yvel}"  >> res3
        else
         if ( $xvel == 24 || $xvel == 25 || $xvel == 26 ) then
        echo "check2:: $xstep $xvel $ystep $yvel"
        endif
          echo "${xvel},-${yvel}"  >> res3
        endif
     else if ( `echo "$diff % 2" | bc` && ($xstep > 3) && ($xstep > $ystep) && ($yvel < `echo $T_area[3] | sed 's/-//g'` ) && (`echo "($diff / 2) + 1" | bc` == $yvel) ) then
         if ( $xvel == 24 || $xvel == 25 || $xvel == 26 ) then
        echo "check3:: $xstep $xvel $ystep $yvel"
endif
        echo ${xvel},`expr $diff / 2`  >> res3
     else if ( ($xvel == $xstep) && ($xstep > 3) && ($yvel > 1 ) && ( `seq $yvel $y_final_vel | paste -sd"+" | bc` <= `echo $T_area[3] | sed 's/-//g'`) ) then
         if ( $xvel == 24 || $xvel == 25 || $xvel == 26 ) then
        echo "check4:: $xstep $xvel $ystep $yvel"
         endif
        echo ${xvel},`expr ${yvel} - 1` >> res3
     endif
  end
end
cat res3 | sort  | uniq | wc -l
#echo $all_vels | sed 's/ /\n/g' | sort | uniq | sort -t ',' -k 2,2n > res3 
