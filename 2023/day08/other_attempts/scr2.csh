
set file = "$1"
set debug = $2

echo -n "Part 2: "
cat "$file" | sed 's/(\|)\|,//g' | awk -v d=$debug '\
                      FNR==1 { \
                               split($1,instr,"") \
                             } \
                         /=/ { \
                               split($1, nodeChars, ""); \
                               if (nodeChars[3] == "A" ) { \
                                  start[++a] = $1; \
                                  printf("%d -> start: %s\n", a, start[a]); \
                               } else if ( nodeChars[3] == "Z" ) { \
                                  end[++c] = $1; \
                                  printf("%d -> end: %s\n", c, end[c]); \
                               } \
                               L[$1]=$3; \
                               R[$1]=$4; \
                             } \
                         END { \
                               ctr=1; \
                               steps=0; \
                               flag=0; \
                               for (b=1; b<=length(start); b++) { \
                                    res[b] = start[b]; \
                                    printf("start: %s, res: %s, end: %s\n", start[b], res[b], end[b]); \
                               } \
                               while(flag!=1) { \
                                 if (ctr>length(instr)) { \
                                     ctr=ctr%length(instr) \
                                 }; \
                                 if (d) { \
                                    for (k=1;k<=length(res);k++) { \
                                        printf("node:%s -> instr(%d):%s :: ", res[k], ctr, instr[ctr]); \
                                    } \
                                    print(""); \
                                 } \
                                 if (instr[ctr] == "R") { \
                                     for (k=1; k<=length(res);k++) { \
                                          res[k]=R[res[k]] \
                                     } \
                                 } else { \
                                     for (k=1; k<=length(res);k++) { \
                                          res[k]=L[res[k]] \
                                     } \
                                 } \
                                 if (d) { \
                                     for (k=1; k<=length(res);k++) { \
                                          printf("%s ", res[k]) \
                                     } \
                                     print(""); \
                                 } \
                                 flag = 1; \
                                 for (k=1;k<=length(res);k++) { \
                                     split(res[k], resultChars, ""); \
                                     if(resultChars[3]!="Z") { \
                                         flag=0; \
                                         break; \
                                     } \
                                 } \
                                 ctr+=1; \
                                 steps+=1 \
                               }; \
                               print(steps) \
                             }'


