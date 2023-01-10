#! /usr/bin/csh

set file = $argv[1]

foreach line ( `cat $file |  sed 's/ /_/g'` )
  set ore_robot_ore_cost = `echo $line | awk -F '_' '{print $7}'`
  set clay_robot_ore_cost = `echo $line | awk -F '_' '{print $13}'`
  set obsidian_robot_ore_cost = `echo $line | awk -F '_' '{print $19}'`
  set obsidian_robot_clay_cost = `echo $line | awk -F '_' '{print $22}'`
  set geode_robot_ore_cost = `echo $line | awk -F '_' '{print $28}'`
  set geode_robot_obsidian_cost = `echo $line | awk -F '_' '{print $31}'` 
  echo "$ore_robot_ore_cost $clay_robot_ore_cost $obsidian_robot_ore_cost $obsidian_robot_clay_cost $geode_robot_ore_cost $geode_robot_obsidian_cost"
  set num_ore_robots = 1
  set num_ore = 0
  set num_clay_robots = 0
  set num_clay = 0
  set num_obsidian_robots = 0
  set num_obsidian = 0
  set num_geode_robots = 0
  set num_geode = 0
  set time_used = 1
  set produce_obsidian = 0
  set produce_clay = 0
  set add_ore_robot = 0
  set cases = ( ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}_${produce_obsidian}_${produce_clay} )
start:
    set num = 1
    foreach case ( $cases )
      set time_used = `echo $case | awk -F '_' '{print $9}'`
      echo "Time Used: $time_used"
      set num_ore = `echo $case | awk -F '_' '{print $1}'`
      set num_ore_robots = `echo $case | awk -F '_' '{print $2}'`
      set num_clay = `echo $case | awk -F '_' '{print $3}'`
      set num_clay_robots = `echo $case | awk -F '_' '{print $4}'`
      set num_obsidian = `echo $case | awk -F '_' '{print $5}'`
      set num_obsidian_robots = `echo $case | awk -F '_' '{print $6}'`
      set num_geode = `echo $case | awk -F '_' '{print $7}'`
      set num_geode_robots = `echo $case | awk -F '_' '{print $8}'`
      set produce_obsidian = `echo $case | awk -F '_' '{print $10}'`
      set produce_clay = `echo $case | awk -F '_' '{print $11}'`
      set current_case = ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}

      while ( $time_used <= 24 )
        if (( $num_obsidian >= $geode_robot_obsidian_cost ) ) then
           if ( $num_ore >= $geode_robot_ore_cost ) then
              set add_geode_robot = 1
              set num_ore = `expr $num_ore - $geode_robot_ore_cost`
              set num_obsidian = `expr $num_obsidian - $geode_robot_obsidian_cost `
           else
              if ( $num_ore >= $ore_robot_ore_cost ) then
                 set add_ore_robot = 1
                 set num_ore = `expr $num_ore - $ore_robot_ore_cost`
              else
                 set add_ore_robot = 0
              endif
           endif
        else
           set add_geode_robot = 0
           if ( $num_obsidian_robots ) then
              set tmp_num_obsidian_robots = $num_obsidian_robots
           else
              set tmp_num_obsidian_robots = `expr $num_obsidian_robots + 1 `
           endif
           if ( !((`echo "( $geode_robot_obsidian_cost - $num_obsidian ) / $tmp_num_obsidian_robots" | bc | sed 's/-//g'` <=  `echo "( $geode_robot_ore_cost - $num_ore ) / $num_ore_robots" | bc | sed 's/-//g'`) )) then 
#|| ($num_ore > $geode_robot_ore_cost)) ) then
              if ( ($num_clay >= $obsidian_robot_clay_cost) || $produce_obsidian ) then
                 if (  $num_ore >= $obsidian_robot_ore_cost ) then
                    set add_obsidian_robot = 1
                    set add_clay_robot = 0
                    set num_ore = `expr $num_ore - $obsidian_robot_ore_cost`
                    set num_clay = `expr $num_clay - $obsidian_robot_clay_cost`
                 else
                    if ( $num_ore >= $ore_robot_ore_cost ) then
                       set add_ore_robot = 1
                       set num_ore = `expr $num_ore - $ore_robot_ore_cost`
                    else
                       set add_ore_robot = 0
                    endif
                 endif
              else 
                 set add_obsidian_robot = 0
                 if ( $num_clay_robots ) then
                    set tmp_num_clay_robots = $num_clay_robots
                 else
                    set tmp_num_clay_robots = `expr $num_clay_robots + 1 `
                 endif
                 if ( !(`echo "( $obsidian_robot_clay_cost - $num_clay ) / $tmp_num_clay_robots" | bc` <= `echo "( $obsidian_robot_ore_cost - $num_ore ) / $num_ore_robots" | bc`) ) then
                    if ( !($add_ore_robot) && (($num_ore >= $clay_robot_ore_cost) || $produce_clay )) then
                       set add_clay_robot = 1
                       set add_obsidian_robot = 0
                       set num_ore = `expr $num_ore - $clay_robot_ore_cost`
                    else
                       set add_clay_robot = 0
                       if ( $num_clay_robots ) then
                          set tmp_num_clay_robots = $num_clay_robots
                       else
                          set tmp_num_clay_robots = `echo $num_clay_robots + 0.1 | bc`
                       endif
#                       if ( !(`echo "( $clay_robot_ore_cost - $num_ore ) / $tmp_num_clay_robots" | bc` >= `echo "( $ore_robot_ore_cost - $num_ore ) / $num_ore_robots" | bc`) ) then
                          if ( $num_ore >= $ore_robot_ore_cost ) then
                             set add_ore_robot = 1
                             set num_ore = `expr $num_ore - $ore_robot_ore_cost`
                          else
                             set add_ore_robot = 0
                          endif
#                       else
#                          set add_ore_robot = 0
#                       endif
                    endif
                  else
                    set add_clay_robot = 0
                    set add_ore_robot = 0
                  endif
              endif
           else 
              set add_clay_robot = 0
              set add_ore_robot = 0
              set add_obsidian_robot = 0
           endif
        endif 
        @ num_ore = ( $num_ore + $num_ore_robots ) 
        @ num_clay = ( $num_clay + $num_clay_robots )
        @ num_obsidian = ( $num_obsidian + $num_obsidian_robots )
        @ num_geode = ( $num_geode + $num_geode_robots )
        if ( $add_ore_robot ) then
           @ num_ore_robots = ( $num_ore_robots + 1 )
           set add_ore_robot = 0
        endif
        if ( $add_clay_robot ) then
           @ num_clay_robots = ( $num_clay_robots + 1 )
           set add_clay_robot = 0
        endif
        if ( $add_obsidian_robot ) then
           @ num_obsidian_robots = ( $num_obsidian_robots + 1 )
           set add_obsidian_robot = 0
        endif
        if ( $add_geode_robot ) then
           @ num_geode_robots = ( $num_geode_robots + 1 )
           set add_geode_robot = 0
        endif
        echo "$time_used :: ORE: $num_ore R$num_ore_robots :: CLAY : $num_clay R$num_clay_robots :: OBSIDIAN : $num_obsidian R$num_obsidian_robots :: GEODE : $num_geode R$num_geode_robots"
        @ time_used = ( $time_used + 1 )
        set cases[$num] = ${num_ore}_${num_ore_robots}_${num_clay}_${num_clay_robots}_${num_obsidian}_${num_obsidian_robots}_${num_geode}_${num_geode_robots}_${time_used}_0_0
      end
      @ num = ( $num + 1 )
    end
    echo $cases
end
