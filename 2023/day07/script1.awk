
function compare(i1, str1, i2, str2, l, r) {
    split(str1, a, ",")
    num1 = split(toupper(a[1]), l, "")
    split(str2, b, ",")
    num2 = split(toupper(b[1]), r, "")
    strength["A"] = 14 
    strength["K"] = 13 
    strength["Q"] = 12 
    strength["J"] = 11 
    strength["T"] = 10 
    strength["9"] = 9 
    strength["8"] = 8 
    strength["7"] = 7 
    strength["6"] = 6 
    strength["5"] = 5 
    strength["4"] = 4 
    strength["3"] = 3 
    strength["2"] = 2 
    for ( n=1; n<=5; n++ ) { 
        if ( d ) {
           printf("l: %s - %d, n: %s - %d\n", l[n], strength[l[n]], r[n], strength[r[n]])
        }
        if ( strength[l[n]] > strength[r[n]] ) { 
           return -1; 
        } else if ( strength[l[n]] < strength[r[n]] ) { 
           return 1; 
        } else { 
           continue; 
        } 
    } 
    return 0;
} 

function giverank(startrank, arr) {
    if ( length(arr) == 1 ) {
       split(arr[1], a, ",")
       arr[1] = a[1] "," a[2] "," startrank
       return startrank - 1
    } else {
       asort(arr, result, "compare")
       for (m=1; m<=length(result); m++) {
           if ( d ) {
              printf("After sort: %s\n", result[m])
           }
           split(result[m], vals, ",")
           arr[m] = vals[1] "," vals[2] "," startrank - m + 1
       }
       return startrank - length(result)
    }
# if ( length(arr) == 2 ) {
#       split(arr[1], a, ",")
#       split(arr[2], b, ",")
#       res = compare(a[1], b[1])
#       if ( res == 1 ) {
#          arr[1] = a[1] "," a[2] "," startrank
#          arr[2] = b[1] "," b[2] "," startrank - 1
#       } else {
#          arr[1] = a[1] "," a[2] "," startrank - 1
#          arr[2] = b[1] "," b[2] "," startrank
#       }
#       return startrank - 2
#    } else {
#       for (i=1; i<length(arr); i++) {
#            split(arr[i], a, ",")
#            for (j=i+1; j<=length(arr); j++) {
#                split(arr[j], a, ",")
#                result[j] = compare(a[1], b[1])
#            }
#                
          

}

function computetype(str, type, val, totalElems) {
    nextrank = totalElems;
    name[1] = "fiveofakind"
    name[2] = "fourofakind"
    name[3] = "fullhouse"
    name[4] = "threeofakind"
    name[5] = "twopair"
    name[6] = "onepair"
    name[7] = "highcard"
    sum = 0;
    for (i=1; i<=7; i++) {
        ctr = 1;
        delete arr;
        if ( d ) {
           printf("%d, %s\n", i, name[i])
        }
        for (j=1; j<=totalElems; j++) {
            if ( type[j] == name[i] ) {
               arr[ctr] = str[j] "," val[j] "," 0
               if ( d ) {
                  printf("%s\n", arr[ctr]);
               }
               ctr++;
            }
        }
        if ( length(arr) == 0 ) {
           continue;
        }
        nextrank = giverank(nextrank, arr);
        for (k=1; k<=length(arr); k++) {
            split(arr[k], vals, ",")
            if ( d ) {
               printf("%s : %d : %d\n", vals[1], vals[2], vals[3])
            }
            sum += vals[2] * vals[3];
        } 
        if ( d ) {
           printf("i value: %d, %s\n", i, name[i])
        }
    }
    return sum;
}

{ 
   delete seen;
   if ( d ) {
       print("")
   }
   for (i=1;i<=5;i++) { 
        if ( d ) {
           print($i)
        }
        seen[$i]++; 
        str[FNR] = str[FNR] $i
   } 
    
   val[FNR] = $6 
   fiveofkind = 0;
   fourofkind = 0;
   threeofkind = 0;
   twoofkind = 0;
   oneofkind = 0;
   for (key in seen) { 
        if ( d ) {
            printf("%s : %d\n", key, seen[key])
        }
        if (seen[key]==5){ 
            fiveofkind=1 
        } else if (seen[key]==4) { 
            fourofkind=1 
        } else if(seen[key]==3) { 
            threeofkind=1 
        } else if (seen[key]==2) { 
            twoofkind+=1 
        } else { 
            oneofkind+=1 
        } 
   } 
   if ( d ) {
      printf("5kind:%d ; 4kind:%d ; 3kind:%d; 2kind:%d; 1kind:%d\n", fiveofkind, fourofkind, threeofkind, twoofkind, oneofkind); 
   }
   if ( fiveofkind ) { 
      type[FNR] = "fiveofakind" 
   } else if ( fourofkind && oneofkind ) { 
      type[FNR] = "fourofakind" 
   } else if ( threeofkind && (twoofkind==1) ) { 
      type[FNR] = "fullhouse" 
   } else if ( threeofkind && (oneofkind==2) ) { 
      type[FNR] = "threeofakind" 
   } else if ( (twoofkind==2) && (oneofkind==1) ) { 
      type[FNR] = "twopair" 
   } else if ( (twoofkind==1) && (oneofkind==3) ) { 
      type[FNR] = "onepair" 
   } else { 
      type[FNR] = "highcard" 
   } 
} 

END { 
      for (i=1; i<=NR; i++ ) { 
           num[type[i]] += 1; 
           if ( d ) {
               printf("%d : %s : %s : %d\n", i, str[i], type[i], val[i]); 
           }
      }
      print(computetype(str, type, val, NR))
}      
