csplit /^$/ {*} input1.txt
paste -sd+ xx* | sed 's/^+//g' |  bc -l | sort
