#! /usr/bin/tcsh

set file = $argv[1]
set current_dir = ()
set contains = ()
set tmp = ()
foreach line ( `cat $file | sed 's/ /_/g' ` )
  if ( `echo $line | grep '^\$' | wc -l ` > 0 ) then
     set cmd = `echo $line | awk -F '_' '{print $2}'`
     set num = 1
     if ( $cmd == "cd" ) then
        set arguments = `echo $line | awk -F '_' '{print $3}'`
        switch ($arguments)
          case "..":
                     set num = `expr $#current_dir - 2`
                     set current_dir = ( $current_dir[1-$num] )
                   breaksw
          default:
		   if ( "$arguments" == "/" ) then
           	    set current_dir = ( \/ )
		   else if ( "$current_dir" == "/" ) then
           	    set current_dir = ( $current_dir $arguments )
		   else
           	    set current_dir = ( $current_dir \/ $arguments )
	           endif
           	breaksw
        endsw
     endif
  else
     if ( $cmd == "ls" ) then
	if (  $num  == 1 ) then
	  set tmp = ( $tmp `echo $current_dir | sed 's/ //g' | sed "s/\//a_a/g"`  )
	   @ num = ( $num + 1 )
	   set contains = ( $contains $line )
	else
	   set contains = ( "$contains-$line"  )
	endif
     endif
  endif
end

set _contains_  = ( $contains )
set new_contains  = ( $contains )
set num_dirs = $#tmp
set num = 1
set size = ()
set all_dir = ()
while ( $num <= $num_dirs ) 
  set size = ( $size 0 )
  @ num = ( $num + 1 )
end
while ( $num_dirs > 0 )
     set all_dir = ()
     foreach dir ( `echo $_contains_[$num_dirs] | sed 's/-/\n/g' ` )
       if ( `echo $dir | grep "dir_" | wc -l ` > 0 ) then
          set dir_name = `echo $dir | awk -F '_' '{print $2}'`
          set parent_dir = $tmp[$num_dirs]
          if ( $parent_dir == "a_a" ) then
            set actual_dir = "${parent_dir}$dir_name"
          else
            set actual_dir = "${parent_dir}a_a$dir_name"
          endif
          echo "Num dirs: $num_dirs"
	  set max = $#tmp
          echo "Max: $max"
          set min = $num_dirs
          echo "Min: $min"
          #set count = `echo $tmp[${min}-${max}] | sed 's/ /\n/g' | grep -n "$actual_dir"'$' | head -n 1  | awk -F ':' '{print $1}' | sed 's/$/ + '$num_dirs' - 1/g' | bc -l`
          set count = `echo $tmp | sed 's/ /\n/g' | grep -n '^'"$actual_dir"'$' | head -n 1  | awk -F ':' '{print $1}' `
          echo $count
          echo "hi2"
          #while ( $size[$count] == 0 ) 
          #   set count = `expr $count + 1`
          #end
	  set dir_size = $size[$count]
          set new_dir = "${dir_size}_${dir_name}"
       else
          set new_dir = $dir
       endif
       if ( $all_dir == "" ) then
	  set all_dir = $new_dir
       else
          set all_dir = ( ${all_dir}-$new_dir )
       endif
     end 
  set new_contains[$num_dirs] = $all_dir
  set size[$num_dirs] = `echo $new_contains[$num_dirs] | grep -o "[0-9]\+" | xargs echo | sed 's/ / + /g' | bc -l` 
  @ num_dirs = ( $num_dirs - 1 )
end

echo $size[1]
set total = 70000000
set available = `expr $total - $size[1]`
echo "Unused : $available"
set reqd = 30000000
set to_delete = `expr $reqd - $available`
echo "To delete: $to_delete"

set num = 1
set num_dirs = $#size
set arr = ()
while ( $num <=  $num_dirs )
  if ( $size[$num] >= $to_delete ) then
     set arr = ( $arr $size[$num] )
  endif
  @ num = ( $num + 1 )
end
echo -n "Delete : "
echo $arr  | sed 's/ /\n/g' | sort -n 
