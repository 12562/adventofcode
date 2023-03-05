#! /usr/bin/csh


set file = $argv[1]
cat $file | sed 's/0/0000/g' | sed 's/1/0001/g' | sed 's/2/0010/g' | sed 's/3/0011/g' | sed 's/4/0100/g' | sed 's/5/0101/g' | sed 's/6/0110/g' | sed 's/7/0111/g' | sed 's/8/1000/g' | sed 's/9/1001/g' | sed 's/A/1010/g' | sed 's/B/1011/g' | sed 's/C/1100/g' | sed 's/D/1101/g' | sed 's/E/1110/g' | sed 's/F/1111/g' > reference_file

set ctr = 6 packetPART = "version" ref_file = "reference_file" num_subpackets = () version_sum = 0 typeid_map = ( "add" "mult" "min" "max" "nd" "gt" "lt" "eq" )

while (`cat $ref_file | sed 's/ */\n/g' | grep -v '^$' | wc -l`)
  #cat $ref_file | grep --color=always "^.\{$ctr\}" #| aha
  set num = `grep -o "^.\{$ctr\}" $ref_file`
  sed -i "s/^.\{$ctr\}//g" $ref_file
  switch ( "$packetPART" ) 
    case "version": 
              set packetVERSION = `echo $num | grep -o '^...' | sed 's/ */\n/g' | grep -v '^$' | tac | grep -n '.' | sed 's/\([0-9]\+\):\([01]\)/ ((2 ^ (\1 - 1)) * \2)/g' | bc | datamash -t ' ' sum 1`
              set packetTYPEID  = `echo $num | grep -o '...$' | sed 's/ */\n/g' | grep -v '^$' | tac | grep -n '.' | sed 's/\([0-9]\+\):\([01]\)/ ((2 ^ (\1 - 1)) * \2)/g' | bc | datamash -t ' ' sum 1`
              @ version_sum += $packetVERSION
              if ( $packetTYPEID == 4 ) then
                 set packetPART = "literal" ctr = 5 literal = "" bits = 6
              else
                 @ packetTYPEID += 1
                 set op = $typeid_map[$packetTYPEID]
                 set packetPART = "lengthtypeID" ctr = 1
              endif
            breaksw
    case "literal":
              @ bits += 5 
              set sub4 = `echo $num | grep -o '....$'`
              set literal = "${literal}${sub4}"
              if ( $num =~ 0* ) then
                 set literal_value = `echo "$literal" | sed 's/ */\n/g' | grep -v '^$' | tac | grep -n '.' | sed 's/\([0-9]\+\):\([01]\)/ ((2 ^ (\1 - 1)) * \2)/g' | bc | datamash -t ' ' sum 1`
                 set packetPART = "version" ctr = 6
                 if ( $#num_subpackets ) then
                    set tmp = "$num_subpackets[1]"
                    set current_literal = `echo "$tmp" | awk -F ':' '{print $4}' | sed 's/$/,'${literal_value}'/g' | sed 's/^,//g'`
                    set subpackets_lft = `echo "$tmp" | awk -F ':' -v b=$bits '$1=="fifteen" {print $2-b}; $1=="eleven" {print $2-1}'`
                    set num_subpackets[1] = `echo "$tmp" | awk -F ':' -v sl="$subpackets_lft" -v cl="$current_literal" '{print $1":"sl":"$3":"cl}'`
                    if ( $subpackets_lft ) then
                       set num_subpackets = `echo "$num_subpackets" | sed 's/ /\n/g' | awk -F ':' -v b=$bits -v pt="$packetTYPE" 'NR>1 && $1=="fifteen" {print $1":"$2-b":"$3":"$4}; NR==1 || $1=="eleven" {print $0}'`
                    else
                       while ( ! $subpackets_lft )
                          set tmp = "$num_subpackets[1]"
                          set current_literal = `echo "$tmp" | sed 's/.*://g'`
                          set op = `echo "$tmp" | grep -o  "add\|mult\|min\|max\|gt\|lt\|eq"`
                          set res = `awk -v var="${current_literal}" -f awk_funcs.awk -e 'BEGIN{split(var,arr,",");print('$op'(arr))}'`
                          set num_subpackets = `echo $num_subpackets[2-]`
                          if ( $#num_subpackets ) then
                             set tmp = `echo "$num_subpackets[1],${res}" | sed 's/:,/:/g'`
                             set num_subpackets[1] = `echo "$tmp" | awk -F ':' -v b=$bits '$1=="fifteen" {print $1":"$2-b":"$3":"$4}; $1=="eleven" {print $1":"$2-1":"$3":"$4}'`
                             set subpackets_lft = `echo "$num_subpackets[1]" | awk -F ':' '{print $2}'`
                          else
                             set part2_result = $res
                             break
                          endif
                       end
                       set num_subpackets = `echo "$num_subpackets" | sed 's/ /\n/g' | awk -F ':' -v b=$bits -v pt="$packetTYPE" 'NR>1 && $1=="fifteen" {print $1":"$2-b":"$3":"$4}; NR==1 || $1=="eleven" {print $0}'`
                    endif
                 endif
                 sed -i 's/^0\+$//g' $ref_file
              endif
            breaksw
    case "lengthtypeID":
              if ( $num ) then
                 set ctr = 11 packetPART = "processSUBPACKET" packetTYPE = "eleven"
              else
                 set ctr = 15 packetPART = "processSUBPACKET" packetTYPE = "fifteen"
              endif
            breaksw
    case "processSUBPACKET":
              set num_subpackets = `echo "$num_subpackets" | sed 's/ /\n/g' | awk -F ':' -v pt="$packetTYPE" '$1=="fifteen" && pt=="eleven" {print $1":"$2-18":"$3":"$4}; $1=="fifteen" && pt=="fifteen" {print $1":"$2-22":"$3":"$4}; $1=="eleven" {print $0}'`
              set decimal = `echo $num | sed 's/ */\n/g' | grep -v '^$' | tac | grep -n '.' | sed 's/\([0-9]\+\):\([01]\)/ ((2 ^ (\1 - 1)) * \2)/g' | bc | datamash -t ' ' sum 1`
              set num_subpackets = ( "${packetTYPE}:${decimal}:${op}:"  $num_subpackets )
              set packetPART = "version" ctr = 6  
            breaksw
  endsw
end
sed -i 's/^0\+$//g' $ref_file
echo "Part 1 : $version_sum"
echo "Part 2 : $part2_result"
rm -f reference_file
