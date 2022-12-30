#! /usr/bin/tcsh
set total = 0
foreach line (`cat input3.txt`)
  set opponent = `echo $line | sed 's/_.*//g'`
  set me = `echo $line | sed 's/.*_//g'`

  set won = 6;
  set draw = 3;
  set lost = 0;
  switch ("$opponent$me")
    case "AX": 
	       set score = `expr $draw + 1`
               breaksw
    case "AY": 
	       set score = `expr $won + 2`
               breaksw
    case "AZ": 
	       set score = `expr $lost + 3`
               breaksw
    case "BX": 
	       set score = `expr $lost + 1`
               breaksw
    case "BY": 
	       set score = `expr $draw + 2`
               breaksw
    case "BZ": 
	       set score = `expr $won + 3`
               breaksw
    case "CX": 
	       set score = `expr $won + 1`
               breaksw
    case "CY": 
	       set score = `expr $lost + 2`
               breaksw
    case "CZ": 
	       set score = `expr $draw + 3`
               breaksw
    default: exit
  endsw
  set total = `expr $total + $score`
end
echo $total
