#! /usr/bin/csh

set file = "$argv[1]"
rm -f possible_paths reduce_graph res_file

set nodes = ()
set neighbor_nodes = ()
set rates = ()
set edges = ()
foreach line (`cat $file | sed 's/, /,/g' | sed 's/ /_/g'`)
  set nodes = ( $nodes `echo $line | awk -F '_' '{print $2}'` )
  set neighbor_nodes = ( $neighbor_nodes `echo $line | awk -F '_' '{print $NF}'` )
  set rates = ( $rates `echo $line | awk -F '_' '{print $5}' | awk -F = '{print $2}' | sed 's/;//g'` )
end

set ctr = 1
while ( $ctr <= $#nodes )
  set node_edges = ""
  foreach neighbor_node ( `echo $neighbor_nodes[$ctr] | sed 's/,/ /g' `)
    set neighbor_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$neighbor_node'$' | sed 's/:.*//g'` 
    if ( $rates[$neighbor_pos] == 0 ) then
       set node_edges = "$node_edges,1/1"
    else
       set node_edges = "$node_edges,2/1"
    endif
  end
  set edges = ( $edges `echo $node_edges | sed 's/^,//g'`  )
  @ ctr = ( $ctr + 1 )
end

echo "Initially:"
echo $nodes
echo $neighbor_nodes
echo $rates
echo $edges
while ( `echo $rates | sed 's/ /\n/g' | grep -c '^0$'` > 1)
   set queue = ( AA )
   set visited = ()
   
   while ( $#queue > 0 )
     set current = $queue[1]
     echo "CURRENT: $current " >> reduce_graph
     #echo "Current : $current"
     set position = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$current'$' |  sed 's/:.*//g'`
     echo "POSITION: $position" >> reduce_graph
     set visited = ( $visited $current )
     echo "Visited : $visited" >> reduce_graph
     set queue = `echo $queue[2-]`
     #echo "Stack after deletion: $stack"
     set neighbors = `echo $neighbor_nodes[$position] | sed 's/,/ /g'`
     set true_neighbors = ()
     foreach neighbor ( $neighbors )
       if ( (`echo $visited | sed 's/ /\n/g' | grep '^'$neighbor'$' | wc -l` == 0) ) then
          set true_neighbors = ( $true_neighbors $neighbor  ) 
       endif
     end
     echo "TN: $true_neighbors" >> reduce_graph
     foreach tn ( $true_neighbors )
       set tn_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$tn'$' | sed 's/:.*//g'`
       echo "TN : $tn" >> reduce_graph
       echo "TN POS: $tn_pos" >> reduce_graph
       echo "TN RATE: $rates[$tn_pos]" >> reduce_graph
       if ( $rates[$tn_pos] == 0 ) then
          set tmp = $neighbor_nodes[$position]
          set tmp_num = `echo "$tmp,$neighbor_nodes[$tn_pos]" | sed 's/,/\n/g' | wc -l`
          set tmp_pos_neighs_num = `echo "$tmp" | sed 's/,/\n/g'  | wc -l `
          set tmp_ctr = 1
          set tmp1 = ""
          set tmp2 = ""
          #echo "check1"
          while ( $tmp_ctr <= $tmp_num )
            set nd = `echo "$neighbor_nodes[$position],$neighbor_nodes[$tn_pos]" | sed 's/,/\n/g' | sed "${tmp_ctr} q;d"`
            set ed = `echo "$edges[$position],$edges[$tn_pos]" | sed 's/,/\n/g' | sed "${tmp_ctr} q;d"`
            if ( ( $tmp_ctr <= $tmp_pos_neighs_num ) ) then
               if ( $nd != $tn ) then
                  set tmp1 = "${tmp1},${nd}"
                  set tmp2 = "${tmp2},${ed}"
               else
                  set tn_ed_twds = `echo $ed | awk -F '/' '{print $1}'`
                  set tn_ed_away = `echo $ed | awk -F '/' '{print $2}'`
               endif
            else
               if ( $nd != $current ) then
                  set twds = `echo $ed | awk -F '/' '{print $1}'`
                  set away = `echo $ed | awk -F '/' '{print $2}'`
                  set tmp1 = "${tmp1},$nd"
                  set tmp2 = "${tmp2},`expr $twds + $tn_ed_twds`/`expr $away + $tn_ed_away`"
               endif
            endif
            @ tmp_ctr = ( $tmp_ctr + 1 )
          end
          #echo "check2"
          if ( $tmp1 == "" ) then
             set tmp1 = "_"
             set tmp2 = "_"
          endif
          set neighbor_nodes[$position] = `echo $tmp1 | sed 's/^,//g'`
          set edges[$position] = `echo $tmp2 | sed 's/^,//g'`
          #echo "check: $tmp,$neighbor_nodes[$tn_pos]" 
          #set neighbor_nodes[$position] = `echo "$tmp,$neighbor_nodes[$tn_pos]" | sed "s/${tn}//g" | sed "s/${current}//g" | sed 's/,\+/,/g' | sed 's/^,//g' | sed 's/,''$''//g'`
          #echo $neighbor_nodes[$position]
          foreach neigh ( `echo $neighbor_nodes[$tn_pos] | sed 's/,/ /g' | sed "s/$current//g" `) 
            set neigh_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$neigh'$' | sed 's/:.*//g'` 
            #echo "NEIGH POS: $neigh_pos" >> reduce_graph
            set tmp = $neighbor_nodes[$neigh_pos]
            set tmp_num = `echo "$tmp,$neighbor_nodes[$tn_pos]" | sed 's/,/\n/g' | wc -l`
            set tmp_pos_neighs_num = `echo "$tmp" | sed 's/,/\n/g'  | wc -l `
            set tmp_ctr = 1
            set tmp1 = ""
            set tmp2 = ""
            while ( $tmp_ctr <= $tmp_num )
              set nd = `echo "$neighbor_nodes[$neigh_pos],$neighbor_nodes[$tn_pos]" | sed 's/,/\n/g' | sed "${tmp_ctr} q;d"`
              set ed = `echo "$edges[$neigh_pos],$edges[$tn_pos]" | sed 's/,/\n/g' | sed "${tmp_ctr} q;d"`
              if ( ( $tmp_ctr <= $tmp_pos_neighs_num ) ) then
                 if ( $nd != $tn ) then
                    set tmp1 = "${tmp1},${nd}"
                    set tmp2 = "${tmp2},${ed}"
                 else
                    set tn_ed_twds = `echo $ed | awk -F '/' '{print $1}'`
                    set tn_ed_away = `echo $ed | awk -F '/' '{print $2}'`
                 endif
              else
                 if ( $nd != $neigh ) then
                    set twds = `echo $ed | awk -F '/' '{print $1}'`
                    set away = `echo $ed | awk -F '/' '{print $2}'`
                    set tmp1 = "${tmp1},${nd}"
                    set tmp2 = "${tmp2},`expr $twds + $tn_ed_twds`/`expr $away + $tn_ed_away`"
                 endif
              endif
              @ tmp_ctr = ( $tmp_ctr + 1 )
            end
            if ( $tmp1 == "" ) then
               set tmp1 = "_"
               set tmp2 = "_"
            endif
            set neighbor_nodes[$neigh_pos] = `echo $tmp1 | sed 's/^,//g'`
            set edges[$neigh_pos] = `echo $tmp2 | sed 's/^,//g'`
            #set neighbor_nodes[$neigh_pos] = `echo "$tmp,$neighbor_nodes[$tn_pos]" | sed "s/${neigh}//g" | sed "s/${tn}//g" | sed 's/,\+/,/g' | sed 's/^,//g' | sed 's/,''$''//g'` 
            #echo $neighbor_nodes[$neigh_pos]
          end 
          #echo "$nodes"
          #echo "$neighbor_nodes"
          #echo "check3 :: $#neighbor_nodes $#nodes"
          set new_ctr = 1
          set num = $#nodes
          set new_nodes = ()
          set new_neighbors = ()
          set new_rates = ()
          set new_edges = ()
          while ( $new_ctr <= $num )
            if ( $new_ctr != $tn_pos ) then
               set new_nodes = ( $new_nodes $nodes[$new_ctr] ) 
               set new_neighbors = ( $new_neighbors $neighbor_nodes[$new_ctr] ) 
               set new_rates = ( $new_rates $rates[$new_ctr] )
               set new_edges = ( $new_edges $edges[$new_ctr] ) 
            endif
            @ new_ctr = ( $new_ctr + 1 )
          end
          #echo "check4"
          set nodes = ( $new_nodes )
          set neighbor_nodes = ( $new_neighbors )
          set rates = ( $new_rates ) 
          set edges = ( $new_edges )
          #echo "nodes: $nodes"
          #echo "neighbor_nodes: $neighbor_nodes"
          #echo "rates: $rates"
          #echo "edges: $edges"
          if ( $position > $tn_pos ) then
             @ position = ( $position - 1 ) 
          endif
          set queue = ( `echo $queue | sed 's/ /\n/g'  | grep -v "^${tn}"'$' ` )
       endif
     end
     echo "Verify: $neighbor_nodes[$position]" >> reduce_graph
     echo "Nodes: $nodes" >> reduce_graph
     echo "NNodes: $neighbor_nodes" >> reduce_graph
     echo "Rates: $rates" >> reduce_graph
     set neighbors = `echo $neighbor_nodes[$position] | sed 's/,/ /g'`
     set true_neighbors = ()
     foreach neighbor ( $neighbors )
       if ( `echo $visited | sed 's/ /\n/g' | grep '^'$neighbor'$' | wc -l ` ==  0 ) then
          set true_neighbors = ( $true_neighbors $neighbor  ) 
       endif
     end
     #echo $true_neighbors
     set queue = ( $queue $true_neighbors )
     echo "QUEUE : $queue" >> reduce_graph
   end
   #echo $nodes
   #echo $rates
end
echo "***************************************************************************************************************************************************************************"
echo "Finaly:"
echo $nodes
echo "$neighbor_nodes"
echo $rates
echo $edges

set stack = ( AA )
set lst = ( $stack )
set net_time_left = 26  ### Change this based on time elapsed
  
#while ( $#stack > 0 )
  set current = $stack[1]
  echo -n "$current" >> possible_paths
  #echo "CURRENT: $current"
  set position = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$current'$' |  sed 's/:.*//g'`
  #echo "POSITION: $position"
  set neighbors = ( `echo $neighbor_nodes[$position] | sed 's/,/ /g'` )
  set possible_paths = ()
  set visited = 1


POSSIBLE_PATHS:
  set current_path = $lst[1]
  echo "CURRENT PATH: $current_path" >> possible_paths
  set num_nodes_in_current_path = `echo $current_path | awk -F '_' "{print NF}"`
  echo "NUM NODES IN CURRENT PATH: $num_nodes_in_current_path"  >> possible_paths
  set current_path_last_node = `echo $current_path | awk -F '_' '{print $NF}'`
  echo "CURRENT PATH LAST NODE: $current_path_last_node" >> possible_paths
  if ( $num_nodes_in_current_path > 1 ) then
     set current_path_second_last_node = `echo $current_path | awk -F '_' '{print $(NF-1)}'`
  else
     set current_path_second_last_node = ""
  endif
  echo "CURRENT PATH SECOND LAST NODE: $current_path_second_last_node" >> possible_paths
  set last_node_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'${current_path_last_node}'$' | sed 's/:.*//g'`
  set last_node_neighs = ( `echo $neighbor_nodes[$last_node_pos] | sed 's/,/ /g'` )
  echo "LAST NODE NEIGHBORS: $last_node_neighs" >> possible_paths
  set lst = `echo $lst[2-]`
  echo "CURRENT LST : $lst" >> possible_paths
  if ( ! (($current_path_second_last_node != "AA") &&  (`echo $last_node_neighs | grep -o "AA" ` == "AA") ) && ( ($#last_node_neighs > 1 ) || $num_nodes_in_current_path > 2 )) then
     if ( ($#last_node_neighs == 1) || (`echo $current_path | sed 's/_/\n/g' | sort | uniq -d | wc -l` > 0)) then
        set visited = 0
     else
        set visited = 1
     endif
     echo "VISITED: $visited" >> possible_paths
     if ( $#last_node_neighs > 1 ) then
        set last_node_neighs = `echo $last_node_neighs | sed 's/ /\n/g' | grep -v '^'"$current_path_second_last_node"'$'`
     endif
     echo "LNN : $last_node_neighs" >> possible_paths
     foreach neighbor ( $last_node_neighs )
       set new_path = ""
       set neighbor_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'${neighbor}'$' | sed 's/:.*//g'`
       set num_neighbor_neighbors = `echo $neighbor_nodes[$neighbor_pos] | sed 's/,/\n/g' | wc -l`
       if ( $visited ) then
          if ( `echo $current_path | grep -o $neighbor ` !=  "$neighbor" ) then
             set new_path = "${current_path}_${neighbor}" 
          endif
       else
          if ( `echo "${current_path}_${neighbor}" | grep -o $neighbor | wc -l` <= $num_neighbor_neighbors ) then
             set new_path = "${current_path}_${neighbor}"
          endif
       endif
       if ( $new_path != "" ) then
          set lst = ( $new_path $lst ) 
       endif
     end
     echo "UPDATED LST : $lst" >> possible_paths
  else
     set possible_paths = ( $current_path $possible_paths ) 
     set visited = 1
  endif
  if ( $#lst > 0 ) then
     goto POSSIBLE_PATHS
  endif

  echo $possible_paths
  set max_ratio = 0
  set selected_path = ""
  foreach pp ( $possible_paths )
    set pp_nodes = (`echo $pp | sed 's/_/ /g'`) 
    #set num = 1
    #set path_length_twds = 0
    #set path_length_away = 0
    #while ( $num < $#pp_nodes )
    #  set cnode = $pp_nodes[$num]
    #  set cnode_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'${cnode}'$' | sed 's/:.*//g'`
    #  set nnum = `expr $num + 1`
    #  set nnode = $pp_nodes[$nnum]
    #  set neigh_pos_in_all_neighbors = `echo $neighbor_nodes[$cnode_pos] | sed 's/,/\n/g' | grep -n '^'${nnode}'$' | sed 's/:.*//g'`
    #  set edge_len = `echo $edges[$cnode_pos] | sed 's/,/\n/g' | sed "$neigh_pos_in_all_neighbors q;d"`
    #  set twds = `echo $edge_len | awk -F '/' '{print $1}'`
    #  set away = `echo $edge_len | awk -F '/' '{print $2}'`
    #  set path_length_twds = `expr $path_length_twds + $twds`
    #  set path_length_away = `expr $path_length_away + $away`
    #  @ num = ( $num + 1 )
    #end
    set pp_nodes = ( $pp_nodes "AA" )
    set pressure_released = 0 
    set path_num = 1
    set nodes_opened = ()
    set path_visited = ()
    set time_left = $net_time_left
    set time_left_for_ratio = $net_time_left
    set last_node = 0
    #set tmp_pp_nodes = ( `echo $pp_nodes | sed 's/AA //g' | sed 's/ /\n/g' | sort | uniq` )
    while ( $path_num <= $#pp_nodes ) 
      set current_node = $pp_nodes[$path_num]   
      if ( $path_num != $#pp_nodes ) then
         set next_pathnode_num = `expr $path_num + 1`
         set next_node = $pp_nodes[$next_pathnode_num]
      else
         set last_node = 1
      endif

      set current_node_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'${current_node}'$' | sed 's/:.*//g'`

      if ( `echo $nodes_opened | sed 's/ /\n/g' | grep '^'${current_node}'$'` == "${current_node}" || ($current_node == "AA")) then
         #echo "pass"
         set node_already_opened = 1
      else
         #echo "fail"
         set node_already_opened = 0
         set current_node_rate = $rates[$current_node_pos]
         if ( ! $last_node ) then
            set next_node_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'${next_node}'$' | sed 's/:.*//g'` 
            set next_node_rate = $rates[$next_node_pos]
         endif
      endif
      #echo "check"
      if ( ! $last_node ) then
         set next_node_pos_in_all_neighbors = `echo $neighbor_nodes[$current_node_pos] | sed 's/,/\n/g' | grep -n '^'${next_node}'$' | sed 's/:.*//g'`
         set edge_len_to_next_node = `echo $edges[$current_node_pos] | sed 's/,/\n/g'  | sed "$next_node_pos_in_all_neighbors q;d"`
         set T_reqd_for_ttnn = `echo $edge_len_to_next_node | awk -F '/' '{print $2}'`
         set T_reqd_for_ttnn_and_oi = `echo $edge_len_to_next_node | awk -F '/' '{print $1}'`
      endif
      
      #echo "check2"
      ### pr -> pressure released
      ### T -> Time
      ### ttnn -> travel to next node
      ### oi -> opening it
      if ( ! ($node_already_opened) && (`echo $path_visited | sed 's/ /\n/g' | grep '^'${current_node}'$' | sort | uniq` != "${current_node}") ) then 
         if ( ! $last_node ) then 
            set pr_if_both_nodes_opened = `echo "((($time_left - 1) * $current_node_rate)  +  (($time_left - $T_reqd_for_ttnn_and_oi) * $next_node_rate))" | bc`
            set pr_if_only_next_node_opened = `echo "(($time_left -  $T_reqd_for_ttnn_and_oi) * $next_node_rate)" | bc`
            set opening_both_nodes_ratio = `echo "$pr_if_both_nodes_opened / ( 1 + $T_reqd_for_ttnn_and_oi )" | bc `
            set opening_only_next_node_ratio = `echo "$pr_if_only_next_node_opened / $T_reqd_for_ttnn_and_oi" | bc`
         else
            set opening_both_nodes_ratio = 1
            set opening_only_next_node_ratio = 0
         endif
         if ( ($opening_both_nodes_ratio > $opening_only_next_node_ratio) || $last_node ) then
            set pressure_released = `echo "$pressure_released + (($time_left - 1) * $current_node_rate)" | bc`
            if ( ! $last_node ) then
               set time_left = `echo "$time_left - 1 - $T_reqd_for_ttnn" | bc `
               set time_left_for_ratio = `echo "$time_left_for_ratio - 1 - $T_reqd_for_ttnn" | bc `
            else
               set time_left = `echo "$time_left - 1" | bc`
               set time_left_for_ratio = `echo "$time_left_for_ratio - 1" | bc`
            endif
            #set node_opened_or_not[$path_num] = 1
            set nodes_opened = ( $nodes_opened $current_node )
            echo "NODE OPENED : $current_node"
         else
            if ( ! $last_node ) then
               set time_left = `echo "$time_left - $T_reqd_for_ttnn" | bc`
               set time_left_for_ratio = `echo "$time_left_for_ratio - $T_reqd_for_ttnn" | bc`
            endif
            echo "NODE NOT OPENED : $current_node"
            #set node_opened_or_not[$path_num] = 0
         endif
      else
         if ( $node_already_opened ) then
            if ( ! $last_node ) then
               set time_left = `echo "$time_left - $T_reqd_for_ttnn" | bc`
               #set time_left_for_ratio = `echo "$time_left - $T_reqd_for_ttnn" | bc`
            endif
            echo "NODE ALREADY OPENED : $current_node"
         else
            set pressure_released = `echo "$pressure_released + (($time_left - 1) * $current_node_rate)" | bc`
            if ( ! $last_node ) then
               set time_left = `echo "$time_left - 1 - $T_reqd_for_ttnn" | bc `
               set time_left_for_ratio = `echo "$time_left_for_ratio - 1 - $T_reqd_for_ttnn" | bc `
            else
               set time_left = `echo "$time_left - 1" | bc `
               set time_left_for_ratio = `echo "$time_left_for_ratio - 1" | bc `
            endif
            echo "NODE OPENED ON WAY BACK : $current_node"
         endif
      endif
         
      set path_visited = ( $path_visited $current_node )
      @ path_num = ( $path_num + 1 )
    end
    echo "$pp :: $pressure_released :: $time_left :: `echo $pressure_released / \( $net_time_left - $time_left_for_ratio \) | bc`" >> res_file
    if ( `echo $pressure_released / \( $net_time_left - $time_left_for_ratio \) | bc` >= $max_ratio ) then
       set selected_path = ( $pp_nodes )
       set max_ratio = `echo $pressure_released / \( $net_time_left - $time_left_for_ratio \) | bc`
    endif
  end
       
  echo "SELECTED PATH: $selected_path :: $max_ratio"
  #set stack = ( $selected_path[2] $stack)
#end
    
#    #set neigh_pos = `echo $nodes | sed 's/ /\n/g' | grep -n '^'$neighbor'$' |  sed 's/:.*//g'`
#    if (( `echo $visited | sed 's/ /\n/g' | grep '^'$neighbor'$' | wc -l ` ==  0 ) && (`echo $stack | sed 's/ /\n/g' | grep '^'$neighbor'$' | wc -l ` == 0)) then
#       if ( ($num > 1) && ($#neighbors != 1) ) then
#          set true_neighbors = ( $true_neighbors $current $neighbor  ) 
#       else
#          set true_neighbors = ( $true_neighbors $neighbor ) 
#       endif
#    else if ( ( `echo $visited | sed 's/ /\n/g' | grep '^'$neighbor'$' | wc -l ` ==  0 )  && (`echo $neighbor_nodes[$neigh_pos] | grep "AA" | wc -l ` > 0) ) then
#          set true_neighbors = ( $true_neighbors $neighbor ) 
#    endif
#    @ num = ( $num + 1 )
#  end
#  set stack = ( $true_neighbors $stack )
#  endif
#  #echo "STACK : $stack"
#end
#
#NEW_PATH:
