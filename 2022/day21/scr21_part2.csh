#! /usr/bin/tcsh


set file = $argv[1]
set var_to_resolve = ( "root" )
set var = "`cat $file | grep '^'${var_to_resolve[1]}':' | sed 's/.*://g'`"
set var1 = `echo "$var" | awk -F '[+-/*]'  '{print $1}' | sed 's/ \+//g'`
set var2 =  `echo "$var" | awk -F '[+-/*]'  '{print $2}' | sed 's/ \+//g'`
set num = 0
first:
set var_to_resolve = ( $var1 )
echo $var_to_resolve
set valfor = "first"
goto loop
second:
set var_to_resolve = ( $var2 )
echo $var_to_resolve
set valfor = "sec"

loop:
while ( $#var_to_resolve > 0 )
    echo $var_to_resolve
    #if ( `echo "${var_to_resolve[1]}" | grep -o "[0-9]\+" | wc -l` ) then
    if ( "${var_to_resolve[1]}" =~ *[0-9]* ) then
       #echo $var_to_resolve
       break
    endif
    set var1 = "`cat $file | grep '^'${var_to_resolve[1]}':' | sed 's/.*://g'`"
    echo "Var:: $var1"
    #if ( `echo $var1 | grep ":" | wc -l ` > 0 ) then
    if ( "$var1" =~ *:* ) then
       set var = `echo "$var1" | sed 's/.*://g'`
       echo -- "Var: $var"
       echo "*******---------------$var---------------********"
    else
       set var = "$var1"
    endif
    echo "Check2"
    #if ( `echo $var | grep ":" | wc -l ` > 0 ) then
    if ( "$var" =~ *:* ) then
       set var = `echo $var  | sed 's/.*://g'`
    endif
    echo "Check3"
    if ( `echo "$var" | grep "[0-9]\+" ` != "" ) then
       echo "check: ${var_to_resolve[1]}"
       set ${var_to_resolve[1]} = "$var"  
       echo "----$var"
       echo "***********"
       eval echo \$${var_to_resolve[1]}
       echo "***********"
       set var_to_resolve = (`echo $var_to_resolve[2-]`)
       if ( $#var_to_resolve ) then
          if ( "${var_to_resolve[1]}" == "humn" ) then
             set value = $var
             set var_to_resolve = ( $value $var_to_resolve )
          endif
       endif
    else
       echo "chec : $var"
       set first_var = `echo "$var" | awk -F '[+-/*]'  '{print $1}' | sed 's/ \+//g'`
       set sec_var =  `echo "$var" | awk -F '[+-/*]'  '{print $2}' | sed 's/ \+//g'`
       echo "another check : $first_var $sec_var" 
       if ( (`eval echo \$$first_var |& grep -o Undefined ` != "Undefined") && (`eval echo \$$sec_var |& grep -o Undefined ` != "Undefined") ) then
          echo "pass : $first_var : $sec_var "
          set first_num = `eval echo \$$first_var`
          echo $first_num
          if ( "$first_num" == '$' ) then
             exit
          endif
          set sec_num = `eval echo \$$sec_var`
          if ( "$sec_num" == '$' ) then
             exit
          endif
          echo $sec_num
          set op = `echo "$var" | grep -o "[\+\*\/\-]"`
          #echo "Op:: $op"
          if ( `echo "$op" | grep -o "[\*]"`  == "*" ) then
             set op = "*"
          endif
          echo "Op: $op"
          echo "$first_num $op $sec_num"
          set ${var_to_resolve[1]} = `echo "$first_num $op $sec_num" | bc `
          set var_name = ${var_to_resolve[1]}
          set val = `eval echo \$$var_name`
          echo "$var_name : $val"
          #echo "${var_to_resolve[1]} :: `eval echo \$${var_to_resolve[1]}`"
          set var_to_resolve = (`echo $var_to_resolve[2-]`)
          if ( $#var_to_resolve ) then
             if ( "${var_to_resolve[1]}" == "humn" ) then
                set value = $val
                set var_to_resolve = ( $value $var_to_resolve )
             endif
          endif
       else
           echo "fail"
          if ( "$first_var" == "humn" ) then
             set var_to_resolve = ( $first_var $var_to_resolve )
             set var_to_resolve = ( $sec_var $var_to_resolve )
          else
             set var_to_resolve = ( $sec_var $var_to_resolve )
             set var_to_resolve = ( $first_var $var_to_resolve )
          endif
       endif
    endif
end

if ( $num <= 1 ) then
   echo "hash var to resolve: $#var_to_resolve"
   if ( ! $#var_to_resolve ) then
      set req_val = $val
      echo "Reqd val: $req_val"
   else
      set req_var_to_resolve = ( $var_to_resolve )
      set rvtr_i = `expr $#req_var_to_resolve - 1`
      echo "rvtr_i: $rvtr_i"
      echo "Var to resolve : $var_to_resolve"
   endif
   #echo "$first_var \n $sec_var" | grep -v $valfor
else
    @ rvtr_i = ( $rvtr_i - 1 )
endif

echo "Num: $num"
@ num += 1 
if ( $num <= 1 ) then
   if ( $valfor == "first" ) then
     goto second
   else
     goto first
   endif
else
   goto part2
endif

part2:
echo "rvtr_i: $rvtr_i"

if ( $rvtr_i >= 2 ) then
#foreach var ( `echo $req_var_to_resolve | sed 's/ /\n/g' | tac` )
    if ( $rvtr_i != `expr $#req_var_to_resolve - 1`  ) then
       if ( (`eval echo \$$to_resolve |& grep -o Undefined ` != "Undefined" ) ) then
          if ( `eval echo \$$to_resolve` =~ [0-9]* ) then
            set to_remove = `expr $rvtr_i + 1 `
            echo "Removed: $req_var_to_resolve[$to_remove]"
            #echo $req_var_to_resolve | sed 's/ /\n/g'
            #echo $req_var_to_resolve | sed 's/ /\n/g' | grep -n "[a-z]" 
            #echo $to_remove
            set req_var_to_resolve = (`echo "$req_var_to_resolve" | sed 's/ /\n/g' | grep -n "[a-z]" | grep -v "^${to_remove}"':' | sed 's/.*://g'`)      
            echo "REQ VAR TO RESOLVE : $req_var_to_resolve"
             #exit
          endif
       endif
    endif
    set to_resolve = $req_var_to_resolve[$rvtr_i]
    echo "To resolve: $to_resolve"
    set var_to_resolve = ( $req_var_to_resolve[$rvtr_i] )
    goto loop
endif

set $req_var_to_resolve[$#req_var_to_resolve] = $req_val
#echo "WGBD: $wgbd"
set loop_var = `expr $#req_var_to_resolve - 1`
echo "Loop var : $loop_var"
echo "req var to resolve: $req_var_to_resolve"

while ( $loop_var >= 1 )
  echo "At loop var : $req_var_to_resolve[$loop_var]"
  set operation = `grep -m 1 ":.*$req_var_to_resolve[$loop_var]" $file`
  echo "$operation"
  set loop_var_plus_one = `expr $loop_var + 1`
  set lhs = `eval echo \$$req_var_to_resolve[$loop_var_plus_one]`
  echo "LHS: $lhs"
  echo "operation: "
  echo "$operation" | sed 's/ /\n/g' 
  set op = `echo "$operation" | grep -o "[\+\*\/\-]"`
  echo "Op:: $op"
  if ( `echo "$op" | grep -o "[\*]"`  == "*" ) then
     set op = "*"
  endif
  echo "Op: ${op}:"
  set rhs_var = `echo "$operation" | sed 's/ /\n/g' | grep -v "$req_var_to_resolve[$loop_var_plus_one]\|$req_var_to_resolve[$loop_var]\|$op"`
  set rhs = `eval echo \$$rhs_var`
  echo "RHS: $rhs"
  if ( "$op" == "*" ) then
     set $req_var_to_resolve[$loop_var] = `echo "$lhs / $rhs" | bc -l`
  else if ( "$op" == "/" ) then
     if ( `echo "$operation" | awk '{print $2}'` == $rhs_var ) then
        set $req_var_to_resolve[$loop_var] = `echo "$rhs / $lhs" | bc -l`
     else
        set $req_var_to_resolve[$loop_var] = `echo "$lhs * $rhs" | bc -l`
     endif
  else if ( "$op" == "+" ) then
     set $req_var_to_resolve[$loop_var] = `echo "$lhs - $rhs" | bc -l`
  else if ( "$op" == "-" ) then
     if ( `echo "$operation" | awk '{print $2}'` == $rhs_var ) then
        set $req_var_to_resolve[$loop_var] = `echo "$rhs - $lhs" | bc -l`
     else
        set $req_var_to_resolve[$loop_var] = `echo "$lhs + $rhs" | bc -l`
     endif
  else
     echo "ERROR"
  endif
  echo "check"
  echo "$req_var_to_resolve[$loop_var] : "`eval echo \$$req_var_to_resolve[$loop_var]`
  @ loop_var = ( $loop_var - 1 )
end
echo $humn
    
