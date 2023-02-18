#! /usr/bin/csh

set file = $argv[1]
rm -f lst_of_paths

set smaller = `cat $file | sed 's/-/\n/g' | sort | uniq | grep "[a-z]" | grep -v 'start\|end'`
set pattern = `echo $smaller | sed 's/ /\n/g' | sed 's/\(.*\)/\1.*\1/g' | sed ':a;N; s/\n/\\|/g ; ta'`
set nodes = `cat $file | sed 's/-/\n/g' | sort -u`
set neighbors = ()
foreach node ( $nodes )
  set node_neighbors = `cat $file | grep "^${node}-\|-${node}"'$' | sed "s/-${node}"'$//g' | sed "s/^${node}-//g" `
  set node_neighbors = `echo $node_neighbors | sed 's/ /,/g'`
  set neighbors = ( $neighbors $node_neighbors )
end

set stack = ( "start" )
touch lst_of_paths
#while ( `cat stack | wc -l` > 1 ) 
while ( $#stack )
  set current_p = "$stack[1]" #`sed "1 q;d" stack`
  #echo $current_p
  #if ( `cat stack | wc -l` > 0 ) then
  #   sed -i '1d' stack
  #endif
  set stack = `echo $stack[2-]`
  if ( "$current_p" =~ *end* ) then
     echo "$current_p" >> lst_of_paths
  else
     set already_repeated = `echo "${current_p}" | sed 's/,/\n/g' | sort | uniq -c  | grep "[a-z]" | awk '{print $1}'  | sort -n | tail -n1 | awk '{print $1 - 1}'`
     #echo "${current_p} :  $already_repeated"
     if ( $already_repeated ) then
        set lim = 1
     else
        set lim = 2
     endif
     set current_node = `echo "${current_p}" | awk -F ',' '{print $NF}'`
     set current_node_pos = `echo $nodes | sed 's/ /\n/g' | grep -n "^$current_node"'$' | sed 's/:.*//g'`
     set current_node_neighbors = `echo $neighbors[$current_node_pos] | sed 's/,/ /g'`
     #echo $current_node_neighbors
     foreach neighbor ( $current_node_neighbors )
       #echo $neighbor
       if ( ("${neighbor}" =~ *[A-Z]*) || (("${neighbor}" =~ *[a-z]*)  && (`echo "${current_p}" | sed 's/,/\n/g' | grep "^$neighbor"'$' | uniq -c | awk '{print $1}'` < $lim ) && ("$neighbor" != "start") ) ) then
           #sed -i  "1i ${current_p},$neighbor" stack
           set stack = ( "${current_p},$neighbor" $stack )
       endif
     end
  endif
  #cat stack | wc -l
  #echo $stack
end
echo "$pattern"
echo "Part 1:"`cat lst_of_paths | grep -v "$pattern" | wc -l`
echo "Part 2:"`cat lst_of_paths | wc -l`
#cat lst_of_paths | grep -v "al.*al\|bj.*bj\|da.*da\|iw.*iw\|op.*op\|zh.*zh" | wc -l
rm -f lst_of_paths
