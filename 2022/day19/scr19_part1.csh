#! /usr/bin/csh

set file = $argv[1]

foreach line ( `cat $file |  sed 's/ /_/g'` )
  set ore_robot_ore_cost = `echo $line | awk -F '_' '{print $7}'`
  set clay_robot_ore_cost = `echo $line | awk -F '_' '{print $14}'`
  set obsidian_robot_ore_cost = `echo $line | awk -F '_' '{print $21}'`
  set obsidian_robot_clay_cost = `echo $line | awk -F '_' '{print $24}'`
  set geode_robot_ore_cost = `echo $line | awk -F '_' '{print $31}'`
  set geode_robot_obsidian_cost = `echo $line | awk -F '_' '{print $34}'` 
  echo "$ore_robot_ore_cost $clay_robot_ore_cost $obsidian_robot_ore_cost $obsidian_robot_clay_cost $geode_robot_ore_cost $geode_robot_obsidian_cost"
  set num_ore_robots = 1
  set num_ore = 0
  set num_clay_robots = 0
  set num_clay = 0
  set num_obsidian_robots = 0
  set num_obsidian = 0
  set num_geode_robots = 0
  set num_geode = 0
  set time_left = 24
  set req_obsidian_rate = `expr $geode_robot_obsidian_cost / $geode_robot_ore_cost `
  set req_clay_rate = `expr $obsidian_robot_clay_cost / $obsidian_robot_ore_cost  `
  set produce_obsidian = 0
  set produce_clay = 0
  set add_ore_robot = 0
  while ( $time_left > 0 )
    #if ( $num_ore >= $ore_robot_ore_cost ) then
    #else
    #endif
    #if ( ( $num_obsidian >= $geode_robot_obsidian_cost ) && ( $num_ore >= $geode_robot_ore_cost ) then
    #endif  
    if ( ($num_clay < $obsidian_robot_clay_cost) ) then
       set produce_clay = 1
    else if ( $num_obsidian_robots < $req_obsidian_rate ) then
       set produce_obsidian = 1
       set produce_clay = 0
    else
       set produce_clay = 0
       set produce_obsidian = 0
    endif
    if (( $num_ore >= $geode_robot_ore_cost ) && ( $num_obsidian >= $geode_robot_obsidian_cost ) ) then
       set add_geode_robot = 1
       set num_ore = `expr $num_ore - $geode_robot_ore_cost`
       set num_obsidian = `expr $num_obsidian - $geode_robot_obsidian_cost `
    else
       set add_geode_robot = 0
    endif 
    if ( $produce_clay  && ($num_ore >= $clay_robot_ore_cost ) ) then
       set add_clay_robot = 1
       set num_ore = `expr $num_ore - $clay_robot_ore_cost`
    else
       set add_clay_robot = 0
    endif
    if ( $produce_obsidian && ( $num_ore >= $obsidian_robot_ore_cost ) && ($num_clay >= $obsidian_robot_clay_cost) ) then
       set add_obsidian_robot = 1
       set num_ore = `expr $num_ore - $obsidian_robot_ore_cost`
       set num_clay = `expr $num_clay - $obsidian_robot_clay_cost`
    else
       set add_obsidian_robot = 0
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
    @ time_left = ( $time_left - 1 )
    echo "$time_left :: ORE: $num_ore R$num_ore_robots :: CLAY : $num_clay R$num_clay_robots :: OBSIDIAN : $num_obsidian R$num_obsidian_robots :: GEODE : $num_geode R$num_geode_robots"
  end
end
