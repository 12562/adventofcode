#! /usr/bin/tcsh


set file = $argv[1]
set to_resolve = $argv[2]
set var_to_resolve = ( "$to_resolve" )
echo $var_to_resolve

while ( $#var_to_resolve > 0 )
    echo $var_to_resolve
    set var1 = "`cat $file | grep '^'${var_to_resolve[1]}':' | sed 's/.*://g'`"
    echo "Var:: $var1"
    if ( `echo $var1 | grep ":" | wc -l ` > 0 ) then
       set var = `echo "$var1" | sed 's/.*://g'`
       echo -- "Var: $var"
       echo "*******---------------$var---------------********"
    else
       set var = "$var1"
    endif
    if ( `echo $var | grep ":" | wc -l ` > 0 ) then
       set var = `echo $var  | sed 's/.*://g'`
    endif
    if ( `echo "$var" | grep "[0-9]\+" | wc -l ` > 0 ) then
       echo "check: ${var_to_resolve[1]}"
       set ${var_to_resolve[1]} = "$var"  
       echo "----$var"
       echo "***********"
       eval echo \$${var_to_resolve[1]}
       echo "***********"
       set var_to_resolve = (`echo $var_to_resolve[2-]`)
    else
       echo "chec : $var"
       set first_var = `echo "$var" | awk -F '[+-/*]'  '{print $1}' | sed 's/ \+//g'`
       set sec_var =  `echo "$var" | awk -F '[+-/*]'  '{print $2}' | sed 's/ \+//g'`
       echo "another check : $first_var $sec_var" 
       if ( `eval echo \$$first_var |& grep -o Undefined | wc -l` == 0 && `eval echo \$$sec_var |& grep -o Undefined | wc -l ` == 0 ) then
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
          if ( `echo "$op" | grep -o "[\*]" | wc -l` > 0 ) then
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
       else
           echo "fail"
          set var_to_resolve = ( $first_var $var_to_resolve )
          set var_to_resolve = ( $sec_var $var_to_resolve )
       endif
    endif
end

