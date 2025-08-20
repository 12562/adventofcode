
cat test_input.txt | awk '{printf $0; print "; "$2-$1" "$3-$2" "$4-$3" "$5-$4" "$6-$5;}' | awk '{printf $0; print "; "$8-$7" "$9-$8" "$10-$9" "$11-$10;}' | awk '{printf $0; print "; "$13-$12" "$14-$13" "$15-$14;}'
