################################################
########### Crossover Operators
################################################
# Order Crossover (OX1) p.22
CO_OX1<- function(Par1, Par2)
{
    # Number of tests
    nT <- length(Par1)

    # Random Length, start point, calculate end point
    cpLength <- sample((nT/4):(nT/2), 1)
    cpStart <- sample(1:(nT-cpLength), 1)
    cpEnd <- cpStart + cpLength

    # The tests between the cut points are in the front of the vector
    #    followed by all others AFTER WRAPPING AROUND THE PARENT
    t1 <- c(Par1[cpStart:cpEnd], setdiff(c(Par2[-(0:cpEnd)], 
        Par2[0:cpEnd]), Par1[cpStart:cpEnd]))
    t2 <- c(Par2[cpStart:cpEnd], setdiff(c(Par1[-(0:cpEnd)], 
        Par1[0:cpEnd]), Par2[cpStart:cpEnd]))

    # Move the proper number of tests from the tail to the head
    t1 <- c(t1[-(0:((nT-cpStart)+1))], t1[0:((nT-cpStart)+1)])
    t2 <- c(t2[-(0:((nT-cpStart)+1))], t2[0:((nT-cpStart)+1)])

    theReturn <- list(t1[], t2[])
  
    dimnames(theReturn) <- NULL
    
    return(theReturn)
}


# Order Based Crossover
CO_OX2 <- function(Par1, Par2)
{
    nT <- length(Par1)
    
    # Initialize the return vectors to NA, makes it easier
    t1 <- rep(NA, nT)
    t2 <- rep(NA, nT)
    
    #Select some target Posns
    tarPosns <- sample(1:nT, as.integer(runif(1, (nT / 4), (nT / 2))))
    
    # Find the cases at these posns for the 2nd parent
    tarCases <- Par2[tarPosns]    
    # Get the positions of the same cases in the first parent
    parMatch <- Par1 %in% tarCases
    # Copy all but those positions
    t1[!parMatch] <- Par1[!parMatch]
    # Fill the remaining positions in the order they appear 2nd parent
    t1[is.na(t1)] <- setdiff(Par2, t1)
    
    # Repeat to construct child2, reversing the roles of the parents
    tarCases <- Par1[tarPosns]
    parMatch <- Par2 %in% tarCases
    t2[!parMatch] <- Par2[!parMatch]
    t2[is.na(t2)] <- setdiff(Par1, t2)
    
    # Construct a nice return
    theReturn <-list(t1, t2)
    dimnames(theReturn) <- NULL

    return(theReturn)
}

# Maximum Preservative Crossover
CO_MPX <- function(Par1, Par2)
{
    nT <- length(Par1)
    
    # Deciding on a subsection
    cpLength <- as.integer(runif(1, (nT/4), (nT/2)))
    cpStart <- as.integer(runif(1, 1, (nT - cpLength)))
    cpEnd <- cpStart + cpLength
    
    # Copy the subsection from Parent2 (subsection appears at
    # beginning of child)
    t1 <- Par2[cpStart:cpEnd]
    # Fill the rest in the order they appear in the first parent
    t1 <- c(t1, setdiff(Par1, t1))

    # Repeat, reversing parent roles for the second child
    cpLength <- as.integer(runif(1, (nT/4), (nT/2)))
    cpStart <- as.integer(runif(1, 1, (nT - cpLength)))
    cpEnd <- cpStart + cpLength

    t2 <- Par1[cpStart:cpEnd]
    t2 <- c(t2, setdiff(Par2, t2))

    # Construct a nice return
    theReturn <- list(t1, t2)
    dimnames(theReturn) <- NULL

    return(theReturn)
}

# Position Based Crossover
CO_POS <- function(Par1, Par2)
{    
    # number of test cases
    nT <- length(Par1)
    
    # Initialize the return vectors to NA
    t1 <- t2 <- rep(NA, nT)

    # Select the positions to preserve across both children.  
    tarPosns <- sample(1:nT, as.integer(runif(1, (nT / 4), (nT / 2))))
    
    # Copy over the elements that are preserved
    t1[tarPosns] <- Par1[tarPosns]
    # Fill in NAs with the remaining cases in the order they appear
    # in P2
    t1[is.na(t1)] <- setdiff(Par2, t1)

    #repeat for the second child
    t2[tarPosns] <- Par2[tarPosns]
    t2[is.na(t2)] <- setdiff(Par1, t2)

    # Construct a nice return
    theReturn <- list(t1, t2)
    dimnames(theReturn) <- NULL

    return(theReturn)    
}

# Voting Recombination Crossover
CO_VR <- function(Par1, Par2)
{    
    # Number of test cases
    nT <- length(Par1)
        
    # Initialize the return vectors to NA
    t1 <- t2 <- rep(NA, nT)
    
    # Find the cases which are in the same position in both parents
    # and copy them into the children
    t1[Par1 == Par2] <- t2[Par1 == Par2] <- Par1[Par1 == Par2]
    
    # Copy in the remaining cases
    t1[is.na(t1)] <- sample(setdiff(1:nT, t1))
    t2[is.na(t2)] <- sample(setdiff(1:nT, t2))

    # Construct a nice return
    theReturn <- list(t1, t2)
    dimnames(theReturn) <- NULL

    return(theReturn)
}


  
