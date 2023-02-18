#! /usr/bin/csh

set file = $argv[1]
set pts = ( `cat input13.txt | sed '/^$/ q;' | grep -v '^$'` )
set fold_along = `grep "fold along" $file | awk '{print $3}'`

set num = 1
foreach fold ( $fold_along )
  if ( $fold =~ x=* ) then
     set val = `echo $fold | awk -F '=' '{print $2}'`
     set pts = ( `echo $pts | sed 's/ /\n/g' | awk -F ',' -v val=$val '{print $0","$1-val}' |  awk -F ',' -v val=$val '$3 <= 0 {print $1","$2}; $3>0 {print val-$3","$2}'   | sort | uniq | grep -v "^${val},"`  )
     if ( $num == 1 ) then
        set num_pts = `echo $pts | sed 's/ /\n/g' | awk -F ',' -v val=$val '{print $0","$1-val}' |  awk -F ',' -v val=$val '$3 <= 0 {print $1","$2}; $3>0 {print val-$3","$2}'   | sort | uniq | grep -v "^${val}," | wc -l`
     endif
  else
     set val = `echo $fold | awk -F '=' '{print $2}'`
     set pts = ( `echo $pts | sed 's/ /\n/g' | awk -F ',' -v val=$val '{print $0","$2-val}' |  awk -F ',' -v val=$val '$3 <= 0 {print $1","$2}; $3>0 {print $1","val-$3}'   | sort | uniq | grep -v ",${val}"`  )
     if ( $num == 1 ) then
        set num_pts = `echo $pts | sed 's/ /\n/g' | awk -F ',' -v val=$val '{print $0","$2-val}' |  awk -F ',' -v val=$val '$3 <= 0 {print $1","$2}; $3>0 {print $1","val-$3}'   | sort | uniq | grep -v ",${val}" | wc -l`
     endif
  endif
  @ num += 1
end
set maxX = `echo $pts | sed 's/ /\n/g' | awk -F ',' '{print $1}' | sort -n | tail -n1 | sed 's/$/ + 1/g' | bc`
set maxY = `echo $pts | sed 's/ /\n/g' | awk -F ',' '{print $2}' | sort -n | tail -n1 | sed 's/$/ + 1/g' | bc`
set total = `expr $maxX \* $maxY`
set pts = `echo $pts | sed 's/ /\n/g' | awk -F ',' -v col=$maxX '{print $1+$2*col+1}' `
set pattern = `echo $pts | sed 's/ /\\|/g' | sed 's/^/^\\(/g' | sed 's/$/\\)$/g'`
seq $total | sed "s/${pattern}/#/g" | sed 's/^[0-9]\+$/ /g' | paste -sd '' | sed "s/\(.\{$maxX\}\)/\1\n/g" | sed 's/\\n$//g'  | sed 's/#/##/g' | sed 's/ /  /g' | sed '1 s/^/text 15,15 "/g' > ascii.txt
echo '"' >> ascii.txt
convert -stroke "black" -strokewidth "15" -size 1500x260 xc:white -gravity center -font "FreeMono" -pointsize 20 -fill black -draw @ascii.txt image.png
set txt = `tesseract image.png stdout --dpi 70 -l eng --psm 8 | grep -o '[A-Z]'`
rm -f image.png ascii.txt
echo "Part 1: $num_pts"
echo "Part 2: `echo $txt | sed 's/ //g'`"
