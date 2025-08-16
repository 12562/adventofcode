
                                 #      if ( ((diff[i] > 3) || (diff[i] < -3)) || ((diff[i] < 1) && (diff[i] > -1)) || ((consistency == 1) && diff[i] <((consistent[-1] > 0) && (consistent[1] > 0)) || (consistent[0] > 0) ) { \
                                 #       diff2 = ($(i+2) - $i); \
                                 #       abs2 = sqrt(diff2^2); \
                                 #       if ( ((abs2 <= 3) && (abs2 >= 1)) && (((consistent[1] == i) && (diff2 > 0))  || ((consistent[-1] == i) && (diff2 < 0))) && \!flag ) { \
                                 #          total = total-1; \
                                 #          if(d) { \
                                 #            printf("--<0: %d; >0: %d; check", consistent[-1], consistent[1]) \
                                 #          }; \
                                 #          flag=1 \
                                 #       } \
                                 #    }; \
                                 #     \
                                 #    if ( ((abs <= 3) && (abs >= 1))  ) { \
                                 #       withinlim++ \
                                 #    }; \
                                 #     \
                                 #    #if ((i == NF-2) && \!flag) { \
                                 #    #   total--; break; \
                                 #    #} \
                                 #}; \
                                 numsafe += safe \
                                  \
                                 #c = ((consistent[1]==total) || (consistent[-1]==total)); \
                                 #w = (withinlim>=total); \
                                 #if(d) { printf("=> Consistent:%d :: Withinlimit:%d ", c, w) }; \
                                 #if ( c && w ) { \
                                 #   numsafe++; \
                                 #   if(d) {printf("=> Safe\n")} \
                                 #} else { \
                                 #   if(d) {printf "=> Unsafe\n"} \
                                 #}; \
                                 #if(d) {printf("withinlim-%d:consistent[1]-%d:consistent[-1]-%d:c&&w-%d:Total-%d\n", withinlim, consistent[1], consistent[-1], c&&w, total)}; \
                                 #consistent[1]=0; \
                                 #consistent[-1]=0; \
                                 #withinlim=0; \
                                 #flag=0; \
                                 #if(d) {printf("\n")} \
