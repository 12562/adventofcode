#! /usr/bin/csh

set file = $argv[1]
set days = 80
set part = 1
redo_part:
set internal_ts = (`cat $file | sed 's/,/\n/g' | sort | uniq -c | sed 's/^[ \t]*//g' | sed 's/ /@/g' | sed "s/"'$'"/_${days}/g"`)
### Num same timer, Timer, Days
set respawn_time = 7
set sum = 0
while ( $#internal_ts )
  set current = "$internal_ts[1]"
  echo "${current}" > file 
  #set current = ( `echo $current | sed 's/@\|_/ /g'` )
  set internal_ts = `echo "$internal_ts[2-]"`
  set num_same_t = `cut -d'@' -f1 file`
  #set num_same_t = "$current[1]"
  set sum = `echo "$sum + $num_same_t" | bc`
  set current_days = `cut -d'_' -f2 file`
  #set current_days = "$current[3]"
  set passed_days = `expr $days - ${current_days}`
  #set t = `echo "$current" | awk -v var=${passed_days} -F '_|@' '{print $2 + 1 + var}'`
  set current2 = `cut -d'@' -f2 file | cut -d'_' -f1`
  set t = `echo "$current2 + 1 + ${passed_days}" | bc `
  set spawn_t = ( `seq $t $respawn_time $days  | sed "s/\(.*\)/$days - \1/g" | bc | sed "s/^/${num_same_t}@8_/g" `)    
  set internal_ts = ( "$internal_ts" "$spawn_t" )
  set internal_ts = (`echo "$internal_ts" | sed 's/ /\n/g' |  awk -F '@' '{a[$2] += $1} END { for(i in a) { if (a[i] > 0 ) print a[i]"@"i }}' | sort -n -r -t '_' -k 2`)
end
echo "Part ${part} : $sum"
rm -f file
if ( $part == 1 ) then
   set days = 256
   set part = 2
   goto redo_part
endif
