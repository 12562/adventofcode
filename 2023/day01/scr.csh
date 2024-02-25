

set file = "$argv[1]"
echo "Part 1: `cat $file | sed 's/[^0-9]*\([0-9]\).*\([0-9]\).*/\1\2/g' | sed '/[a-zA-Z]/ s/.*\([0-9]\).*/\1\1/g' | datamash  sum 1`"

cat $file | sed 's/^/++/g'  | sed 's/$/--/g' | grep -o '\(++\|\-\-\|[1-9]\|one\|two\|three\|four\|five\|six\|seven\|eight\|nine\)' | grep -A 1 ++ | grep -v '\-\-\|++' | sed 's/one/1/g' | sed 's/two/2/g' | sed 's/three/3/g' | sed 's/four/4/g' | sed 's/five/5/g' | sed 's/six/6/g' | sed 's/seven/7/g' | sed 's/eight/8/g' | sed 's/nine/9/g'  > a

cat $file | sed 's/^/++/g'  | sed 's/$/--/g' | rev | grep -o '\(++\|\-\-\|[1-9]\|eno\|owt\|eerht\|ruof\|evif\|xis\|neves\|thgie\|enin\)' | grep -A 1 '\-\-' | grep -v '\-\-\|++' | sed 's/eno/1/g' | sed 's/owt/2/g' | sed 's/eerht/3/g' | sed 's/ruof/4/g' | sed 's/evif/5/g' | sed 's/xis/6/g' | sed 's/neves/7/g' | sed 's/thgie/8/g' | sed 's/enin/9/g'  > b

echo "Part 2: `paste a b | sed 's/[ \t]*//g'  | datamash sum 1`"

rm -f a b

