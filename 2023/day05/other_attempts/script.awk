
function getSplit(str, arr) { 
          split(str, map, ":"); 
          split(map[2], arr, ","); 
} 
  
function getMappedVal(inp, mapping) { 
      out = inp; 
      for (loopVar in mapping) { 
           split(mapping[loopVar], nums, ","); 
           if ((inp >= nums[2]) && (inp <= nums[2]+nums[3]-1)) { 
              out = nums[1]+inp-nums[2]; 
              break; 
           } 
      } 
      return out; 
} 

{ 
    for (i=1; i<=8; i++) {  
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
