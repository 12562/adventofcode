echo "Part 2: "`cat input1.txt  | sed ':a;N;s/\([0-9]\)\n\([0-9]\)/\1 + \2/g; ba' | bc | sort  | tail -n 3 | sed 'N;N;s/\n/ + /g' | bc`
