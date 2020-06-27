# Remove one test case neighborhood generator.
# Returns a columns bound matrix of orderings with NA values for
# removed test cases.
NG_RO <- function(Ordering)
{
    Neighborhood <- vapply(c(1:length(Ordering)), function(x)
        {
            # Initialize the neighbor to the Ordering
            Neighbor <- Ordering
            # Replace the removed test case with NA.
            Neighbor[x] <- NA

            return(Neighbor)
        }, FUN.VALUE=Ordering)

    return(Neighborhood)
}

# First swap neighbor generator
#  Returns column bound matrix of orderings
NG_FS <- function(Ordering) 
{
	if(length(Ordering) == 1)
	{
		Neighborhood <- Ordering
	}
  #print("NF_FS")
  ## Laply -> array of neighboring orderings by ROWS
	else
	{
  Neighborhood <- vapply(c(2:length(Ordering)), function(x) 
        {
            # Initialize the neighbor to the Ordering
            Neighbor <- Ordering
            # Swap the first position with the target
            Neighbor[c(1,x)] <- Neighbor[c(x,1)]

            return(Neighbor)
        }, FUN.VALUE=Ordering)
	}

    return(Neighborhood)
}

## Last swap neighborhood generator
#  Returns column bound matrix of orderings
NG_LS <- function(Ordering)
{
	if(length(Ordering) == 1)
	{
		Neighborhood <- Ordering
	}
	else
	{
    LastPosn <- length(Ordering) 
    
    Neighborhood <- vapply(c(1:(LastPosn - 1)), function(x)
    {
        # Initialize the neighbor to the Ordering
        Neighbor <- Ordering
        # Swap the last position with the target
        Neighbor[c(x, LastPosn)] <- Neighbor[c(LastPosn, x)]

        return(Neighbor)
    }, FUN.VALUE=Ordering)
	}

    return(Neighborhood)
}
