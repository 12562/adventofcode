

set file = "$argv[1]"
set blue = 14
set green = 13
set red = 12
set colors = "red_green_blue"
set num  = 1
while ( $num <= 3 )
  set current_color = `echo $colors | awk -F '_' -v var=$num '{print $var}'`
  set other_color1 = `echo $colors | sed "s/$current_color//g" | sed 's/^_//g' | sed 's/__/_/g' | sed 's/_$//g' | awk -F '_' '{print $1}'`
  set other_color2 = `echo $colors | sed "s/$current_color//g" | sed 's/^_//g' | sed 's/__/_/g' | sed 's/_$//g' | awk -F '_' '{print $2}'`
  set limit = `eval echo \$$current_color`
 
  cat $file  | sed "s/[0-9]\+ *${other_color1}//g" | sed "s/[0-9]\+ *${other_color2}//g" | sed 's/,//g' | sed 's/;//g' | sed "s/${current_color}//g" | sed 's/ \+/ /g' | sed 's/: /:\n/g'  | sed "/^[0-9]/ s/\([0-9]\+\)/\1 <= $limit \&\&/g" | sed 's/&& *$//g' | grep -v Game | bc -l | grep -n . | grep ':1' | sed 's/:1//g' > ${current_color}_satisfy
  cat $file | sed "s/[0-9]\+ *${other_color1}//g" | sed "s/[0-9]\+ *${other_color2}//g" | sed 's/,//g' | sed 's/;//g' | sed "s/${current_color}//g"   | sed 's/ \+/ /g' | sed 's/: /:\n/g'    | grep -v Game  | perl -lape '$_ = qq/@{[sort {$a <=> $b} @F]}/' | awk '{print $NF}' >  ${current_color}_max

  @ num = ( $num + 1 )
end
echo "Part 1: "`cat red_satisfy blue_satisfy green_satisfy  | sort  | uniq -c | grep '^[ \t]*3' | awk '{print $2}' | datamash sum 1`
echo "Part 2: "`paste red_max blue_max green_max  | sed 's/[ \t]\+/*/g' | bc -l | datamash sum 1`


rm -f *_satisfy *_max
