#! /usr/bin/csh

rm -f max_geode cases file final_result
set file = $argv[1]
set result = 0

foreach line ( `cat $file |  sed 's/ /_/g'` )
  set id = `echo $line | awk -F '_' '{print $2}' | sed 's/://g'`
  set ore_robot_ore_cost = `echo $line | awk -F '_' '{print $7}'`
  set clay_robot_ore_cost = `echo $line | awk -F '_' '{print $13}'`
  set obsidian_robot_ore_cost = `echo $line | awk -F '_' '{print $19}'`
  set obsidian_robot_clay_cost = `echo $line | awk -F '_' '{print $22}'`
  set geode_robot_ore_cost = `echo $line | awk -F '_' '{print $28}'`
  set geode_robot_obsidian_cost = `echo $line | awk -F '_' '{print $31}'` 
  echo "$id :: $ore_robot_ore_cost $clay_robot_ore_cost $obsidian_robot_ore_cost $obsidian_robot_clay_cost $geode_robot_ore_cost $geode_robot_obsidian_cost"
  set num_ore_robots = 1
  set num_ore = 0
  set num_clay_robots = 0
  set num_clay = 0
  set num_obsidian_robots = 0
  set num_obsidian = 0
  set num_geode_robots = 0
  set num_geode = 0
  set time_used = 1
  set current_choice = ()
  set add_ore_robot = 0
  set max_geode = 0
  set cases = ( ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}_${current_choice} )
  set possible_choices = ()
start:
    while ( $#cases )
      set case = $cases[1]
      echo "CASE: $case"
      set time_used = `echo "$case" | awk -F '_' '{print $9}'`
      if ( "$time_used" == "" ) then
         set time_used = `echo "$case" | awk -F '_' '{print $9}'`
      endif
      echo "TU: $time_used"
      set time_left = `echo "25 - $time_used" | bc`
      echo "TL : $time_left"
      set tmp_time_left = `expr $time_left - 1`
      echo "TTL: $tmp_time_left"
      set sum = `expr  $time_left \* $tmp_time_left`
      set sum = `expr $sum / 2`
      echo "check : $sum"
      set num_geode = `echo $case | awk -F '_' '{print $7}'`
      set num_geode_robots = `echo $case | awk -F '_' '{print $8}'`
      set max_possible_geodes = `expr $num_geode +  ${time_left} \* $num_geode_robots  + $sum`
      echo "check2"
      set num_obsidian = `echo $case | awk -F '_' '{print $5}'`
      set num_obsidian_robots = `echo $case | awk -F '_' '{print $6}'`
      set max_possible_obsidian = `expr $num_obsidian +  ${time_left} \* $num_obsidian_robots  + $sum`
      echo "Cases: $cases"
      echo "Time Used: $time_used"
      if ( ($time_used <= 24) && ( $max_possible_geodes > $max_geode )  && ( $max_possible_obsidian >= $geode_robot_obsidian_cost ) ) then
         set num_ore = `echo $case | awk -F '_' '{print $1}'`
         set num_ore_robots = `echo $case | awk -F '_' '{print $2}'`
         set num_clay = `echo $case | awk -F '_' '{print $3}'`
         set num_clay_robots = `echo $case | awk -F '_' '{print $4}'`
         set current_choice = ( `echo $case | awk -F '_' '{print $10}'` )
         set current_case = ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}
         echo "Current case: $current_case"
         if ( ! $#current_choice ) then
            echo "check1"
            set cases = `echo $cases[2-]`
            if ( $num_ore_robots && (! $num_clay_robots) &&  (! $num_obsidian_robots) ) then
            echo "check2"
               if ( $num_ore_robots < `expr $ore_robot_ore_cost + $clay_robot_ore_cost + $obsidian_robot_ore_cost + $geode_robot_ore_cost` ) then
                  set possible_choices = ( $possible_choices "ore" )
               endif
               if ( $num_clay_robots < $obsidian_robot_clay_cost ) then
                  set possible_choices = ( $possible_choices "clay" )
               endif
            else if ( $num_ore_robots && $num_clay_robots &&  (! $num_obsidian_robots) ) then
            echo "check3"
               if ( $num_ore_robots < `expr $ore_robot_ore_cost + $clay_robot_ore_cost + $obsidian_robot_ore_cost + $geode_robot_ore_cost` ) then
                  set possible_choices = ( $possible_choices "ore" )
               endif
               if ( $num_clay_robots < $obsidian_robot_clay_cost ) then
                  set possible_choices = ( $possible_choices "clay" )
               endif
               if ( $num_obsidian_robots < $geode_robot_obsidian_cost ) then
                  set possible_choices = ( $possible_choices "obsidian" )
               endif
            else if ( ($num_ore_robots && $num_clay_robots && $num_obsidian_robots) ) then
            echo "check4"
               if ( $num_ore_robots < `expr $ore_robot_ore_cost + $clay_robot_ore_cost + $obsidian_robot_ore_cost + $geode_robot_ore_cost` ) then
                  set possible_choices = ( $possible_choices "ore" )
               endif
               if ( $num_clay_robots < $obsidian_robot_clay_cost ) then
                  set possible_choices = ( $possible_choices "clay" )
               endif
               if ( $num_obsidian_robots < $geode_robot_obsidian_cost ) then
                  set possible_choices = ( $possible_choices "obsidian" )
               endif
               set possible_choices = ( $possible_choices "geode" )
            endif
         else
            set possible_choices = ()
         endif
         echo "check"
         while ( $time_used <= 24 )
           set time_left = `echo "25 - $time_used" | bc`
           if ( $#possible_choices ) then
              set current_case = ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}
           #   if (( $num_ore < $ore_robot_ore_cost) && ($num_ore < $clay_robot_ore_cost) ) then   
              foreach choice ( $possible_choices )
                set cases = ( ${current_case}_${choice} $cases ) 
              end
              goto start 
           endif
           if ( ! $#current_choice ) then
              set cases[1] = ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}_$current_choice
              goto start
           endif
           if ( $current_choice == "geode" ) then
              if (( $num_obsidian >= $geode_robot_obsidian_cost ) && ($num_ore >= $geode_robot_ore_cost)) then
                 set add_geode_robot = 1
                 @ num_obsidian = ( $num_obsidian - $geode_robot_obsidian_cost )
                 @ num_ore = ( $num_ore - $geode_robot_ore_cost )
              else
                 set time_for_obsidian = `echo " ( $geode_robot_obsidian_cost - $num_obsdian ) / $num_obsidian_robots" | bc `
                 set time_for_ore = `echo " ( $geode_robot_ore_cost - $num_ore ) / $num_ore_robots" | bc`
                 if ( ($time_for_obsidian > $time_left) || ( $time_for_ore > $time_left ) ) then
                    break 
                 endif
                 set add_geode_robot = 0
              endif
           else if ( $current_choice == "obsidian" ) then
              if (( $num_clay >= $obsidian_robot_clay_cost ) && ($num_ore >= $obsidian_robot_ore_cost)) then
                 set add_obsidian_robot = 1
                 @ num_clay = ( $num_clay - $obsidian_robot_clay_cost )
                 @ num_ore = ( $num_ore - $obsidian_robot_ore_cost )
              else
                 set time_for_clay = `echo " ( $obsidian_robot_clay_cost - $num_clay ) / $num_clay_robots" | bc `
                 set time_for_ore = `echo " ( $obsidian_robot_ore_cost - $num_ore ) / $num_ore_robots" | bc`
                 if ( ($time_for_clay > $time_left) || ( $time_for_ore > $time_left ) ) then
                    break 
                 endif
                 set add_obsidian_robot = 0
              endif
           else if ( $current_choice == "clay" ) then
              if (($num_ore >= $clay_robot_ore_cost)) then
                 set add_clay_robot = 1
                 @ num_ore = ( $num_ore - $clay_robot_ore_cost )
              else
                 set time_for_ore = `echo " ( $clay_robot_ore_cost - $num_ore ) / $num_ore_robots" | bc`
                 if (  $time_for_ore > $time_left  ) then
                    break 
                 endif
                 set add_clay_robot = 0
              endif
              set add_obsidian_robot = 0
              set add_ore_robot = 0
              set add_geode_robot = 0
           else if ( $current_choice == "ore" ) then
              if (($num_ore >= $ore_robot_ore_cost)) then
                 set add_ore_robot = 1
                 @ num_ore = ( $num_ore - $ore_robot_ore_cost )
              else
                 set time_for_ore = `echo " ( $ore_robot_ore_cost - $num_ore ) / $num_ore_robots" | bc`
                 if (  $time_for_ore > $time_left  ) then
                    break 
                 endif
                 set add_ore_robot = 0
              endif
              set add_obsidian_robot = 0
              set add_clay_robot = 0
              set add_geode_robot = 0
           endif
              
           @ num_ore = ( $num_ore + $num_ore_robots ) 
           @ num_clay = ( $num_clay + $num_clay_robots )
           @ num_obsidian = ( $num_obsidian + $num_obsidian_robots )
           @ num_geode = ( $num_geode + $num_geode_robots )
           if ( $add_ore_robot ) then
              @ num_ore_robots = ( $num_ore_robots + 1 )
              set add_ore_robot = 0
              set current_choice = ()
           endif
           if ( $add_clay_robot ) then
              @ num_clay_robots = ( $num_clay_robots + 1 )
              set add_clay_robot = 0
              set current_choice = ()
           endif
           if ( $add_obsidian_robot ) then
              @ num_obsidian_robots = ( $num_obsidian_robots + 1 )
              set add_obsidian_robot = 0
              set current_choice = ()
           endif
           if ( $add_geode_robot ) then
              @ num_geode_robots = ( $num_geode_robots + 1 )
              set add_geode_robot = 0
              set current_choice = ()
           endif
           echo "$time_used :: ORE: $num_ore R$num_ore_robots :: CLAY : $num_clay R$num_clay_robots :: OBSIDIAN : $num_obsidian R$num_obsidian_robots :: GEODE : $num_geode R$num_geode_robots"
           @ time_used = ( $time_used + 1 )
         end
         set cases[1] = ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}_$current_choice
         echo "${max_geode} :: $case[1]" >> cases
         if ( $num_geode > $max_geode ) then
            set max_geode = $num_geode
            echo "***********************************************************************$line :: ${max_geode} :: $case[1] *********************************************************************************" >> max_geode
         endif 
         set cases = `echo $cases[2-]`
      else
         echo "${max_geode} :: $case[1]" >> cases
         if ( $num_geode > $max_geode ) then
            set max_geode = $num_geode
            echo "***********************************************************************$line :: ${max_geode} :: $case[1] *********************************************************************************" >> max_geode
         endif 
         set cases = `echo $cases[2-]`
      endif
    end
    echo "$id :: ${max_geode}" >> final_result
    set result = `echo "$result + ( $max_geode * $id )" | bc`
end
echo $result >> final_result
