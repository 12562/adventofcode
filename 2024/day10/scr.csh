
set wd = `cat $1 | awk -F '' 'END {print NF}'`
set ht = `cat $1 | awk -F '' 'END {print NR}'`

echo "$wd $ht"

set stack = ( `cat $1 | sed 's/\([0-9]\)/\1\n/g' | grep -v '^$' | grep -n 0 | awk -F ':' '{print $1":"$1":"$2}'` )

echo $stack
