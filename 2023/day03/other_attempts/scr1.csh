
#set possiblePartNumbers = `echo "$engineSchematic" | sed 's/\([^A]\)/\1\n/g' | grep -n '.' | sed '/:\(A\)\?[0-9]/{:a; N; /A/''\!''{s/\n/,/g}; /[0-9]\+:[^0-9]/{s/[0-9]\+:\(A\)\?[^0-9]/B/g; bb}; ba; :b}' | grep "B" | sed 's/,B//g'`
#set possiblePartNumbers = `echo "$engineSchematic" | sed 's/\([^A]\)/\1\n/g' | grep -n '.' | sed '/:[0-9]/{ :a; N; s/\([0-9]\+:\)A\([0-9]\)/\1\2/g; tc; s/\n/,/g; /[0-9]\+:[^0-9]/{s/[0-9]\+:[^0-9]\+/B/g; bb}; ba;  :c; N; s/\n\([0-9]\+:[0-9]$\)/,\1/; /[0-9]\+:[^0-9]/{s/[0-9]\+:[^0-9]\+/B/g; bb}; bc; :b}' | grep "B" | sed 's/,B//g'`
#echo "$engineSchematic" | sed 's/\([^A]\)/\1\n/g' | grep -n '.' | sed '/:[0-9]/{ :a; N; s/A/A/; Td;  s/\([0-9]\+:\)A\([0-9]\)/\1\2/g; tc; :d; s/\n/,/g; /[0-9]\+:[^0-9]/{s/[0-9]\+:[^0-9]\+/B/g; bb}; ba;  :c; N; s/\n\([0-9]\+:[0-9]$\)/,\1/; /[0-9]\+:[^0-9]/{s/[0-9]\+:[^0-9]\+/C/g; bb}; bc; :b}'
#set possiblePartNumbers = `echo "$engineSchematic" | sed 's/\([^A]\)/\1\n/g' | grep -n '.' | sed '/:[0-9]/{ :a; N; s/A/A/; Td;  s/\([0-9]\+:\)A\([0-9]\)/\1\2/g; tc; :d; s/\n/,/g; /[0-9]\+:[^0-9]/{s/[0-9]\+:[^0-9]\+/B/g; bb}; ba;  :c; N; s/\n\([0-9]\+:[0-9]$\)/,\1/; /[0-9]\+:[^0-9]/{s/[0-9]\+:[^0-9]\+/C/g; bb}; bc; :b}' | grep ":[0-9]" | sed 's/,\(B\|C\)//g'`
#set possiblePartNumbers = `echo "$engineSchematic" | sed 's/\([^A]\)/\1\n/g' | grep -n '.' | sed 's/.*:\(A\)\?\./_/g' | grep -v ':[^0-9]' | sed ':a; N; s/\n/,/g; ta' | sed 's/\(,_\)\+/\n/g' | sed 's/^,//g'`


  #set partNum = `echo "$engineSchematic" | sed 's/\(.\)/\1\n/g' | sed -n '96,/\./{/\./{q}; p}' | sed ':a; N; s/\n//g; ta'`
