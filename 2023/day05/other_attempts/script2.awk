function getSplit(str, outArr) {
    print(str);
    split(str, mapping, ":");
    print(mapping[1], mapping[2]);
    #split(mapping[2], outArr, ",");
}

function getMappedVal(val, mapping) {
    out = val;
    for (loopVar in mapping) {
        split(mapping[loopVar], nums, ",");
        if ((val >= nums[2]) && (val <= nums[2]+nums[3]-1)) {
            out = nums[1] + val - nums[2];
            break;
        }
    }
    return out;
}

{
    for (i=1; i<=8; i++) {
        print($i);
        getSplit($i, map[i]);
    }
    for (seed in map[1]) {
        result = map[1][seed];
        for (j=2; j<=8; j++) {
            result = getMappedVal(result, map[j]);
        }
        location[seed] = result;
        printf("%d : %d\n", seed, location[seed]);
    }
}
