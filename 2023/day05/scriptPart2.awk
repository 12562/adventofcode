BEGIN {
    FS = "="   # first split the line into mapping sections
}

# Split one mapping string into map[mapIndex, fieldIndex]
function getSplit(str, mapIndex,   entries, ecount, k) {
    gsub("@", " ", str)                 # replace '@' with space
    ecount = split(str, entries, " ")
    for (k = 1; k <= ecount; k++) {
        tmpmap[k] = entries[k]
    }
    ecount2 = asort(tmpmap);
    #printf("Index: %d\n", mapIndex)
    for (k = 1; k <= ecount; k++) {
        map[mapIndex, k] = tmpmap[k]
        #print(map[mapIndex, k])
    }
    mapCount[mapIndex] = ecount          # store how many entries in this mapping
}

# Given a value and mapping index, return mapped value
function getMappedVal(val, mappingIndex,   nums, k, out) {
    out = val
    for (k = 1; k <= mapCount[mappingIndex]; k++) {
        split(map[mappingIndex, k], nums, ",")
        if ((val >= nums[1]) && (val <= nums[1] + nums[3] - 1)) {
            out = nums[2] + val - nums[1]
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

    for (i = 2; i <= NF; i++) {
        # remove the label before colon (e.g. "seed-to-soil:")
        sub(/^[^:]+:/, "", $i)
        getSplit($i, i)  # store in map index (i)
    }

    finalEntry = map[NF, mapCount[NF]]
    split(finalEntry, vals, ",")
    maxLoc = vals[1] + vals[3] - 1
    #printf("Max location: %d\n", maxLoc);
    inc = 1
    for (i = start; i >= 0; i = i - inc ) {
        result = i;
        #printf("i: %d -> ", result);
        for ( j = NF; j >= 2; j-- ) {
            result = getMappedVal(result, j)
            #printf("result: %d -> ", result);
        }
        #print("")
        flag = 0;
        for (seedGroup=0; seedGroup<length(seeds)/2; seedGroup++) {
            init = seeds[2*seedGroup+1];
            final = init + seeds[2*(seedGroup+1)] - 1;
            #printf("Init: %d, Final: %d\n", init, final);
            if ( result >= init && result <= final ) {
               flag = 1
               finalRes = i
            }
        }
        if ( flag == 0 ) {
           print(finalRes)
           exit(0)
        }
    }
    
}

