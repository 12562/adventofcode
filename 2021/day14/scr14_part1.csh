

set file = $argv[1]
head -n 1 $file > template
set steps=0 num_steps=10
#set myvar = ( 0 0 0 0 0 0 0 0 0 0 )
while ( $steps < $num_steps ) 
  #set var = `cat $file | tac | sed '/^$/ q;' | grep -v '^$' | sed 's/^\([A-Z]\)\([A-Z]\) -> \([A-Z]\)/\/usr\/bin\/echo "'$template' \1\2 \3" | awk {print(match($1,$2)"_"$3);}/g' | sed 's/{/'\''{/g' | sed 's/}/}'\''/g' | csh | grep -v 0 | sort -n`
  cat $file | tac | sed '/^$/ q;' | grep -v '^$' | sed 's/^\([A-Z]\)\([A-Z]\) -> \([A-Z]\)/\/usr\/bin\/cat "template" | sed "s\/"'\'\$\''"\/ \3\/g" | grep -b -o -P "\1\2" | sed "s\/\1\2\/\3\/g"/g' |  sed 's/-P \"\(.\)\1/-P \"\1\(\?=\1\)/g' | sed 's/\/\(.\)\1\/\(.\)/\/:.*\/:\2/g' | csh | sort -n > var
  #echo "$var"
  cat var >> var2
  
  set num = 1
  foreach change ( `cat var` )
    echo "$change" | sed 's/:/ /g' > change
    if ( "`cat change`" =~ *:* ) then
       cat change
       exit
    endif
    set pos = `cat "change" | awk  '{print $1}' | sed 's/$/+ '$num'/g' | bc`
    set val = `cat "change" | awk '{print $2}'` 
    echo "$pos $val" >> pos_val
    if ( "$val" =~ *[0-9]* ) then
       echo "$val $change"
       exit
    endif
    cat template | sed 's/./&'$val'/'$pos > tmp
    \cp -f tmp template
    @ num += 1
  end
  #cat template 
  #cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort  -k 2 | wc -l
  #if ( `cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort  -k 2 | wc -l` == 10 ) then
  #   set tmpvar = ( `cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort -k 2 | awk '{print $1}'` )
  #   cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort -k 2 | awk '{print $2}' | paste -sd' '
  #   cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort -n
  #   echo "${tmpvar}:${myvar}" | sed 's/:/\n/g' | sed '2 s/\([0-9]\+\)/-\1/g' | datamash -t ' ' sum 1-10
  #   set myvar = ( $tmpvar )
  #endif
  #echo ""
  @ steps += 1
end
set min = `cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort -n | head -n 1 | awk '{print $1}'`
set max = `cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort -n | tail -n 1 | awk '{print $1}'`
echo "Part 1:"`expr $max - $min`
rm -f var var2 tmp template change pos_val
