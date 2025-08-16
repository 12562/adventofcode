
set file = "$1"
set debug = $2

echo -n "Part 1: "
cat "$file" | sed 's/(\|)\|,//g' | awk -v d=$debug 'FNR==1 { \
                                                            split($1,instr,"") \
                                                          } \
                                                      /=/ { \
                                                            L[$1]=$3; \
                                                            R[$1]=$4; \
                                                          } \
                                                      END { res="AAA"; \
                                                            ctr=1; \
                                                            steps=0; \
                                                            while(res!="ZZZ") { \
                                                              if (ctr>length(instr)) { \
                                                                  ctr=ctr%length(instr) \
                                                              }; \
                                                              if (d) { \
                                                                  printf("node:%s -> instr(%d):%s\n", res, ctr, instr[ctr]); \
                                                              } \
                                                              if (instr[ctr] == "R") { \
                                                                  res=R[res] \
                                                              } else { \
                                                                 res=L[res] \
                                                              } \
                                                              if (d) { \
                                                                  print(res) \
                                                              } \
                                                              ctr+=1; \
                                                              steps+=1 \
                                                            }; \
                                                            print(steps) \
                                                          }'

if ( "$file" == test_input.txt ) then
     set file = "test_input2.txt"
endif

echo -n "Part 2: "
cat "$file" | sed 's/(\|)\|,//g' | awk -v d=$debug '\
                      function gcd(a,b) {return b?gcd(b,a%b):a} \
                      function lcm(a,b) {return a*b/gcd(a,b)} \
                      FNR==1 { split($1,instr,"") } \
                         /=/ { \
                               split($1, nodeChars, ""); \
                               if (nodeChars[3] == "A" ) { \
                                  start[++a] = $1; \
                                  if ( d ) { printf("%d -> start: %s\n", a, start[a]); } \
                               } else if ( nodeChars[3] == "Z" ) { \
                                  end[++c] = $1; \
                                  if ( d ) { printf("%d -> end: %s\n", c, end[c]); } \
                               } \
                               L[$1]=$3; \
                               R[$1]=$4; \
                             } \
                         END { \
                               ctr=1; flag=0; \
                               for (b=1; b<=length(start); b++) { \
                                    res[b] = start[b]; \
                                    steps[b]=0; \
                                    if ( d ) { \
                                        printf("start: %s, res: %s, end: %s, steps: %d\n", start[b], res[b], end[b], steps[b]); \
                                    } \
                               } \
                               while(flag!=1) { \
                                 if (ctr>length(instr)) ctr=ctr%length(instr); \
                                 if (d) { \
                                    for (k=1;k<=length(res);k++) { \
                                        printf("node:%s -> instr(%d):%s :: ", res[k], ctr, instr[ctr]); \
                                    } \
                                    print(""); \
                                 } \
                                 if (instr[ctr] == "R") { \
                                     for (k=1; k<=length(res);k++) { \
                                          split(res[k], resultChars, ""); \
                                          if(resultChars[3]!="Z") { res[k]=R[res[k]]; steps[k]+=1 } \
                                     } \
                                 } else { \
                                     for (k=1; k<=length(res);k++) { \
                                          split(res[k], resultChars, ""); \
                                          if(resultChars[3]!="Z") { res[k]=L[res[k]]; steps[k]+=1 } \
                                     } \
                                 } \
                                 if (d) { for (k=1; k<=length(res);k++) printf("%s ", res[k]);  print(""); } \
                                 flag = 1; \
                                 for (k=1;k<=length(res);k++) { \
                                     split(res[k], resultChars, ""); \
                                     if (resultChars[3]!="Z") { flag=0; break; } \
                                     if (d) { printf("%d : %d :: ", k, steps[k]); } \
                                 } \
                                 if (d) { print(""); } \
                                 ctr+=1; \
                               }; \
                               if ( d ) { \
                                    for (k=1;k<=length(steps);k++) { \
                                         print(steps[k]) \
                                    } \
                               } \
                               result=steps[1]; \
                               for(k=2;k<=length(steps);k++) result=lcm(result,steps[k]) \
                               print result \
                             }'
