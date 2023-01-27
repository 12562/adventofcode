#! /usr/bin/csh

set file = $argv[1]
set days = $argv[2]
echo $file $days
rm -f runtime*
cat $file | sed 's/,/\n/g' | sed 's/$/ 1/g' > runtime0
set num = 0
set respawn_t = 7
set rt_minus_one = `expr $respawn_t - 1`
set respawned_t = 8
while ( $num < $days ) 
  awk -i inplace '{print $1 - $2" "1}' runtime*
  @ num += 1
  grep -h -- "-1" runtime* |  sed "s/-1/${respawned_t}/g" > runtime$num
  sed -i "s/-1/${rt_minus_one}/g" runtime*
  #set num_respawns = `cat tmp_file | grep -c -- "-1"`
  
  #seq $num_respawns | sed "s/.*/$respawned_t/g" >> tmp_file
  #sed -i "s/-1/$rt_minus_one/g" tmp_file
  echo $num
end 
rm -f tmp_file
wc -l runtime*
