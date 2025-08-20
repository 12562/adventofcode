function subtract(arr, nCols, level, totalCols, start, part) {
         flag=1
         for (i=1; i<nCols; i++) {
             arr[level, i] = arr[level-1, i+1] - arr[level-1, i]
             if (arr[level, i] != 0 ) {
                flag = 0
             }
             if ( d ) { printf("%d ", arr[level, i])}
         }
         newStart = totalCols + 1
         totalCols = totalCols + nCols - 1
         if ( d ) { printf("; ") }
         if ( flag == 0 ) {
            result = subtract(arr, nCols-1, level+1, totalCols, newStart, part)
         } else {
            arr[level, i] = 0;
            arr[level, 0] = 0;
            if ( d ) { printf("Part : %d; ", part); }
            if ( part == 1 ) {
               result = extrapolate(arr, nCols, level-1, 0)
            } else {
               result = extrapolateBackwards(arr, nCols, level-1, 0)
            }
            if ( d ) { printf("<Result: %d>;", result) }
         }
         return result
} 

function extrapolate(arr, nCols, level, tmpRes) {
         arr[level, nCols+1] = arr[level, nCols] + arr[level+1, nCols]
         #printf("lvl:%d nCols:%d val:%d ::", level, nCols, arr[level, nCols+1])
         if ( level > 1 ) {
            tmpRes += extrapolate(arr, nCols+1, level-1, tmpRes)
            return tmpRes
         } else {
            if ( d ) { printf("Predicted value: %d; ", arr[level, nCols+1]) }
            return arr[level, nCols+1]
         }
}

function extrapolateBackwards(arr, nC, lvl, temporaryResult) {
         arr[lvl, 0] = arr[lvl, 1] - arr[lvl+1, 0]
         if ( lvl > 1 ) {
            temporaryResult += extrapolateBackwards(arr, nC+1, lvl-1, temporaryResult)
            return temporaryResult
         } else {
            if ( d ) { printf("Backwards Prediction: %d; ", arr[lvl, 0]) } 
            return arr[lvl, 0]
         }
}

{
   if ( d ) { printf($0); printf("; ") }
   for (i=1; i<=NF; i++ ) {
       arr[1, i] = $i
       arr2[1, i] = $i
   }
   part1Ans += subtract(arr, NF, 2, NF, 1, 1)
   part2Ans += subtract(arr2, NF, 2, NF, 1, 2)
   if ( d ) { print("") }
}
END {
      printf("Part 1: %d\n", part1Ans)
      printf("Part 2: %d\n", part2Ans)
}
         
