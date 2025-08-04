#! /usr/bin/tcsh 
set file = $1
set debug = $2

cat $file | awk -v d=$debug '{total = NF-1; for (i=1;i<NF;i++) { diff = ($(i+1) - $i); if(d) {printf("%d ", diff)}; consistent[diff < 0]++; abs = sqrt(diff^2); if ( (abs <= 3) && (abs >= 1)  ) { withinlim++}} ; c=((consistent[0]==total) || (consistent[0]==0)); w = (withinlim==total); if(d) {printf("=> Consistent:%d :: Withinlimit:%d ", c, w)}; if ( c && w) {numsafe++; if(d) {printf("=> Safe\n")}} else { if(d) {printf "=> Unsafe\n"}}; if(d) { printf("%d:%d:%d\n", withinlim, consistent[0], c&&w)};consistent[0]=0; consistent[1]=0; withinlim=0;} END {printf("Part 1 : %d\n", numsafe) }'


 cat $file | awk -v d=$debug '{  if(d) {print $0}; \
                                 delete consistent \
                                 delete diffmagnitude \
                                 if(d) {printf("Diff: ")}; \
                                 for (i=1;i<NF;i++) { \
                                     diff[i] = ($(i+1) - $i); \
                                     absdiff = sqrt(diff[i]^2); \
                                     if(d) {printf("%d ", diff[i])}; \
                                     if (diff[i] < 0) { \
                                        consistent[-1]++ \
                                        posNeg[consistent[-1]] = i \
                                        if ( (absdiff > 3) || (absdiff < 1)) { \
                                           diffmagnitude[-1]++ \
                                           posNegMag[diffmagnitude[-1]] = i \
                                        } \
                                     } else if (diff[i] == 0) { \
                                        consistent[0]++ \
                                        posZer[consistent[0]] = i \
                                     } else { \
                                        consistent[1]++ \
                                        posPos[consistent[1]] = i \
                                        if ( (absdiff > 3) || (absdiff < 1)) { \
                                           diffmagnitude[1]++ \
                                           posPosMag[diffmagnitude[1]] = i \
                                        } \
                                     }; \
                                 } \
                                 if(d) {printf("\nconsistent[-1]: %d, consistent[0]: %d, consistent[1]: %d\n", consistent[-1], consistent[0], consistent[1])}; \
                                 if(d) {printf("\n +ve diffmagnitude: %d, -ve diffmagnitude: %d\n", diffmagnitude[1], diffmagnitude[-1])}; \
                                 if ( consistent[1] > 1 ) { \
                                    if ( ((consistent[-1] > 1) || (consistent[0] > 1) || (consistent[-1] + consistent[0] + diffmagnitude[1] + diffmagnitude[-1] > 1))) { \
                                       if ( (consistent[-1] == 1) && (diffmagnitude[1] == 1) && (consistent[0] == 0) && (diffmagnitude[-1] == 0) && (((posNeg[1] - posPosMag[1])^2) == 1) ) { \
                                          safe = 0; \
                                          consistency = 1; \
                                          magnitude = -1; \
                                       } else { \
                                          safe = 0; \
                                          consistency = 0 \
                                       } \
                                    } else { \
                                       consistency = 1 \
                                       if ((diffmagnitude[1] > 1) || (diffmagnitude[-1] > 1)) { \
                                          magnitude = 0; \
                                          safe = 0; \
                                       } else if ((diffmagnitude[1] == 1 && diffmagnitude[-1] == 0) || (diffmagnitude[-1] == 1 && diffmagnitude[1] == 0)) { \
                                          safe = 0; \
                                          magnitude = -1; \
                                       } else { \
                                          magnitude = 1; \
                                          if (consistent[-1] == 1) { \
                                             safe = 0; \
                                          } else if ((diffmagnitude[1] + diffmagnitude[-1] > 1)) { \
                                             safe = 0; \
                                          } else { \
                                             safe = 1; \
                                          } \
                                       } \
                                    } \
                                 } else if (consistent[-1] > 1 ) { \
                                    if ( ((consistent[1] > 1) || (consistent[0] > 1) || (consistent[1] + consistent[0] + diffmagnitude[1] + diffmagnitude[-1] > 1))) { \
                                       if ( (consistent[1] == 1) && (diffmagnitude[-1] == 1) && (consistent[0] == 0) && (diffmagnitude[1] == 0) && (((posPos[1] - posNegMag[1])^2) == 1) ) { \
                                          safe = 0; \
                                          consistency = -1; \
                                          magnitude = -1; \
                                       } else { \
                                          safe = 0; \
                                          consistency = 0; \
                                       } \
                                    } else { \
                                       consistency = -1; \
                                       if ((diffmagnitude[1] > 1) || (diffmagnitude[-1] > 1) ) { \
                                          magnitude = 0; \
                                          safe = 0; \
                                       } else if ((diffmagnitude[1] == 1 && diffmagnitude[-1] == 0) || (diffmagnitude[-1] == 1 && diffmagnitude[1] == 0)) { \
                                          safe = 0; \
                                          magnitude = -1; \
                                       } else { \
                                          magnitude = 1; \
                                          if (consistent[1] == 1) { \
                                             safe = 0; \
                                          } else if ((diffmagnitude[1] + diffmagnitude[-1] > 1)) { \
                                             safe = 0; \
                                          } else { \
                                             safe = 1; \
                                          } \
                                       } \
                                    } \
                                 } else if ( consistent[0] > 1 ) { \
                                    safe = 0; \
                                    consistency = 0; \
                                 } else { \
                                    if (d) { print("Invalid input, consistency numbers are questionable..."); } \
                                 } \
                                  \
                                 if(d) {printf("Consistency: %d, Magnitude: %d, Safe: %d\n", consistency, magnitude, safe)}; \
                                  \
                                 if ( (consistency != 0) && (magnitude != 0) && (safe == 0) ) { \
                                    if ((magnitude == -1) ) { \
                                       if (consistency == 1) { \
                                          if ((consistent[-1] == 0) && ((diff[1] > 3) || (diff[1] < 1))) { \
                                             safe = 1; \
                                          } else if ((consistent[-1] == 0) && ((diff[NF-1] > 3) || (diff[NF-1] < 1))) { \
                                             safe = 1; \
                                          } else { \
                                             safe = 0; \
                                             for (i=1;i<NF;i++) { \
                                                 if ( !((i+1) in diff) ) { \
                                                    diff[i+1] = 0; \
                                                 } \
                                                  \
                                                 if ((diff[i] > 3) && (((diff[i-1] < 0) && (diff[i-1] + diff[i] <= 3) && (diff[i] + diff[i-1] >= 1)) || ((diff[i+1] < 0) && (diff[i+1] + diff[i] <= 3) && (diff[i] + diff[i+1] >= 1))) )  { \
                                                    safe = 1; \
                                                    break; \
                                                 } \
                                             } \
                                          } \
                                       } else { \
                                          if ((consistent[1] == 0) && ((diff[1] < -3) || (diff[1] > -1))) { \
                                             safe = 1; \
                                          } else if ((consistent[1] == 0) && ((diff[NF-1] < -3) || (diff[NF-1] > -1))) { \
                                             safe = 1; \
                                          } else { \
                                             safe = 0; \
                                             for (i=1;i<NF;i++) { \
                                                 if ( !((i+1) in diff) ) { \
                                                    diff[i+1] = 0; \
                                                 } \
                                                  \
                                                 if ((diff[i] < -3) && (((diff[i-1] > 0) && (diff[i-1] + diff[i] >= -3) && (diff[i] + diff[i-1] <= -1)) || ((diff[i+1] > 0) && (diff[i+1] + diff[i] >= -3) && (diff[i] + diff[i+1] <= -1))) )  { \
                                                    safe = 1; \
                                                    break; \
                                                 } \
                                             } \
                                          } \
                                       } \
                                    } else { \
                                       if (consistency == 1) { \
                                          if ((diff[1] < 0) || (diff[NF-1] < 0)) { \
                                             safe = 1; \
                                          } else { \
                                             for (i=2;i<NF-1;i++) { \
                                                 if ((diff[i] < 0) && ((diff[i-1] + diff[i] > 0) || (diff[i] + diff[i+1] > 0)) ) { \
                                                    safe = 1; \
                                                    break; \
                                                 } \
                                             } \
                                          } \
                                       } else { \
                                          if ((diff[1] > 0) || (diff[NF-1] > 0)) { \
                                             safe = 1; \
                                          } else { \
                                             for (i=2;i<NF-1;i++) { \
                                                 if ((diff[i] > 0) && ((diff[i-1] + diff[i] < 0) || (diff[i] + diff[i+1] < 0)) ) { \
                                                    safe = 1; \
                                                    break; \
                                                 } \
                                             } \
                                          } \
                                       } \
                                    } \
                                 } \
                                 if(d) {printf("Final safe value: %d\n\n\n", safe)}; \
                                 numsafe += safe; \
                              } \
                              END { \
                                 printf("Part 2 : %d\n", numsafe) \
                              }'
