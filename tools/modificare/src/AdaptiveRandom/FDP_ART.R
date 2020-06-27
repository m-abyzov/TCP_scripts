######################################################################
#
# ArtPrioritizer.R
#
# Implementation of the White Box Adaptive Random Testing (ART)
# prioritization algorithm.
#
# Jonathan Miller Kauffman
#
######################################################################

# The "main" method used to call the prioritizer.  This function takes
# a coverage matrix, similarity metric, and furthest away metric as
# arguments.
# 
# The coverage matrix is a binary matrix.
# The columns of the matrix should correspond to test cases while the
# rows of the matrix should correspond to requirements.  A 1 in
# position i,j means that test case i covers requirement j, while a 0
# means that test case i does not cover requirement j.
#
# The similarity metric is used to determine how close one test case
# is to another test case.  The available metrics are the Jaccard,
# Euclidean, Manhattan distances.
#
# The furthest away metric is used to determine which candidate test
# case is furthest away from all of the other test cases.  There are
# three possible values:
#    min - Use the test case with the largest minimum distance.
#    avg - Use the test case with the largest average distance.
#    max - Use the test case with the largest maximum distance.
ART <- function(matrixName, similarityMetric, furthestAwayMetric,
       seed=100)
{
    set.seed(seed)
    ART_real(matrixName, similarityMetric, furthestAwayMetric,seed)
}
ART_real <- function(matrixName, similarityMetric, furthestAwayMetric,Seed)
{
    # Read in the coverage matrix.
    #matrix <- read.table(matrixName)
	matrix <- matrixName
    
    # The number of tests and requirements.
    numberOfTests <- ncol(matrix) - 1
    numberOfRequirements <- nrow(matrix) - 1

    # Remove the summary row and column.
    matrix <- head(matrix, nrow(matrix) - 1)[-ncol(matrix)]

    # Keeps track of where the next test case should be added in the
    # prioritized ordering.
    currentTest <- 1

    # Contains the unprioritized ordering.
    untreatedOrdering <- seq(1:numberOfTests)

    # The prioritized ordering starts out empty.
    prioritizedOrdering <- numeric(0)
    
    # Keep looping until all of the test cases have been removed from
    # the original ordering.
    while(!identical(untreatedOrdering, integer(0)))
    {
        # A vector containing test cases that might be added to the
        # prioritized ordering.
        candidateSet <- generate(untreatedOrdering, matrix)

        # Select a test case in the candidate set that is furthest
        # away from all of the test cases in the prioritized ordering
        # using the furthest away metric.  If this is the first
        # iteration of this loop, there are no test cases in the
        # prioritized ordering, so randomly choose a test case from
        # the candidate set.
        if(currentTest == 1)
            testCase <- candidateSet[sample(1:length(candidateSet),1)]
        else
            testCase <- select(prioritizedOrdering, matrix,
                        candidateSet, similarityMetric,
                        furthestAwayMetric)

        # Remove the selected test case from the set of available
        # test cases.
        untreatedOrdering <-
            untreatedOrdering[untreatedOrdering != testCase]

        # Add the selected test case to the prioritized ordering.
        prioritizedOrdering[currentTest] <- testCase

        # Move to the next position in the prioritized ordering.
        currentTest <- currentTest + 1
    }

    # Write the prioritized ordering to file.
    #write.table(prioritizedOrdering, file="prioritizedOrdering",
    #row.names=FALSE, col.names=FALSE)
    return(list(Ord=prioritizedOrdering,Fit=APFD(prioritizedOrdering,
        makeLogFM(matrixName)), Pri="ART",
        SIM=similarityMetric, FAM=furthestAwayMetric,Seed=Seed))    
    #return(prioritizedOrdering)
}

# Modify ART slightly to make it a reducer.
ART_reduction <- function(matrixName, similarityMetric,
                 furthestAwayMetric, Seed=100)
{
    set.seed(Seed)
    ART_reduction_real(matrixName, similarityMetric,
        furthestAwayMetric,Seed)
}
ART_reduction_real <- function(matrixName, similarityMetric,
                      furthestAwayMetric, Seed)
{
    # Read in the coverage matrix.
    #matrix <- read.table(matrixName)
	matrix <- matrixName

    # Find the requirements covered by the entire test suite.
    testSuiteReqs <-
        as.logical(head(matrix, nrow(matrix) - 1)[[ncol(matrix)]])
    
    # The number of tests and requirements.
    numberOfTests <- ncol(matrix) - 1
    numberOfRequirements <- nrow(matrix) - 1

    # Initialize the requirements covered by the reduced test suite.
    reducedReqs <- rep(0,numberOfRequirements)

    # Remove the summary row and column.
    matrix <- head(matrix, nrow(matrix) - 1)[-ncol(matrix)]

    # Keeps track of where the next test case should be added in the
    # prioritized ordering.
    currentTest <- 1

    # Contains the unprioritized ordering.
    untreatedOrdering <- seq(1:numberOfTests)

    # The reduced test suite.
    reducedTestSuite <- numeric(0)
    
    # Keep looping until all of the test cases have been removed from
    # the original ordering.
    while((!identical(untreatedOrdering, integer(0))) &&
        !identical(as.logical(reducedReqs), testSuiteReqs))
    {
        # A vector containing test cases that might be added to the
        # prioritized ordering.
        candidateSet <- generate(untreatedOrdering, matrix)

        # Select a test case in the candidate set that is furthest
        # away from all of the test cases in the prioritized ordering
        # using the furthest away metric.  If this is the first
        # iteration of this loop, there are no test cases in the
        # prioritized ordering, so randomly choose a test case from
        # the candidate set.
        if(currentTest == 1)
            testCase <- candidateSet[sample(1:length(candidateSet),1)]
        else
            testCase <- select(reducedTestSuite, matrix, candidateSet,
                        similarityMetric, furthestAwayMetric)

        # Compute the requirements covered by the new reduced test
        # suite.
        newReqs <- matrix[testCase]
        reducedReqs <- reducedReqs | newReqs

        # Remove the selected test case from the set of available
        # test cases.
        untreatedOrdering <-
            untreatedOrdering[untreatedOrdering != testCase]

        # Add the selected test case to the prioritized ordering.
        reducedTestSuite[currentTest] <- testCase

        # Move to the next position in the prioritized ordering.
        currentTest <- currentTest + 1
    }

    # Write the prioritized ordering to file.
    #write.table(prioritizedOrdering, file="prioritizedOrdering",
    #row.names=FALSE, col.names=FALSE)
    return(list(Ord=reducedTestSuite, Fit=APFD(reducedTestSuite,
        makeLogFM(matrixName)), Pri="ART_reduction",
        SIM=similarityMetric, FAM=furthestAwayMetric,Seed=Seed))    
    #return(prioritizedOrdering)
}

ART_Multi_Rep <- function(ART, similarityMetric, furthestAwayMetric,
                 fFM, Trials=10, Par=FALSE, RandSeed=100)
{
    set.seed(RandSeed)
    ART_Multi_Rep_real(ART, similarityMetric, furthestAwayMetric, fFM,
        Trials, Par,RandSeed)
}
ART_Multi_Rep_real <- function(ART, similarityMetric,
                      furthestAwayMetric, fFM, Trials=10, Par=FALSE,RandSeed)
{
  #set.seed(RandSeed)
  ParamMatrix <- expand.grid(fFM=fFM, ART=ART,
                 similarityMetric=similarityMetric,
                 furthestAwayMetric=furthestAwayMetric, Seed=RandSeed, Trials=Trials, 
                 stringsAsFactors=FALSE, KEEP.OUT.ATTRS=FALSE)
  #print("here")
  print(c("Configurarions to be executed: ", ParamMatrix))
  
    resDF <- adply(ParamMatrix, 1, function(pDF) 
  {
    print(c("Current configuration under execution: ", pDF))
  
    pList <- list(matrixName=read.table(pDF$fFM),
             similarityMetric=pDF$similarityMetric,
             furthestAwayMetric=pDF$furthestAwayMetric, ART=pDF$ART,Seed=pDF$Seed)
    #print(c("The Param List", pList))
    
    batchDF <- ldply(runif(pDF$Trials, 1, 1000), function(tSeed,
               argList)
    {
      #argList$Seed <- tSeed
      rTime <- system.time(expOut <- do.call(argList$ART, 
                                             args=argList[-4]))[[3]]
      
      expOut[[1]] <- unname(expOut$Ord)
      expOut$Runtime <- rTime
      
      theReturn <- data.frame(rbind(unlist(expOut)),
        stringsAsFactors=FALSE)
      
      return(theReturn)
    }, argList=pList, .parallel=Par)
    
        return(cbind(batchDF, fFM=pDF$fFM))
  }, .parallel=Par, .progress="text")

    return(resDF)
}


# This method takes in the available test cases and the coverage
# matrix and returns a candidate set of vectors that can be added to
# the prioritized ordering.
generate <- function(untreatedOrdering, matrix)
{
    # The number of tests and requirements.
    numberOfTests <- ncol(matrix)
    numberOfRequirements <- nrow(matrix)
    
    # Contains the requirements covered by one test case.
    newRequirements <- rep(0, numberOfRequirements)

    # Contains the requirements covered by all test cases so far.
    totalRequirements <- rep(0, numberOfRequirements)

    # No test cases have been added to the candidate set yet.
    candidateSet <- numeric(0)

    # Keep adding test cases until adding the next test case would not
    # increase the number of requirements covered.  In theory this
    # could loop indefinitely.
    while(TRUE)
    {
        # Randomly choose a position in the untreated ordering.
        testCase <- sample(1:length(untreatedOrdering), 1)

        # Get the requirements covered by this test case from the
        # coverage matrix.  Note that since test cases may be removed
        # from anywhere in untreatedOrdering, position i does not
        # correspond to test case i.
        newRequirements <- matrix[[untreatedOrdering[testCase]]]
        
        # If this test case does not cover any new requirements,
        # return the candidate set.
        if(identical(totalRequirements | newRequirements,
            totalRequirements))
            return(candidateSet)
        
        # Recompute the total requirements covered.
        totalRequirements <- totalRequirements | newRequirements

        # Add this test case to the candidate set.
        candidateSet <- union(candidateSet,
            untreatedOrdering[testCase])
    }
}

# This method chooses a test case from the candidate set that is
# furthest away from all of the test cases in the prioritized ordering
select <- function(prioritizedOrdering, matrix, candidateSet,
          similarityMetric, furthestAwayMetric)
{
    # A matrix with one row for each test case in the prioritized
    # ordering and one column for each test case in the original
    # ordering.  A position i,j in the matrix contains the distance
    # from test case i to test case j.  As of right now, the distance
    # between two test cases is defined using the Jaccard distance.
    distanceMatrix <- as.data.frame(mat.or.vec(
                      length(prioritizedOrdering),
                      length(candidateSet)))

    # Fill the distance matrix with distances.
    for(i in 1:length(prioritizedOrdering))
        for(j in 1:length(candidateSet))
        {
            if(similarityMetric == "JaccardDistance")
                distanceMatrix[[j]][i] <-
                    JaccardDistance(prioritizedOrdering[i],
                    candidateSet[j], matrix)
            else if(similarityMetric == "EuclideanDistance")
                distanceMatrix[[j]][i] <-
                    EuclideanDistance(prioritizedOrdering[i],
                    candidateSet[j], matrix)
            else if(similarityMetric == "ManhattanDistance")
                distanceMatrix[[j]][i] <-
                    ManhattanDistance(prioritizedOrdering[i],
                    candidateSet[j], matrix)
        }
    
    # Choose the test case in the candidate set that is furthest away
    # from the test cases in the prioritized ordering.
    testCase <- FurthestTestCase(distanceMatrix, furthestAwayMetric)
    return(candidateSet[testCase])
}

# Returns the Jaccard distance between two test cases.  The Jaccard
# distance is defined by 1 - |A n B| / |A U B|.
JaccardDistance <- function(testCase1, testCase2, matrix)
{
    # Get the set of requirements covered by each test case from the
    # coverage matrix.
    requirements1 <- matrix[[testCase1]]
    requirements2 <- matrix[[testCase2]]

    # Compute the intersection of the requirements covered by each
    # test case.
    numerator <- sum(requirements1 & requirements2)

    # Compute the union of the requirements covered by each test case.
    denominator <- sum(requirements1 | requirements2)

    # Return the distance.
    if(denominator == 0)
        return(0)
    return(1 - (numerator / denominator))
}

# Returns the Euclidean distance between two test cases.  The
# Euclidean distance is defined as sqrt[(q1-p1)^2 +
# (q2-p2)^2 + ... + (qn-pn)^2].
EuclideanDistance <- function(testCase1, testCase2, matrix)
{
    # Get the set of requirements covered by each test case from the
    # coverage matrix.
    requirements1 <- matrix[[testCase1]]
    requirements2 <- matrix[[testCase2]]

    # Compute the Euclidean distance.
    return(sqrt(sum(abs(requirements1 - requirements2))))
}

# Returns the Manhattan distance between two test cases.  The
# Manhattan distance is like the Euclidean distance, except that a
# grid-like path must be followed. It is the the Euclidean distance
# squared in this context, and it will always be a nonnegative integer
ManhattanDistance <- function(testCase1, testCase2, matrix)
{
    # Get the set of requirements covered by each test case from the
    # coverage matrix.
    requirements1 <- matrix[[testCase1]]
    requirements2 <- matrix[[testCase2]]

    # Compute the Manhattan distance.
    return(sum(abs(requirements1 - requirements2)))
} 

# Determines which test case in the candidate set is furthest away
# from the test cases in the prioritized ordering.
FurthestTestCase <- function(distanceMatrix, furthestAwayMetric)
{
    # Choose the test case with the largest minimum distance.
    if(furthestAwayMetric == "min")
    {
        # The candidate test case with the largest minimum.
        max <- 1

        # The prioritized test case containing the largest minimum.
        maxMin <- 1

        # For each candidate test case.
        for(i in 1:ncol(distanceMatrix))
        {
            # Reset the position of the minimum distance.
            min <- 1

            # For each prioritized test case, if the distance
            # is smaller than the minimum distance, change
            # the minimum.
            for(j in 1:nrow(distanceMatrix))
                if(distanceMatrix[[i]][j] < distanceMatrix[[i]][min])
                    min <- j

            # If this is the largest minimum, record its position
            # in the matrix.
            if(distanceMatrix[[i]][min] >
                distanceMatrix[[max]][maxMin])
            {
                max <- i
                maxMin <- min
            }
        }

        # Return the candidate test case with the largest minimum.
        return(max)
    }
    # Choose the test case with the largest maximum distance.
    else if(furthestAwayMetric == "max")
    {
        # The candidate test case with the largest maximum.
        max1 <- 1

        # The prioritized test case containing the largest maximum.
        maxMax <- 1

        # For each candidate test case.
        for(i in 1:ncol(distanceMatrix))
        {
            # Reset the position of the maximum distance.
            max2 <- 1

            # For each prioritized test case, if the distance
            # is larger than the maximum distance, change
            # the maximum.
            for(j in 1:nrow(distanceMatrix))
                if(distanceMatrix[[i]][j] > distanceMatrix[[i]][max2])
                    max2 <- j

            # If this is the largest maximum, record its position
            # in the matrix.
            if(distanceMatrix[[i]][max2] >
                distanceMatrix[[max1]][maxMax])
            {
                max1 <- i
                maxMax <- max2
            }
        }

        # Return the candidate test case with the largest maximum.
        return(max1)
    }
    # Choose the test case with the largest average distance.
    else if(furthestAwayMetric == "avg")
    {
        # The candidate test case with the largest average.
        max <- 1

        # The largest average so far.
        maxAvg <- 0

        # For each candidate test case.
        for(i in 1:ncol(distanceMatrix))
        {
            # Reset the average.
            avg <- 0

            # Compute the average distance.
            for(j in 1:nrow(distanceMatrix))
                avg <- avg + distanceMatrix[[i]][j]
            avg <- avg / nrow(distanceMatrix)

            # If this is the largest average, record its position
            # in the matrix.
            if(avg > maxAvg)
            {
                max <- i
                maxAvg <- avg
            }
        }

        # Return the candidate test case with the largest minimum.
        return(max)
    }
}
