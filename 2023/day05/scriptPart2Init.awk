BEGIN {
    FS = "="   # first split the line into mapping sections
}

# Split one mapping string into map[mapIndex, fieldIndex]
function getSplit(str, mapIndex,   entries, ecount, k) {
    gsub("@", " ", str)                 # replace '@' with space
    ecount = split(str, entries, " ")
    for (k = 1; k <= ecount; k++) {
        map[mapIndex, k] = entries[k]
    }
    mapCount[mapIndex] = ecount          # store how many entries in this mapping
}

# Given a value and mapping index, return mapped value
function getMappedVal(val, mappingIndex,   nums, k, out) {
    out = val
    for (k = 1; k <= mapCount[mappingIndex]; k++) {
        split(map[mappingIndex, k], nums, ",")
        if ((val >= nums[2]) && (val <= nums[2] + nums[3] - 1)) {
            out = nums[1] + val - nums[2]
            break
        }
    }
    return out
}

{
    # $1 is seeds:...
    # remove "seeds:" and split the list
    sub(/^seeds:/, "", $1)
    split($1, seeds, ",")

    # process the rest of the mappings
    for (i = 2; i <= NF; i++) {
        # remove the label before colon (e.g. "seed-to-soil:")
        sub(/^[^:]+:/, "", $i)
        getSplit($i, i-1)  # store in map index (i-1)
    }

    absMinLoc = 0;
    # for each seed, apply mappings in order
    for (seedGroup=0; seedGroup<length(seeds)/2; seedGroup++) {
        printf("Init: %d, Final: %d\n", 2*seedGroup+1, 2*(seedGroup+1));
        init = seeds[2*seedGroup+1];
        final = init + seeds[2*(seedGroup+1)] - 1;
        minLoc[seedGroup] = 0;
        printf("Init: %d, Final: %d\n", init, final);
        inc = 1;
        for (s = init; s <= final; s=s+inc) {
            result = s
            for (j = 1; j <= (NF - 1); j++) {
                result = getMappedVal(result, j)
            }

            if (s==init) {
               if ( seedGroup == 0 ) {
                  absMinLoc = result
               }
               minLoc[seedGroup] = result
               prevRes[seedGroup] = result
            } else {
               prevRes[seedGroup] = result
               if ( result <= absMinLoc ) {
                  absMinLoc = result;
                  inc = 1;
               } else if ( result <= minLoc[seedGroup] ) {
                  minLoc[seedGroup] = result;
                  inc = 1;
               } else {
                  inc += 1;
               }
            }
        }
        
        printf("MinLoc[%d]: %d\n", seedGroup, minLoc[seedGroup]);
    }
}

END {
      print(absMinLoc);
}
