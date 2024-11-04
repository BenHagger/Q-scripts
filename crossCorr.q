crossCorr: {[s1; s2] / input two series of the same length
/ the basic formula for cross correlation is given as 
/ R_xy(k) = sum_n { x[n] * y[n + k]  }    
/ 

    if[not count s1 ~ count s2 ;  / if our series are not the same length, do not proceed
        :"Series unequal lengths"]; / early return if condition is met
    / else compute cross corr
    
        / the lag we want to iterate through will loook something like 
        / if len(array) = 4,    lag =  -3 -2 -1 0 1 2 3  
        / yes, we can lag 4 times, however this just yields a null in all cases, so we take it out by dropping the first element
    lag: 1_ (til 2* count s1) - count s1 ; /equivalent to ( linspace(0, len(s2)) - len(s2)  )[1:]   , i.e. generate integer indexes, centre on 0, cut first element

        
        / for s1 and s2, successively apply a cut of each lag to the array. we will have a list of lists containing
        / s1[0]
        / s1[0], s1[1]
        / s1[0], s1[1], s1[2]
        / ......
        / s1[n-2], s1[n-1], s1[n]
        / s1[n-1], s1[n]
        / s1[n]
        / this is why we reflected about zero, to inverse the structure of the loop and feed every index into the next transformation in one go .
    
    / as we are then computing cross correlation, we are actually just flipping s2, taking the product of the new series, and summing the results (dot product), we then lag (techincally we lag one array and pad, however, why pad with a zero and add a computation when you can simply cut...
    /   _\: takes each element from the lag array and drops from s1. think of it as the inbuilt version of 
    /    {[i] i _ s1}each lag
    lagged_s1: lag _\: s1 ;  / re-structure array into shape seen in commented code above
    lagged_s2: reverse lag _\: s2;  / same as above but after achieving shape, turn upside down (inverse order of elements in array)

    / multiply and sum, result is a list of floats denoting the cross correlation of the two arrays

    / early return before computation to prevent error:
if[ 0 = lagged_s1 * lagged_s2 ; :"division by zero: all terms in both series are zeros"];

    sum each lagged_s1 * lagged_s2  / multiply the now-vertical arays element wise, but only sum by row - as to keep the shape . each element of new list is a cross correlation for a certain lag of the two original series

}

x: 0.1 0.2 -0.1 4.1 -2 1.5 -0.1
y: 0.1 4 -2.2 1.6 0.1 0.1 0.2


crossCorr[x ;y ]
normCrossCorr:{[s1 ; s2]  crossCorr[s1;s2]%( sqrt sum s1 * s1 ) * (sqrt sum s2 * s2) } / normalise movements by autocorrelation of each series at lag 0
normCrossCorr[x; y]



cosSim:{[s1; s2]
    numerator: sum s1*s2;
    denominator: ( sqrt sum s1 * s1 ) * (sqrt sum s2 * s2);
    numerator%denominator
}
cosSim[x; y]
