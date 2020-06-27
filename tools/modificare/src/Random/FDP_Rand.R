#require(plyr)

Rand_Multi_Rep <- function(Rand, fFM, cPopSize, Trials=10,
                  RandSeed=100, Par=FALSE)
{
    set.seed(RandSeed)
    Rand_Multi_Rep_real(Rand, fFM, cPopSize, Trials, RandSeed, Par)
}
Rand_Multi_Rep_real <- function(Rand, fFM, cPopSize, Trials=10,
                       RandSeed=100, Par=FALSE)
{
  #set.seed(RandSeed)
  
  ParamMatrix <- expand.grid(Rand=Rand, fFM=fFM, cPopSize=cPopSize,
                 Trials=Trials, stringsAsFactors=FALSE,
                 KEEP.OUT.ATTRS=FALSE)
  
  print(c("Configurarions to be executed: ", ParamMatrix))
  
    resDF <- adply(ParamMatrix, 1, function(pDF)
    { 
    print(c("Current configuration under execution: ", pDF))
    
    pList <- list(Rand=pDF$Rand, lFM=makeLogFM(read.table(pDF$fFM)),
             cPopSize=pDF$cPopSize)
    print(c("The List", ls(pList)))
    
    batchDF <- ldply(runif(pDF$Trials, 1, 1000), function(tSeed,
               argList)
    {
      argList$Seed  <- tSeed

      rTime <- system.time(expOut <- do.call(argList$Rand,
               args=argList[-1]))[[3]]
      
      expOut[[1]]  <- unname(expOut$Ord)    
      expOut$Runtime <- rTime
      
      theReturn <- data.frame(rbind(unlist(expOut)),
                   stringsAsFactors=FALSE)
      
      return(theReturn)    
    }, argList=pList, .parallel=Par)
    
    theReturn2 <- cbind(batchDF, fFM=pDF$fFM)
    print(c("Return2", theReturn2))
    
    return(theReturn2)
    }, .progress="text")

  return(resDF)
}

### Random search prioritization 
# lFM : "Logical" coverage matrix for ordering evaluation
# cPopSize : atomic numeric seed value
# Seed : atomc numeric value to set for random seed
Rand_POP <- function(lFM, cPopSize, Seed=100)
{
    set.seed(Seed)
    Rand_POP_real(lFM, cPopSize,Seed)
}
Rand_POP_real <- function(lFM, cPopSize, Seed=100)
{
  #print(RandomSeed)
    #set.seed(Seed)

    # The number of tests we are dealing with will be useful     
    nT <- ncol(lFM)

    # Create a matrix of random sequence samplings of length numTests
    #  column-bound
    Pop <- replicate(cPopSize, sample.int(nT))

    # Create a list of the fittness scores, corresponding to the
    # orderings This works nicely since the orderings are stored by
    # column 
    PopFit <- apply(Pop, 2, APFD, lFM=lFM)

    # Now find the best individual and best Fit score
    Best <- Pop[ , which.max(PopFit)]
    BestFit <- max(PopFit)

    # Return the best individual and it's Fit score
    return(list(Ord=Best, Fit=BestFit, Pri="Rand_POP", Conf=cPopSize,
           Seed=Seed))    
}

### Random search prioritization 
# lFM : "Logical" coverage matrix for ordering evaluation
# cPopSize : atomic numeric seed value
# Seed : atomc numeric value to set for random seed
Rand_POP_reduction <- function(lFM, cPopSize, Seed=100)
{
    set.seed(Seed)
    Rand_POP_reduction_real(lFM, cPopSize,Seed)
}
Rand_POP_reduction_real <- function(lFM, cPopSize, Seed=100)
{
  #print(RandomSeed)
    #set.seed(Seed)

    Best <- c()
    BestFit <- 0

    # Generate cPopSize reductions.
    for(i in 1:cPopSize)
    {
        # Perform the reduction.
        temp <- Rand_LIN_reduction_real(lFM)

        # If the reduction's fitness if greater than the current
        # best fitness, this reduction becomes the best.
        if(temp[[2]] > BestFit)
        {
            Best <- temp[[1]]
            BestFit <- temp[[2]]
        }
    }

    # Return the best individual and it's Fit score
    return(list(Ord=Best, Fit=BestFit, Pri="Rand_POP_reduction",
           Conf=cPopSize, Seed=Seed))    
}

# Random search that runs in linear time with respect to the number of
# test cases.
Rand_LIN <- function(lFM, cPopSize=NA, Seed=100)
{
    set.seed(Seed)
    Rand_LIN_real(lFM, cPopSize, Seed)
}
Rand_LIN_real <- function(lFM, cPopSize=NA, Seed=100)
{
    nT <- ncol(lFM)

    # If availableTestCases[i] = 1, test case i has not yet been added
    # to the prioritized ordering.
    availableTestCases <- seq(length=nT, from=1, by=0)

    # Fill the prioritized ordering with values.
    prioritizedOrdering <- c(1:nT)

    # Keeps track of the current position in the prioritized ordering.
    currentPosition <- 1

    # Loop until all test cases have been added.
    while(max(availableTestCases) == 1)
    {
        # Randomly select a possible test case.
        candidateTestCase <- sample(1:nT,1)
        
        # If this test case has not yet been selected.
        if(availableTestCases[candidateTestCase])
        {
            # Add this test case to the prioritized ordering.
            prioritizedOrdering[currentPosition] <- candidateTestCase

            # Move to the next position in the prioritized ordering.
            currentPosition <- currentPosition + 1

            # This test case is no longer available.
            availableTestCases[candidateTestCase] <- 0
        }
    }

    # Write the prioritized ordering to file.
    #write.table(prioritizedOrdering, file="prioritizedOrdering",
    # row.names=FALSE, col.names=FALSE)
    #return(prioritizedOrdering)
    return(list(Ord=prioritizedOrdering, Fit=APFD(prioritizedOrdering,
           lFM), Pri="Rand_LIN", Conf=cPopSize, Seed=Seed))
}

# Random search that runs in linear time with respect to the number of
# test cases.
Rand_LIN_reduction <- function(lFM, cPopSize=NA, Seed=100)
{
    set.seed(Seed)
    Rand_LIN_reduction_real(lFM,cPopSize,Seed)
}
Rand_LIN_reduction_real <- function(lFM, cPopSize=NA, Seed=100)
{
    numberOfTests <- ncol(lFM)
    numberOfRequirements <- nrow(lFM)

    # Requirements covered by the entire test suite.
    testSuiteReqs <- as.logical(rowSums(lFM))

    # Requirements covered by the reduced test suite.
    reducedReqs <- rep(0, numberOfRequirements)

    # Holds the reduced test suite.
    reducedSuite <- c()

    # If availableTestCases[i] = 1, test case i has not yet been added
    # to the prioritized ordering.
    availableTestCases <- seq(length=numberOfTests, from=1, by=0)

    # Loop until all test cases have been added.
    while(!identical(reducedReqs, testSuiteReqs))
    {
        # Randomly select a possible test case.
        candidateTestCase <- sample(1:numberOfTests,1)
        
        # If this test case has not yet been selected.
        if(availableTestCases[candidateTestCase])
        {
            # Add this test case to the reduction.
            reducedSuite <- c(reducedSuite, candidateTestCase)

            # This test case is no longer available.
            availableTestCases[candidateTestCase] <- 0

            # Re-calculate the requirements covered by the reduced
            # test suite.
            reducedReqs <- reducedReqs | lFM[,candidateTestCase]
        }
    }

    # Write the prioritized ordering to file.
    #write.table(prioritizedOrdering, file="prioritizedOrdering",
    # row.names=FALSE, col.names=FALSE)
    #return(prioritizedOrdering)
    return(list(Ord=reducedSuite, Fit=APFD(reducedSuite,lFM),
           Pri="Rand_LIN_reduction", Conf=cPopSize, Seed=Seed))
}
