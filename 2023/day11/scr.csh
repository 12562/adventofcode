
set file = "$1"
set debug = "$2"
set expandby = 1000000

echo -n "Part 1: "
cat $file | sed 's/^\(\.\+\)$/\1\n\1/g' | sed 's/./ &/g' | datamash -t ' ' transpose | sed 's/ //g' | sed 's/^\(\.\+\)$/\1\n\1/g' | sed 's/./ &/g' | grep -v '^$' | datamash -t ' ' transpose | awk '{print $0}; END {print "w@"NF"#"; print "h@"FNR"#"}' | sed 's/ /\n/g' | grep -n '#' | sed 's/:#//g' | tac | sed 's/.*\(:\)\|#//g' | awk -F '@' -v d=$debug '/h/ {h=$2}; /w/ {w=$2}; FNR>2 { r[FNR-2]=int(1 + (($1 - 1) / w)); c[FNR-2] = (($1 - 1) % w) + 1; if (d) {printf("%d %d\n",r[FNR-2], c[FNR-2])}} END { for(i=1; i<=FNR-2;i++){ for(j=i+1; j<=FNR-2;j++) { sum +=  sqrt((r[i]-r[j])*(r[i]-r[j])) + sqrt((c[i]-c[j])*(c[i]-c[j]))}}; print sum }'


set rows = `cat $file | grep -n '^\.\+$' | awk -F ':' '{print $1}'`
set cols = `cat $file | sed 's/./& /g' | datamash -t ' ' transpose | sed 's/ //g' | grep -n '^\.\+$' | awk -F ':' '{print $1}'`

if ( $debug ) then
   echo $rows
   echo $cols
endif

echo -n "Part 2: "
cat $file | sed 's/./ &/g' | awk '{print $0}; END {print "w@"NF"#"; print "h@"FNR"#"}' | sed 's/ /\n/g' | grep -v '^$' | grep -n '#' | sed 's/:#//g' | tac | sed 's/.*\(:\)\|#//g' | awk -v expandby=$expandby -v rarr="$rows" -v carr="$cols" -v rows=$#rows -v cols=$#cols -F '@' 'BEGIN {split(rarr, ra, " "); split(carr, ca, " ");} /h/ {tmph=$2; if(d) {print(tmph)}; h=tmph+(rows*expandby)}; /w/ {tmpw=$2; if(d) {print(tmpw)}; w=tmpw+(cols*expandby)}; FNR>2 { tmpr=int(1 + (($1 - 1) / tmpw)); for(m=1;m<=length(ra);m++){tmpra[m]=ra[m]}; tmpra[length(ra)+1]=tmpr; asort(tmpra); for(i=1;i<=length(tmpra);i++){if(tmpra[i]==tmpr){break;}}; if(i > 1){r[FNR-2]=(i-1)*expandby+(tmpr-(i-1))} else{r[FNR-2]=tmpr}; tmpc = (($1 - 1) % tmpw) + 1;for(m=1;m<=length(ca);m++){tmpca[m]=ca[m]}; tmpca[length(ca)+1]=tmpc; asort(tmpca); for(i=1;i<=length(tmpca);i++){if(tmpca[i]==tmpc){break;}}; if(i>1){c[FNR-2]=(i-1)*expandby+(tmpc-(i-1))} else {c[FNR-2]=tmpc}; if(d) {printf("%d org: %d %d; new:%d %d\n", $1, tmpr, tmpc, r[FNR-2], c[FNR-2])};  } END { for(i=1; i<=FNR-2;i++){ for(j=i+1; j<=FNR-2;j++) { sum +=  sqrt((r[i]-r[j])*(r[i]-r[j])) + sqrt((c[i]-c[j])*(c[i]-c[j]))}}; print sum }'

