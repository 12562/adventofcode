

#awk -F '=' ' \
#function getSplit(str, outArr) { \
#    print(str); \
#    split(str, mapping, ":"); \
#    print(mapping[1], mapping[2]); \
#    split(mapping[2], outArr, ","); \
#} \
# \
#function getMappedVal(val, mapping) { \
#    out = val; \
#    for (loopVar in mapping) { \
#        split(mapping[loopVar], nums, ","); \
#        if ((val >= nums[2]) && (val <= nums[2]+nums[3]-1)) { \
#            out = nums[1] + val - nums[2]; \
#            break; \
#        } \
#    } \
#    return out; \
#} \
# \
#{ \
#    for (i=1; i<=8; i++) { \
#        print($i); \
#        getSplit($i, map[i]); \
#    } \
#    for (seed in map[1]) { \
#        result = map[1][seed]; \
#        for (j=2; j<=8; j++) { \
#            result = getMappedVal(result, map[j]); \
#        } \
#        location[seed] = result; \
#        printf("%d : %d\n", seed, location[seed]); \
#    } \
#} \
#'
                                              
#
#                                              split($2, soilmap, ":"); split(soilmap[2], soilmaprange, "@"); \
#                                              split($3, fertilmap, ":"); split(fertilmap[2], fertilmaprange, "@"); \
#                                              split($4, watermap, ":"); split(watermap[2], watermaprange, "@"); \
#                                              spilt($5, lightmap, ":"); split(lightmap[2], lightmaprange, "@"); \
#                                              split($6, tempmap, ":"); split(tempmap[2], tempmaprange, "@"); \
#                                              split($7, humidmap, ":"); split(humidmap[2], humidmaprange, "@"); \
#                                              split($8, locationmap, ":"); split(locationmap[2], locationmaprange, "@"); \
#                                              for (i=1; i<=length(seeds); i++) { \
#                                                   soil[i] = seeds[i]; \
#                                                   for (soilrange=1;soilrange<=length(soilmaprange);soilrange++) { \
#                                                        split(soilmaprange[soilrange], soilnums, ","); \
#                                                        if ((seeds[i] >= soilnums[2]) && (seeds[i] <= soilnums[2]+soilnums[3]-1)) { \
#                                                           soil[i] = soilnums[1]+seeds[i]-soilnums[2]; \
#                                                           break; \
#                                                        } \
#                                                   } \
#                                                   fertilizer[i] = soil[i]; \
#                                                   for (fertilrange=1;fertilrange<=length(fertilmaprange);fertilrange++) { \
#                                                        split(fertilmaprange[fertilrange], fertilnums, ","); \
#                                                        if ((soil[i] >= fertilnums[2]) && (soil[i] <= fertilnums[2]+fertilnums[3]-1)) { \
#                                                           fertilizer[i] = fertilnums[1]+soil[i]-fertilnums[2]; \
#                                                           break; \
#                                                        } \
#                                                   } \
#                                                   print(soilnums[1], soilnums[2], soilnums[3]); \
#                                                   for (i=0;i<soilnums[3];i++) { \
#                                                        soil[soilnums[2]+i]=soilnums[1]+i; \
#                                                        print(soilnums[2]+i, soil[soilnums[2]+i])
#                                                   } \
#                                              } \
#                                              for (fertilrange=1;fertilrange<=length(fertilmaprange);fertilrange++) { \
#                                                   split(fertilmaprange[soilrange], soilnums, ","); \
#                                                   print(soilnums[1], soilnums[2], soilnums[3]); \
#                                                   for (i=0;i<soilnums[3];i++) { \
#                                                        soil[soilnums[2]+i]=soilnums[1]+i; \
#                                                        print(soilnums[2]+i, soil[soilnums[2]+i])
#                                                   } \
#                                              } \
#                                          }'
cat $file | awk '/seeds:/ {val=""; for(i=1;i<=(NF-1)/2;i++){init=$(2*i); cnt=$(2*i+1);  for(j=init;j<init+cnt;j++){val = val " " j};} printf("seeds:%s\n", val)}; \!/seeds:/ {print; }' | sed '/map/ {:a;N;s/\n\([0-9]\)/@\1/g; ta}' | grep -v '^$' | sed 's/: /:/g' | sed ':a; N; s/\n/=/g; ta' | sed 's/ map:/:/g' | sed 's/ /,/g' | sed 's/:@/:/g'  | awk -F '=' -f script3.awk 
