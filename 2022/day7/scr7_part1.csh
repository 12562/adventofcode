#! /usr/bin/tcsh

set file = $argv[1]
set current_dir = ()
set contains = ()
set tmp = ()
foreach line ( `cat $file | sed 's/ /_/g' ` )
  echo $line
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
        echo $current_dir 
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
     echo $_contains_[$num_dirs]
     foreach dir ( `echo $_contains_[$num_dirs] | sed 's/-/\n/g' ` )
       if ( `echo $dir | grep "dir_" | wc -l ` > 0 ) then
          set dir_name = `echo $dir | awk -F '_' '{print $2}'`
	  set max = $#tmp
          set min = $num_dirs
          set count = `echo $tmp[${min}-$max] | sed 's/ /\n/g' | grep -n "$dir_name"'$' | head -n 1  | awk -F ':' '{print $1}' | sed 's/$/ + '$num_dirs' - 1/g' | bc -l`
          while ( $size[$count] == 0 ) 
             set count = `expr $count + 1`
          end
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

set num = 1
set num_dirs = $#tmp
set sum = 0
while ( $num <=  $num_dirs )
  if ( $size[$num] <= 100000 ) then
     echo $tmp[$num]
     echo $size[$num]
     @ sum = ( $sum + $size[$num] )
  endif
  @ num = ( $num + 1 )
end
echo $sum
