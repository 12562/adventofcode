#! /usr/bin/csh

set file = $argv[1]
echo "Part 1: "`cat $file | sed ':a; N; s/\(.\)\n\(.\)/\1 \2/ ; ta' | sed 's/:[^ ]*//g' | awk '{print NF", "$0}' | grep -v 0, | grep '^\(8\|7\)' | grep -v '7.*cid' | wc -l`

echo "Part2: "`cat $file | sed ':a; N; s/\(.\)\n\(.\)/\1 \2/ ; ta' | awk '{print NF", "$0}' | grep -v '^0,' | grep '^\(7\|8\)' | grep -v '^7.*cid:' | grep 'iyr:\(201[0-9]\|2020\)' | grep 'byr:\(19[2-9][0-9]\|200[0-2]\)' | grep 'eyr:\(202[0-9]\|2030\)' | grep 'hgt:\(\(1[5-8][0-9]\|19[0-3]\)cm\|\(59\|6[0-9]\|7[0-6]\)in\)' | grep 'hcl:#\([0-9a-f]\{6\}\)' | grep 'ecl:\(amb\|blu\|brn\|gry\|grn\|hzl\|oth\)' | grep 'pid:\([0-9]\{9\}\)\( \|$\)' | wc -l`
