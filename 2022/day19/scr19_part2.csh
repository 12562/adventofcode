#! /usr/bin/csh

rm -f res_file
set file = $argv[1]

set ORE = 1
set CLAY = 2
set OBS = 3
set GEODE = 4

set raw_blueprints = ( `grep -o '[0-9]\+' $file | sed 'N;N;N;N;N;N ;s/\n/_/g'` )
set blueprints = ( `echo $raw_blueprints | sed 's/ /\n/g' | awk -F '_' 'function max(a,b) { return a>b?a:b } {print  $2"_"$3"_"$4"_"$6"@"max(max(max($2,$3),$4),$6)"@"$5"@"$7}'` )

set ctr = 1
set p1_best = ()
iterate:
  if ( $ctr <= 3 ) then
     set blueprint = $blueprints[$ctr]
     set ore_costs = ( `echo $blueprint | awk -F '@' '{print $1}' | sed 's/_/ /g'` )
     set max_ore_cost = `echo $blueprint | awk -F '@' '{print $2}'`
     set obsidian_clay_cost = `echo $blueprint | awk -F '@' '{print $3}'`
     set geode_obsidian_cost = `echo $blueprint | awk -F '@' '{print $4}'`
     echo $blueprint
     set max_mins = 32
     goto best_num_geodes
     p1best:
       set p1_best = ( $p1_best $best )
       echo "P2 best: $p1_best"
       @ ctr += 1
       goto iterate
  endif
  echo -n "part2: "
  echo $p1_best | sed 's/ / * /g' | bc
exit

best_num_geodes:
  set best = 0
  set execution = ( "1|1_0_0_0@0_0_0_0@0" )
  echo $execution > queue
  rm -f seen
  touch seen
  loop:
  #echo "check6 `wc -l queue`"
  if ( `cat queue | wc -l` ) then
    #echo "$queue"
    set current = `sed '1 q;d' queue`
    set upper = `echo "$current" | awk -F '|' '{print $1}'`
    sed -i '1d' queue
    #echo "check7 : $upper $best"
    if ( $upper <= $best ) then
       goto continue_loop
    endif 
    set robots = ( `echo "$current" | awk -F '|' '{print $2}' | awk -F '@' '{print $1}' | sed 's/_/ /g'` )
    set resources = ( `echo "$current" | awk -F '|' '{print $2}' | awk -F '@' '{print $2}' | sed 's/_/ /g'` )
    set minutes = `echo "$current" | awk -F '|' '{print $2}' | awk -F '@' '{print $3}'` 
    set priority = $upper
    goto build_robot
branch_and_bound:
      #echo "check10: $choices"
      set k = 1
      loop2:
        #echo "check4 : $k : $#br_choices"
        if ( $k <= $#br_choices ) then
           set next = "$br_choices[$k]"
           #echo "NEXT: $next"
           set next_minutes = `echo "$next" | awk -F '@' '{print $3}'`
           set next_resources = (`echo "$next" | awk -F '@' '{print $2}' | sed 's/_/ /g'`)
           #echo "check next resources: $#next_resources $next_resources"
           if ( $#next_resources != 4 ) then
              set next_resources = (`echo "$next" | awk -F '@' '{print $2}' | sed 's/_/ /g'`)
           endif
           set next_robots = (`echo "$next" | awk -F '@' '{print $1}' | sed 's/_/ /g'`)
           goto geode_upper_bound
           back_from_gub:
           #echo "check5 : $next_upper : $best"
           if ( $next_upper > $best ) then
              goto geode_lower_bound
              back_from_glb:
              #echo "check : $best $lower_bound"
              set best = `echo "${best} ${lower_bound}" | sed 's/ /\n/g' | sort -n | tail -n 1`
              #echo $best >> res_file
              set minutes = `echo $next | awk -F '@' '{print $3}'`
              #echo "check: minutes: $minutes :: max_minutes: $max_mins :: already_seen: `grep -c "^$next" seen`"
              if ( ($minutes < $max_mins) &&  ( ! `grep -c "^$next"'$' seen`) ) then
                 #echo "check2 : $queue $next"
                 echo $next >> seen
                 #echo "check11: $queue"
                 echo "${next_upper}|${next}" >> queue
                 cat queue  | grep -n '|' | sort -t : -k 2rn -k 1n | sed 's/.*://g' > queue_tmp
                 \mv queue_tmp queue
                 #set queue = ( `echo "$queue ${next_upper}|${next}" | sed 's/ /\n/g' | grep -n '|' | sort -t : -k 2rn -k 1n | sed 's/.*://g'` ) 
                 #echo "check11: $queue"
                 #echo "check3"
              endif
           endif
        else
           goto end_of_loop2
        endif
        @ k += 1
        goto loop2
      end_of_loop2: 
  else
    goto end_of_loop
  endif
  continue_loop:
  goto loop
  end_of_loop:
  echo $best >> res_file
  goto p1best


build_robot:
  set br_num = 1
  set br_choices = ()
  while ( $br_num <= 4 )
    switch ( $br_num )
      case $ORE:
                  #echo "ORE"
                  set have_enough_already = `expr $robots[$ORE] \>= $max_ore_cost`
                  breaksw
      case $CLAY:
                  #echo "CLAY"
                  set have_enough_already = `expr $robots[$CLAY] \>= $obsidian_clay_cost`
                  breaksw
      case $OBS:  
                  #echo "OBS"
                  set have_enough_already = `expr $robots[$OBS] \>= $geode_obsidian_cost`
                  breaksw
      default:
                  #echo "DEFAULT"
                  set have_enough_already = 0
                  breaksw
    endsw
    set costs_ore = `echo $blueprint | awk -F '@' '{print $1}' | awk -v resource=$br_num -F '_' '{print $resource}'`
    set costs_clay = `echo "$obsidian_clay_cost * ($br_num == $OBS)" | bc`
    set costs_obs = `echo "$geode_obsidian_cost * ( $br_num == $GEODE )"  | bc`
    set costs = ( "$costs_ore" "$costs_clay" "$costs_obs" )
    #echo "check costs: $#costs $costs"
    if ( $#costs != 3 ) then
       set costs = ( "$costs_ore" "$costs_clay" "$costs_obs" )
    endif
    #echo $costs
    set lst = ("ore_t" "clay_t" "obs_t" )
    foreach t ( $ORE $CLAY $OBS )
      #echo "check: costs:$costs[$t] resources:$resources[$t] robots:$robots[$t]"
      if ( $costs[$t] <= $resources[$t] ) then
         #echo "check8: $costs[$t] $resources[$t]"
         set $lst[$t] = 0
      else if ( $robots[$t] == 0 ) then
         set $lst[$t] = 100000000000
      else
         set $lst[$t] = `expr \( $costs[$t] - $resources[$t] + $robots[$t] - 1 \)  / $robots[$t]`
      endif
    end
    set delay = `echo "${ore_t} ${clay_t} $obs_t" | sed 's/ /\n/g' | sort -n | tail -n 1 | sed 's/$/ + 1/g' | bc`
    #echo "$have_enough_already :: $costs :: $ore_t $clay_t $obs_t :: $delay"
    set ret_robots =  ( $robots )
    set ret_resources = ( $resources )
    set ret_minutes = $minutes
    set costs = ( $costs 0 )
    #echo "check costs2: $#costs $costs"
    if ( $#costs != 4 ) then
       set costs = ( $costs 0 )
    endif
    foreach r ( 1 2 3 4 )
      set tmp_sum =  `expr $delay \* $ret_robots[$r] - $costs[$r] `
      @ ret_resources[$r] += $tmp_sum 
    end
    @ ret_minutes += $delay 
    @ ret_robots[$br_num] += 1
    #echo "check: RET ROBOTS: $ret_robots"
    #echo "check: have_enough_already: $have_enough_already; $ret_minutes <= $max_mins"
    if ( ! ($have_enough_already) && ($ret_minutes <= $max_mins) ) then
       set br_rbs = `echo "${ret_robots}" | sed 's/ /_/g'`
       set br_res = `echo "${ret_resources}" | sed 's/ /_/g'`
       set br_choices = ( $br_choices "${br_rbs}@${br_res}@${ret_minutes}" )
    endif
    @ br_num += 1
  end 
  goto branch_and_bound

geode_upper_bound:
  set gub_robots = ( $next_robots )
  set ores_for = ( $next_resources[1] $next_resources[1] $next_resources[1] $next_resources[1] ) 
  set clay = $next_resources[2]
  set obs = $next_resources[3]
  set geodes = $next_resources[4]
  set gub_m = $next_minutes
  while ( ${gub_m} < $max_mins )
    set gub_new_bot = ( `echo "$ores_for[$ORE] >= $ore_costs[$ORE]" | bc` `echo "$ores_for[$CLAY] >= $ore_costs[$CLAY]" | bc` `echo "($ores_for[$OBS] >= $ore_costs[$OBS]) && ($clay >= $obsidian_clay_cost)" | bc` `echo "($ores_for[$GEODE] >= $ore_costs[$GEODE]) && ($obs >= $geode_obsidian_cost)" | bc`)
    
    foreach r ( 1 2 3 4 )
      set sum_tmp = ` expr $gub_robots[$ORE] - $gub_new_bot[$r] \* $ore_costs[$r] `
      @ ores_for[$r] += $sum_tmp
    end
    set sum_tmp = `expr $gub_robots[$CLAY] - $gub_new_bot[$OBS] \* $obsidian_clay_cost `
    @ clay += $sum_tmp
    set sum_tmp = `expr $gub_robots[$OBS] - $gub_new_bot[$GEODE] \* $geode_obsidian_cost `
    @ obs +=  $sum_tmp
    @ geodes += $gub_robots[$GEODE]
    
    foreach r ( 1 2 3 4 )
      @ gub_robots[$r] += $gub_new_bot[$r]
    end
    #echo "${_m} : $gub_robots : $ores_for : $clay : $obs : $geodes"
    @ gub_m += 1
  end
  set next_upper = $geodes
  goto back_from_gub

geode_lower_bound:
  set glb_robots = ( $next_robots )
  set glb_res = ( $next_resources )
  set glb_m = $next_minutes
  while ( ${glb_m} < $max_mins )
    set glb_new_bot = `echo "($glb_res[$ORE] >= $ore_costs[$GEODE]) && ($glb_res[$OBS] >= $geode_obsidian_cost)" | bc`
    foreach r ( 1 2 3 4 )
      @ glb_res[$r] += $glb_robots[$r]
    end
    set tmp_prod = `expr $ore_costs[$GEODE] \* $glb_new_bot`
    @ glb_res[$ORE] -= $tmp_prod
    set tmp_prod = `expr $geode_obsidian_cost \* $glb_new_bot`
    @ glb_res[$OBS] -= $tmp_prod
    @ glb_robots[$GEODE] += $glb_new_bot
    #echo "${_m} : $glb_robots : $glb_res"
    @ glb_m += 1
  end
  set lower_bound = $glb_res[$GEODE]
  goto back_from_glb
