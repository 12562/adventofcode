echo -n "Part 1 : "
cat $1 | grep -o 'mul([0-9]\+,[0-9]\+)' | sed 's/mul(\([0-9]\+\),\([0-9]\+\))/\1 * \2/g' | bc -l | datamash sum 1
echo -n "Part 2 : "
cat $1 | grep -o 'mul([0-9]\+,[0-9]\+)\|do()\|don'\''t()' | sed 's/mul ( \([0-9]\+\),\([0-9]\+\) ) /\1 * \2/g' | sed '/d/ {:a; N; s/\n//g; ba};' | sed 's/)d/)\nd/g' | grep -v don | sed 's/)m/)\nm/g' | sed 's/do()\|mul(\|)//g' | sed 's/,/*/g' | bc -l | datamash sum 1