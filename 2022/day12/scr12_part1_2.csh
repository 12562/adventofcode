#! /usr/bin/csh


set file = $argv[1]
set num_rows = `wc -l $file  | awk '{print $1}'`
set num_cols = `cat $file | awk -F '' 'END {print NF}'`
rm -f str visited unvisited tentative_distance S
cat $file | xargs echo | sed 's/ //g' | sed 's/ */\n/g' | grep "[a-zSE]" > str
set S = "b"
set a = "b"
set b = "c"
set c = "d"
set d = "e"
set e = "f"
set f = "g"
set g = "h"
set h = "i"
set i = "j"
set j = "k"
set k = "l"
set l = "m"
set m = "n"
set n = "o"
set o = "p"
set p = "q"
set q = "r"
set r = "s"
set s = "t"
set t = "u"
set u = "v"
set v = "w"
set w = "x"
set x = "y"
set y = "z"
set z = "z"

set source = `cat str | sed 's/ */\n/g' | grep "[a-zA-Z]" | grep -n S | awk -F ':' '{print $1}'`
set dest = `cat str | sed 's/ */\n/g' | grep "[a-zA-Z]" | grep -n E | awk -F ':' '{print $1}'`
#set dest = 3155

cat str | grep -n "[a-zSE]" | sed 's/S/0/g' | sed 's/[a-zE]/1000000/g' > tentative_distance
cat str | grep -n "[a-zSE]" | sed 's/:.*//g' > prev
sed -i 's/S/a/g' str
sed -i 's/E/z/g' str

cat str | grep -n "[a-z]" | sed 's/:.*//g' > unvisited
set current =  $source 
set step = 1
touch visited
set flag = 0
while ( `stat -c "%s" tentative_distance` != 0 ) 
  #echo "#############"
  #cat tentative_distance | sort -t : -k 2 
  #echo "#############"
  set current = `cat tentative_distance  |  sort -n -t : -k 2 | head -n 1 | sed 's/:.*//g'`
  echo "Current : $current"

  set current_char = `cat str | head -n $current | tail -n 1` 
  set current_tent_dist = `cat tentative_distance | grep "^${current}:" | awk -F ':' '{print $2}'`
  #echo $current_tent_dist
  set possible_neighs_current = ( `expr $current - 1`   `expr $current + 1`  `expr $current + $num_cols`  `expr $current - $num_cols` )

  sed -i "/^${current}:/ d" tentative_distance
  echo $current >> visited

  set true_neighbors = ()
  foreach neighbor ( $possible_neighs_current )
    set neighbor_char = `cat str | head -n $neighbor | tail -n 1` 
    if ( ($current_char == "m" && $neighbor_char == "k") || ($current_char == "b" && $neighbor_char == "a") ) then
        set true_neighbors = ( $true_neighbors $neighbor )
    else if ( ($neighbor <= 0) || ($neighbor > `wc -l str | awk '{print $1}'` ) || (`grep "^"$neighbor'$' visited | wc -l` > 0)) then 
  #      echo "check1"
        continue
    else if ( ( $neighbor_char != $current_char ) && ( $neighbor_char != `eval echo \$$current_char `)  ) then
  #      echo "check2"
        continue
    else
        set true_neighbors = ( $true_neighbors $neighbor )
    endif
  end
  #echo "Num true neighbors : $#true_neighbors"
  echo "True neighbors : $true_neighbors"
  set min_neighbor_distances  = ()
  foreach neighbor ( $true_neighbors )
    if ( $neighbor_char == $current_char ) then
       set td = 2 
    else
       set td = 1
    endif
    set neighbor_tent_dist = `expr $td + $current_tent_dist`
    #echo $neighbor_tent_dist
    set current_neighbor_tent_dist = `cat tentative_distance | grep "^${neighbor}:" | awk -F ':' '{print $2}'`
    #echo $current_neighbor_tent_dist
    if ( $current_neighbor_tent_dist > $neighbor_tent_dist ) then
       sed -i "/^${neighbor}:/ s/:.*/:$neighbor_tent_dist/g" tentative_distance
       #echo "***************"
       #cat tentative_distance
       #echo "***************"
       sed -i "s/^${neighbor}"'$'"/${current}/g" prev
       set min_neighbor_distances = ( $min_neighbor_distances $neighbor_tent_dist  )
    else
       set min_neighbor_distances = ( $min_neighbor_distances $current_neighbor_tent_dist  )
    endif 
  end
  echo $min_neighbor_distances
  if ( `echo $min_neighbor_distances | sed 's/ /\n/g' | sort | uniq | head -n 1 ` == 1000000 ) then
    break
  endif

  if ( $current == $dest ) then
     echo "Has path"
     set flag = 1
     break
  #else if ( `echo $min_neighbor_distances | sed 's/ /\n/g' | sort -n | head -n 1` == 1000000  ) then
  #   break
  endif

  #set ctr = 1
  #set min = 1000000
  #set num =  $#min_neighbor_distances
  #while ( $ctr <= $num )
  ##  echo "hi"
  #  if ( $min_neighbor_distances[$ctr] < $min ) then
  #     set select_ctr = $ctr
  #     set min = $min_neighbor_distances[$ctr]
  #  endif
  #  @ ctr = ( $ctr + 1 )
  #end
  #set current = $true_neighbors[$select_ctr]
  #@ step = ( $step + 1 )
end
if ( ! $flag ) then
  echo "No path"
else
  touch S
  set u = $dest
  while ( $u != $source ) 
    echo $u >> S
    set u = `cat prev | head -n $u | tail -n 1`
  end 
  echo `wc -l S`
  cat S | xargs echo
endif
