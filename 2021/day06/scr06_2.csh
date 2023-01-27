
#set num = 1
#set sum = 0
#set respawn_time = 7
#while( $num <= $#internal_timers)
#  set lst = $internal_timers[$num]
#  set num_same_timers = `echo $interanl_timers[$num] | awk -F '_' '{print $1}'`
#  set lvl = 1
#recalc: 
#  num_respawns = echo "$num_same_timers * (1 + (($num_days - $timer) / $respawn_time))" | bc
#  @ sum += num_respawns
#  set ctr = 0
#  set init_num_days_left = `echo $num_days - $timer - 1`
#  while ( $ctr < num_respawns )
#     set num_days_left = `echo ($init_num_days_left - ($ctr * $respawn_time)) | bc`
#     set data = "${new_num_same_timers}_${current_timer}_${num_days_left}_${lvl}"
#  end
