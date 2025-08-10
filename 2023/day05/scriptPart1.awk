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

    # for each seed, apply mappings in order
    for (s = 1; s <= length(seeds); s++) {
        result = seeds[s]
        for (j = 1; j <= (NF - 1); j++) {
            result = getMappedVal(result, j)
        }
        loc[s] = result
    }
}

END {
      minLoc = loc[1]
      for (s = 2; s <= length(seeds); s++) {
          if ( loc[s] < minLoc ) {
             minLoc = loc[s];
          }
      }
      print(minLoc);
}
