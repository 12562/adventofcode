#! /usr/bin/csh

set file = $argv[1]
echo "Part 1: "`cat $file  | sed ':a; s/\(()\|\[\]\|{}\|<>\)//g; ta' | grep '}\|)\|\]\|>' | grep -o '\[)\|\[}\|\[>\|{\]\|{>\|{)\|(\]\|(}\|(>\|<\]\|<}\|<)' | awk -F '' '{print $2}' | sed 's/)/3/g' | sed 's/\]/57/g' | sed 's/}/1197/g' | sed 's/>/25137/g' | datamash sum 1`

echo "Part 2: "`cat $file | sed ':a; s/\(()\|\[\]\|{}\|<>\)//g; ta' | grep -v '}\|)\|\]\|>' | rev | sed 's/{/}/g' | sed 's/(/)/g' | sed 's/\[/]/g' | sed 's/</>/g' | awk -F '' '{for(i=0;i<NF;i++) {printf "-"}};  {print "0 "$0}' | sed 's/)/ * 5 + 1 ) /g' | sed 's/\]/ * 5 + 2 ) /g' | sed 's/}/ * 5 + 3 ) /g' | sed 's/>/ * 5 + 4 ) /g' | sed 's/-/(/g' | bc | sort -n | datamash median 1`
