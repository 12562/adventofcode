

set file = $argv[1]
head -n 1 $file > template
set steps=0 num_steps=10
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
  cat template
  @ steps += 1
end
set min = `cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort -n | head -n 1`
set max = `cat template | sed 's/ */\n/g' | grep -v '^$' | sort | uniq -c | sort -n | tail -n 1`
echo "Part 1:"`expr $max - $min`
