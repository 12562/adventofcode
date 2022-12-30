cat input1.txt  | sed -n '/\([0-9]\+\)/ {:a; N; s/\([0-9]\+\)\n\([0-9]\+\)/\1 + \2/; ta; p}' | bc -l  | sort
