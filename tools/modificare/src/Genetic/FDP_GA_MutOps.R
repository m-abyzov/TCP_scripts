#######################################
### MUTATION OPERATORS
######################################

# Displacement Mutation
# Select a random substring and reinserts it at random
MO_DM <- function(Ordering)
{
    # length of the ordering
    nT <- length(Ordering)
    # select a substring length
    tLength <- as.integer(runif(1, (nT / 4), (nT / 2)))
    # ...and start position
    tStart <- as.integer(runif(1, 1, (nT - tLength)))
    # sequence of the displaced indices
    displace <- c(tStart:(tStart+tLength))
    # a location to reinsert the string    
    insertPosition <- as.integer(runif(1, 0,
                      length(Ordering[-displace])))
    # now the actual work    
    t1 <- append(Ordering[-displace], Ordering[displace],
          insertPosition)
    
    return(t1)
}

# Exchange Mutation Operator (EM)
# Selects two random elements and swaps them
MO_EM <- function(Ordering)
{
    # always
    nT <- length(Ordering)
    # Pick two random positions to swap, sample to ensure unique
    swapPositions <- sample.int(nT, 2)
    # Initialize the new ordering to the old ordering
    t1 <- Ordering
    # Perform the swap of 2 elements
    t1[swapPositions] <- t1[rev(swapPositions)]

    return(t1)
}

# Insertion Mutation Operator (ISM)
# Removes a random element and re-inserts it at random
MO_ISM <- function(Ordering)
{
    # always
    nT <- length(Ordering)
    # Select the location to remove
    targetLoc <- as.integer(runif(1, 1, nT))
    # Pick a location to re-insert the element
    insertPoint <- as.integer(runif(1, 0, (nT - 1)))
    # append the target case at the insertpoint to the ordering 
    #  minus the target case
    t1 <- append(Ordering[-targetLoc], Ordering[targetLoc],
          insertPoint)
 
    return(t1)
}

# Inversion Mutation Operator (IVM)
# Functions in the same manner as DM, except the substring is inverted
MO_IVM <- function(Ordering)
{
    # length of the ordering
    nT <- length(Ordering)
    # select a substring length
    tLength <- as.integer(runif(1, (nT / 4), (nT / 2)))
    # ...and start position
    tStart <- as.integer(runif(1, 1, (nT - tLength)))
    # sequence of the displaced indices
    displace <- c(tStart:(tStart+tLength))
    # a location to reinsert the string    
    insertPosition <- as.integer(runif(1, 0,
                      length(Ordering[-displace])))
    # now the actual work    
    t1 <- append(Ordering[-displace], Ordering[rev(displace)],
          insertPosition)
    
    return(t1)

}

# Simple Inversion Mutation Operation (SIM)
# Functions as IVM, where the string of tests does not change location
MO_SIM <- function(Ordering)
{
    # Number of Tests in the ordering
    numberOfTests <- length(Ordering)

    # Number of tests to displace
    subStringLength <- sample(c((
        as.integer(numberOfTests/4)):(as.integer(numberOfTests/2))),
        1)

    # Random location to begin the displacement substring
    subStringLocation <- sample(c(1:(numberOfTests-subStringLength)),
                         1)

    # Initialize the new ordering 
    newOrder <- Ordering
    
    # now invert the substring
    newOrder[subStringLocation:(subStringLocation+subStringLength)] <-
        newOrder[rev(
        subStringLocation:(subStringLocation+subStringLength))]

    # Returning
    return(newOrder)
}

# Scramble Mutation Operator (SM)
# Randomly reorders a substring within an ordering
MO_SM <- function(Ordering)
{
    # Number of Tests in the ordering
    numberOfTests <- length(Ordering)

    # Number of tests to displace
    subStringLength <- sample(c((
        as.integer(numberOfTests/4)):(as.integer(numberOfTests/2))),
        1)

    # Random location to begin the displacement substring
    subStringLocation <- sample(c(1:(numberOfTests-subStringLength)),
    1)

    # Initialize the new ordering 
    newOrder <- Ordering
    
    # now invert the substring
    newOrder[subStringLocation:(subStringLocation+subStringLength)] <- 
        newOrder[sample(
        subStringLocation:(subStringLocation+subStringLength))]

    # Returning
    return(newOrder)
}

