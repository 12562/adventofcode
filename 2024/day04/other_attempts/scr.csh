#echo $wd
#echo $ht
#echo "hi"
#set horizontal = ` 
#####cat $1 | grep -o "XMAS\|SAMX\|S\(AMXMAS\)\+\|X\(MASAMX\)\+\|S\(AMXMASAMX\)\+\|X\(MASAMXMAS\)\+" | sed "s/MASAMX/MAS\nAMX/g" | sed "s/AMXMAS/AMX\nMAS/g" > out #| grep -v '^$' | wc -l`
#set vertical = ` 
#####cat $1 | sed 's/ */ /g' | datamash -t ' ' transpose | sed 's/ *//g' | grep -v '^$' | grep -o "XMAS\|SAMX\|S\(AMXMAS\)\+\|X\(MASAMX\)\+\|S\(AMXMASAMX\)\+\|X\(MASAMXMAS\)\+" | sed "s/MASAMX/MAS\nAMX/g" | sed "s/AMXMAS/AMX\nMAS/g" >> out #| grep -v '^$' | wc -l`
#echo "hi2"
#set rttolbdiag = ` 
#####cat $1 | sed '{:a; N; s/\n//g; ba}' | awk -F '' -v wd=$wd '{i=wd-1; ch=wd+1; for(j=1; j<=(2*wd-1); j++) { for(k=1;k<=i;k++) {printf(" ")}; if (j<=wd) {lim=j; ch--} else {lim=(2*wd - j);ch=ch+10}; ch2=ch; for(l=0;l<lim;l++){printf("%s ",$ch2); ch2=ch2+wd+1}; for(k=1; k<i;k++) {printf(" ")}; printf("\n"); if (j<wd) {i--} else {++i}}}' | grep -o "X M A S\|S A M X\|S\( A M X M A S\)\+\|X\( M A S A M X\)\+\|S\( A M X M A S A M X\)\+\|X\( M A S A M X M A S\)" | sed "s/M A S A M X/M A S\nA M X/g" | sed "s/A M X M A S/A M X\nM A S/g" >> out # | grep -v '^$' | wc -l`
#echo "hi4"
#echo "*****************************************************\n\n\n\n"
#set lttorbdiag = ` 
#####cat $1 | sed '{:a; N; s/\n//g; ba}' | awk -F '' -v wd=$wd '{i=wd-1; ch=0; for(j=1; j<=(2*wd-1); j++) { for(k=1;k<=i;k++) {printf(" ")}; if (j<=wd) {lim=j; ch++} else {lim=(2*wd - j);ch=ch+10}; ch2=ch; for(l=0;l<lim;l++){printf("%s ",$ch2); ch2=ch2+wd-1}; for(k=1; k<i;k++) {printf(" ")}; printf("\n"); if (j<wd) {i--} else {++i}}}' | grep -o "X M A S\|S A M X\|S\( A M X M A S\)\+\|X\( M A S A M X\)\+\|S\( A M X M A S A M X\)\+\|X\( M A S A M X M A S\)" | sed "s/M A S A M X/M A S\nA M X/g" | sed "s/A M X M A S/A M X\nM A S/g" >> out #| grep -v '^$' | wc -l`

#echo "hi3"
#echo "$horizontal"
#echo "$vertical"
#echo "$lttorbdiag"
#echo "$rttolbdiag"
##echo "$horizontal + $vertical + $lttorbdiag + $rttolbdiag" 
#echo "$horizontal + $vertical + $lttorbdiag + $rttolbdiag" | bc -l
#
#set row = 1
#set col = 1
#
#set queue = ( ${row}_${col}_`cat $1 | awk -F '' -v r=$row -v c=$col 'FNR==r {printf("%s",$c)}'`_`cat $1 | awk -F '' -v r=$row -v c=$col 'FNR==r {printf("%s",$c)}'` )
#set combinations_found = 0
#
#echo $queue
#while ( $#queue )
#  echo "hi"
#  set current = $queue[1]
#  set cur_row = `echo $queue[1] | awk -F '_' '{print $1}'` 
#  set cur_col = `echo $queue[1] | awk -F '_' '{print $2}'` 
#  set cur_cha = `echo $queue[1] | awk -F '_' '{print $3}'`
#  set cur_com = `echo $queue[1] | awk -F '_' '{print $4}'`
#
#  set queue = `echo $queue[2-]`
#
#  echo "hi2"
#  if ( `echo $cur_com | fold -w1 | wc -l` >= 4 ) then
#  echo "hi5"
#     if ( "$cur_com" == "XMAS" ) then
#        @ combinations_found = ( $combinations_found + 1 )
#     endif
#  else
#  echo "hi4"
#     # cat $1 | awk -F '' -v row=$cur_row -v col=$cur_col 'FNR==row {print($col))'` 
#     set neigh_cols = ( `echo "$cur_col - 1" | bc -l` $cur_col `echo "$cur_col + 1" | bc -l` )
#     set neigh_rows = ( `echo "$cur_row - 1" | bc -l` $cur_row `echo "$cur_row + 1" | bc -l` )  
# echo "hi6"
#     set neighbors = ()
#     echo "hi11"
#     foreach cl ( $neigh_cols )
#         if ( $cl > 0 ) then
#            foreach ro ( $neigh_rows )
#                if ( ($ro > 0) && !(($cl == $cur_col) && ($ro == $cur_row)) ) then
#                   set neigh_cha = `cat $1 | awk -F '' -v row=$ro -v col=$col 'FNR==row {print($col)}'`
#                   #if ( (`echo $cur_com | fold -w1 | wc -l` == 1 && $cur_com == "X") || (`echo $cur_com | fold -w1 | wc -l` == 2 && $cur_com == "XM") || (`echo $cur_com | fold -w1 | wc -l` == 3 && $cur_com == "XMA") ) then
#                      set neighbors = ( $neighbors ${ro}_${cl}_${neigh_cha}_${cur_com}${neigh_cha} )
#                   #else if ( $neigh_cha == "X" ) then
#                   #   set neighbors = ( $neighbors ${ro}_${cl}_${neigh_cha}_${neigh_cha} )
#                   #endif
#                endif
#            end
#         endif
#      end
#   echo "hi7"      
#   echo $neighbors
#  echo $queue
#      set queue = ( $queue $neighbors )
#  endif     
#  echo "hi3"
#  echo $queue
#end
#echo $combinations_found
