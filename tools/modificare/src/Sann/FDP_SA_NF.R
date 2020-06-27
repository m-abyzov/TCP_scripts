# FirstSwapGenSANN - swaps a random position from the ordering with
# the first position As described in the kirklin thesis  
NF_FS <- function(Ordering)
{
	if(length(Ordering) == 1)
		return(Ordering)
  # Pick a random index (other than 1) in the ordering
    swapPosn <- as.integer(runif(1,2,length(Ordering)))

    Ordering[c(1, swapPosn)] <- Ordering[c(swapPosn, 1)]

    return(Ordering)
}


# LastSwapGenSANN - swaps a random position from the ordering with the
#  last position
#  As descrikirklin thesis  
NF_LS<- function(Ordering)
{
	if(length(Ordering) == 1)
		return(Ordering)
    nT <- length(Ordering)
    # Pick a random index (other than the last) in the ordering
    swapPosn <- as.integer(runif(1,1,(nT - 1)))

    # Generate a neighbor by swapping this position with the first
    # case
    Ordering[c(swapPosn, nT)] <- Ordering[c(nT, swapPosn)]

    return(Ordering)

    # Return the resulting neighbor
    return(Neighbor)
}


# FrontLoadedGenSANN - swaps test cases to produce a neighbor
# according to the front loaded neighbor generator described in the
# kirklin thesis
NF_FLS <- function(Ordering) 
{
	if(length(Ordering) == 1)
		return(Ordering)
    # random number for acceptance probability of an elements
    rand <- runif(1)
    # Determine one swap position
    Posn1 <- as.integer(runif(1, 1, (length(Ordering) - 1)))
    # Initiate the second posn to the last case
    Posn2 <- length(Ordering)
    
    probdenom<-numeric()

    # Iterate through each case, testing the acceptance prob
    for(Test in 1:length(Ordering))
    {
        probdenom <- (1/(2^Test))
        if(rand >= probdenom)
        {
            # Accept this test as the second position, break
            Posn2 <- Test
            break
        }
    }
    # Ensure the possibility of swapping with the last element
    if(Posn1 >= Posn2)
    {
        Posn1 <- Posn1 + 1
    }

    # Call the InOrdSwap to perform the swap
    Neighbor <-    InOrdSwap(Ordering, Posn1, Posn2)

    # Return the Result
    return(Neighbor)
}

# BackLoadGenSANN - swaps test cases to produce a neighbor according
# to the front loaded neighbor generator described in the kirklin
# thesis
NF_BLS <- function(Ordering) 
{
	if(length(Ordering) == 1)
		return(Ordering)
    # random number for acceptance probability of an elements
    rand <- runif(1)
    # Determine one swap position
    Posn1 <- as.integer(runif(1, 1, length(Ordering) - 1))
    # Initiate the second posn to the first test case
    Posn2 <- 1

    # Iterate through each case, testing the acceptance prob
    for(Test in length(Ordering):1)
    {
        if(rand >= (1 / (2^(length(Ordering)-Test))))
        {
            # Accept this test as the second position, break
            Posn2 <- Test
            break
        }
    }
    # Ensure the possibility of swapping with the last element
    if(Posn1 >= Posn2)
    {
        Posn1 <- Posn1 + 1
    }

    # Call the InOrdSwap to perform the swap
    Neighbor <- InOrdSwap(Ordering, Posn1, Posn2)

    # Return the Result
    return(Neighbor)
}


# InOrdSwap consumes an ordering and two Posns (indices), returns
# neighbor swaps these indices within the ordering, and returns the
# result. For use with SANN neighbor generators
InOrdSwap <- function(Ordering, Posn1, Posn2)
{
    # Swap the positions within this list
  Neighbor <- Ordering
  Neighbor[c(Posn1,Posn2)] <- Ordering[c(Posn2, Posn1)]
  return(Neighbor)

}
