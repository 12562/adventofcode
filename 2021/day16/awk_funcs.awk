function add(a) {
  sum = 0
  for ( i in a ) 
      sum += a[i]
  return sum
}

function mult(a) {
  prod = 1
  for ( i in a ) 
      prod *= a[i]
  return prod
}

function min(a) {
  mi = a[1]
  for ( i in a ) {
     if ( a[i] < mi ) {
        mi = a[i]
     }
  }
  return mi
}
      
function max(a) {
  m = a[1]
  for ( i in a ) {
     if ( a[i] > m ) {
        m = a[i]
     }
  }
  return m
}
      
function gt(a) {
  if ( a[1] > a[2] ) {
     return 1
  } else {
     return 0
  }
}

function lt(a) {
  if ( a[1] < a[2] ) {
     return 1
  } else {
     return 0
  }
}

function eq(a) {
  if ( a[1] == a[2] ) {
     return 1
  } else {
     return 0
  }
}

