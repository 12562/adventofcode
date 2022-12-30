#! /usr/bin/csh

set file = "$argv[1]"
grep -n . $file > reference_file
\cp -f $file runtime_file
set size = `wc -l $file | awk '{print $1}'`
set ctr = 1
while ( $ctr <= $size )
  set line = `head -n $ctr reference_file | tail  -n 1`
  set current_pos = `echo $line | sed 's/:.*//g'`
  set current_num = `echo $line | sed 's/.*://g'`
  set new_pos = `expr \( $current_pos  + $current_num \) %  $size`
  echo $new_pos
  if ( $new_pos <= 0 ) then
     echo "hi1"
     set new_pos = `expr $size + $new_pos`
     set i = $current_pos
     while ( $i <= $new_pos )
       if ( $i == $current_pos ) then
          sed -i "$i s/.*:/${new_pos}:/g" reference_file
       else   
          set existing_pos = `cat reference_file | head -n $i | tail -n 1 | sed 's/:.*//g'`
          echo "hi"
          set newpos = `expr $existing_pos - 1`
          sed -i "$i s/.*:/${newpos}:/g" reference_file
       endif
       @ i = ( $i  -  1 )
     end
  else
     set i = 1
     while ( $i <= $size )
       set existing_pos = `cat reference_file | head -n $i | tail -n 1 | sed 's/:.*//g'`
       if ( $existing_pos == $current_pos ) then
          sed -i "$i s/.*:/${new_pos}:/g" reference_file
       else
          if ( $existing_pos <= $new_pos && $existing_pos > $current_pos ) then
            set newpos = `expr $existing_pos - 1`
            sed -i "$i s/.*:/${newpos}:/g" reference_file
          endif
       endif
       @ i = ( $i + 1 )
     end
  endif
  sed -i "$current_pos d" runtime_file
  sed -i "$new_pos i$current_num" runtime_file
  @ ctr = ( $ctr + 1 )
end
