######################################################################
#
# GreedyPrioritizer.R
#
# Implementation of the Additional Greedy prioritization algorithm.
#
# All of this code was either written by Zachary Douglas Williams or
# some other author and is taken from the kanonizo project.
#
# Modified by Jonathan Miller Kauffman.
#
######################################################################

############################################
#FUNCTION: GreedyPrioritizer()
#
#this function runs the greedy algorithm 
#and also calculates CE value 
#it returns them in a dataframe, Reqs
#
# This function with code written by 
# Zachary Douglas Williams in the 
# PerformGreedyPrioritizationOnProtect
# function.  Both codes are part of the 
# kanonizo project.
#
############################################

GRD <- function(coverageMatrixName, timingsFileName, seed=100)
{
    set.seed(seed)
    GRD_real(coverageMatrixName, timingsFileName)
}
GRD_real <- function(coverageMatrixName, timingsFileName)
{

    tempCoverageReport <- try(
        ConvertCoverageSummaryRandomMatrix(
            read.table(coverageMatrixName)),
               TRUE)
    #if the file does not exist skip everything else
    #if(tempCoverageReport[1] != "Error in file(file, \"rt\") : cannot
    #open the connection\n")    
        #{
      # extract timing info and put into temp data structure
      tempTimingInfo <- 
          subset(
            read.table(timingsFileName), 
            select=c("V1", "V2")) 
          
      # rename columns
      colnames(tempTimingInfo)<-c("Name", "Time")
    
      # rename all the tests, matching to numbers so the first test is
      # 1, then 2, etc.
      NameTTD <- c(1:(length(tempTimingInfo$Time)))

      tempTimingReport <- cbind(NameTTD, subset(tempTimingInfo,
                          select="Time"))

      # run prioritization (results contain new ce value and
      # prioritized test suite 
      tempResultsGreedy <- RunGreedyPrioritize(tempCoverageReport,
                           tempTimingReport)

      # extract prioritized ordering and reorder test names test 
      #write.table(tempResultsGreedy, file="prioritizedOrdering",
    #    row.names=FALSE,
    #    col.names=FALSE,
    #    quote=FALSE)
    #}
    return(list(Ord=tempResultsGreedy, Fit=APFD(tempResultsGreedy,
           makeLogFM(read.table(coverageMatrixName))), Pri="GRD"))    
    #return(tempResultsGreedy)
}

############################################
#FUNCTION: GreedyPrioritizer()
#
#this function runs the greedy algorithm 
#and also calculates CE value 
#it returns them in a dataframe, Reqs
#
# This function with code written by 
# Zachary Douglas Williams in the 
# PerformGreedyPrioritizationOnProtect
# function.  Both codes are part of the 
# kanonizo project.
#
############################################
GRD_reduction <- function(coverageMatrixName, timingsFileName,
                 seed=100)
{
    set.seed(seed)
    GRD_reduction_real(coverageMatrixName, timingsFileName)
}
GRD_reduction_real = function(coverageMatrixName, timingsFileName)
{

    tempCoverageReport <- try(
        ConvertCoverageSummaryRandomMatrix(
            read.table(coverageMatrixName)),
               TRUE)
    #if the file does not exist skip everything else
    #if(tempCoverageReport[1] != "Error in file(file, \"rt\") : 
    #cannot open the connection\n")    
        #{
      # extract timing info and put into temp data structure
      tempTimingInfo <- 
          subset(
            read.table(timingsFileName), 
            select=c("V1", "V2")) 
          
      # rename columns
      colnames(tempTimingInfo)<-c("Name", "Time")
    
      # rename all the tests, matching to numbers so the first test is
      # 1, then 2, etc.
      NameTTD <- c(1:(length(tempTimingInfo$Time)))

      tempTimingReport <- cbind(NameTTD, subset(tempTimingInfo,
                          select="Time"))

      # run prioritization (results contain new ce value and
      # prioritized test suite 
      tempResultsGreedy <- RunGreedyReduce(tempCoverageReport,
                           tempTimingReport)

      # extract prioritized ordering and reorder test names test 
      #write.table(tempResultsGreedy, file="prioritizedOrdering",
    #    row.names=FALSE,
    #    col.names=FALSE,
    #    quote=FALSE)
    #}
    return(list(Ord=tempResultsGreedy, Fit=APFD(tempResultsGreedy,
           makeLogFM(read.table(coverageMatrixName))),
           Pri="GRD_reduction"))    
    #return(tempResultsGreedy)
}


GRD_Multi_Rep <- function(GRD, fFM, fTF, Trials=10, Par=FALSE,
                 RandSeed=100)
{
    set.seed(RandSeed)
    GRD_Multi_Rep_real(GRD, fFM, fTF, Trials, Par)
}
GRD_Multi_Rep_real <- function(GRD, fFM, fTF, Trials=10, Par=FALSE)
{
  #set.seed(RandSeed)
  
  ParamMatrix <- expand.grid(fFM=fFM, GRD=GRD, fTF=fTF, Trials=Trials, 
        stringsAsFactors=FALSE, KEEP.OUT.ATTRS=FALSE)
  
  print(c("Configurarions to be executed: ", ParamMatrix))
  
    resDF <- adply(ParamMatrix, 1, function(pDF) 
  {
    print(c("Current configuration under execution: ", pDF))
  
    pList <- list(coverageMatrixName=pDF$fFM, timingsFileName=pDF$fTF,
             GRD=pDF$GRD)
    #print(c("The Param List", pList))
    
    batchDF <- ldply(runif(pDF$Trials, 1, 1000), function(tSeed,
               argList)
    {
      #argList$Seed <- tSeed
      rTime <- system.time(expOut <- do.call(argList$GRD, 
                                             args=argList[-3]))[[3]]
      
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


############################################
#FUNCTION: numberNotShared()
#
#this function compares 2 lists of requirements
#and finds the list of requirements shared it then
#then it takes the list of shared requirements and list 
#of the tests requirements and return the length of 
#the list of requirements the test has that ReducedReq 
#doesn't have 
#i.e. not shared
############################################

numberNotShared = function(reducedSuiteReq, testReq)
{

   #initialize shared lists
   shared <- c()

   #for each element in testR check if it is in ReducedReqsCovered
   #if so return that element and combind it with return value
   for (req in testReq)
   {
      shared <- c(shared,reducedSuiteReq[reducedSuiteReq == req]) 
   }
   
   #go through all the shared values
   #if a requirement is a shared value remove it
   #until all that is left is unshared values
   for (req in shared)
   {
      testReq <- testReq[(testReq != req)]
   }
   
   #return the length the the list which now only contains values
   #not in the reduced test suites requirements
   return(length(testReq))
}

############################################
#FUNCTION: orderRequirements()
#
#this function orders the unique requirements
#to get a list of the requirements covered
#
############################################
orderRequirements = function(Reqs)
{
   ReqsCovered <- sort(unique(Reqs$Requirements))
   return(ReqsCovered)
}

############################################
#FUNCTION: removeReducedTests()
#
#this function removes the tests in the reduced 
#test suite from the original test suite
#
############################################
removeReducedTests = function(Tests, ReducedTests) 
{   
   #initialized shared
   shared <- c()

   #go through Tests and find all values shareds with ReducedTests
   for (test in Tests)
   {
     shared <- c(shared,ReducedTests[ReducedTests == test]) 
   } 

   #remove reduced Tests  from origial suite
   for (test in shared)
   {
      Tests <- Tests[-(which(Tests==test))] 
   }

   return(Tests)
}

############################################
#FUNCTION: compairRequirements()
#
#this function compairs thelist of requirements 
#covered by the reduced test suite 
#to list of inital requirements coverd
#it returns 1 if they are equal
#(and exit the loop)
############################################
compairRequirements = function(reducedReq, initialReq)
{ 
   #initialized shared
   shared <- c()

   #go through initialReq and find all values shareds with reducedReq
   for (req in initialReq)
   {
     shared <- c(shared, reducedReq[reducedReq == req]) 
   } 

   #if the length of the shared requirements is equal to 
   #the length of inital requirements, all requirements 
   #are cover, return 1 which exits loop
   if(length(shared) == length(initialReq))
   {
      return(1)
   }
   return(2)  
}


############################################
#FUNCTION: findNewReq()
#
#this function gets the leftover requirements
#of the test still not prioritized
#
############################################
findNewReq = function(reqs, tempTests)
{
   totalReq <- c()
   for(tj in tempTests)
   {
      tjReq <- unlist(subset(reqs, reqs$NameCD==tj,
               select=Requirements))
 
      totalReq <- union(totalReq, tjReq)
   } 
   return(totalReq)
}

############################################
#FUNCTION: GreedyPrioritize()
#
#this function implements the greedy reduction algorithm
#with overlap checking
#
############################################
GreedyPrioritize = function(Reqs, Times)
{
   #initialize values
   ReqsCovered <- orderRequirements(Reqs)
   PrioritizedTests <- c()

   Tests  <- c(1:length(Times$NameTTD))

   i <- 0
   while(length(Tests)>=1)
   {
     # todo: remove after debug.
      i <- i + 1
      print(sprintf("Iteration %s,  length(Tests) == %s  in (while(length(Tests)>=1))", i, length(Tests)))

      #initialize values
      tempTests <-Tests    
      ReducedTests <- c()

      ReducedReqsCovered <- c()

      #get requirements of new test set
      ReqsCovered <- findNewReq(Reqs, tempTests)

      
      #handle tests with no requirements
      #in this implementation of the greedy algorithm all tests
      #with no requirements are simply appended on to the end
      #and are NOT ordered based on time
      if(length(ReqsCovered)==0)
      {
     #add the rest of the tests to the final list
     PrioritizedTests <- c(PrioritizedTests, tempTests) 

     #remove them from the list of tests
     Tests <- c()
      
      }

     j <- 0
     prev_req_covered <- 0
      while(
    (compairRequirements(ReducedReqsCovered, ReqsCovered) == 2) &
    (length(ReqsCovered) != 0))
      {
         #initialize Efficiency ratio to something very high
         # Jonathan Miller Kauffman - Made infinity because with
         # nanosecond timings, the timings were larger than the
         # "really big number".
         EfficiencyRatio <- Inf

        j <- j + 1

        if (prev_req_covered != length(ReqsCovered)) {
          prev_req_covered <- length(ReqsCovered)
          print(sprintf("inner loop iteration %s, length(ReqsCovered) == %s in (length(ReqsCovered) != 0),
            compairRequirements(ReducedReqsCovered, ReqsCovered) == %s in compairRequirements(ReducedReqsCovered, ReqsCovered) == 2) ",
                        j, length(ReqsCovered), compairRequirements(ReducedReqsCovered, ReqsCovered)))
        }

   
         goodTest <- c()
         goodTestReq <-c()

         for(ti in tempTests)
         {   
        #grab all of ti requirements
        tiReq <-subset(Reqs, NameCD==ti,
                select=c(Requirements))$Requirements

        #number of new tests
        #i.e. number of requirements ti has that reduced suite doesn't
        numberNew <- numberNotShared(ReducedReqsCovered, tiReq)
    
            if(numberNew >= 0)
            {

           #calculate EfficiencyRatio for specific test
           #if both the time and requirements covered is 0
           #arithmetic won't work so set ratio to inital ratio to
           #skip test
           if(Times$Time[ti]==0 & numberNew==0)
           {     
                 tiEfficiencyRatio <- EfficiencyRatio

           } else {

          #otherwise calculate that test's efficiency ratio
          tiEfficiencyRatio <-(Times$Time[ti] / numberNew)
           }



           #if this test's efficiency ratio is the lowest 
           #it becomes new best test
           if(EfficiencyRatio > tiEfficiencyRatio)
           {
              goodTest <- ti
              goodTestReq <-tiReq
              EfficiencyRatio <- tiEfficiencyRatio    
           }

            } else {
           #remove ti from list of tests 
           tempTests <- tempTests[-(which(tempTests==ti))]
            }    
         }    

         #add good test to set of reduced tests
         ReducedTests <- c(ReducedTests, goodTest)
   
    
         #add good test's requirements 
         ReducedReqsCovered <- union(ReducedReqsCovered, goodTestReq) 

      }

      #remove tests in reduced suite from original suite 
      Tests <- removeReducedTests(Tests, ReducedTests)
      
      #add reduced test set to total prioritized set
      PrioritizedTests <- c(PrioritizedTests, ReducedTests)
   }
   
   return(PrioritizedTests) 
}

############################################
#FUNCTION: GreedyReduce()
#
#this function implements the greedy reduction algorithm
#with overlap checking
#
############################################
GreedyReduce = function(Reqs, Times)
{
   #initialize values
   ReqsCovered <- orderRequirements(Reqs)
   PrioritizedTests <- c()

   Tests  <- c(1:length(Times$NameTTD))

   #while(length(Tests)>=1)
   #{
      #initialize values
      tempTests <-Tests    
      ReducedTests <- c()

      ReducedReqsCovered <- c()

      #get requirements of new test set
      ReqsCovered <- findNewReq(Reqs, tempTests)

      
      #handle tests with no requirements
      #in this implementation of the greedy algorithm all tests
      #with no requirements are simply appended on to the end
      #and are NOT ordered based on time
      if(length(ReqsCovered)==0)
      {
     #add the rest of the tests to the final list
     PrioritizedTests <- c(PrioritizedTests, tempTests) 

     #remove them from the list of tests
     Tests <- c()
      
      }

      while(
    (compairRequirements(ReducedReqsCovered, ReqsCovered) == 2) &
    (length(ReqsCovered) != 0))
      {
         #initialize Efficiency ratio to something very high
         # Jonathan Miller Kauffman - Made infinity because with
         # nanosecond timings, the timings were larger than the
         # "really big number".
         EfficiencyRatio <- Inf
   
         goodTest <- c()
         goodTestReq <-c()

         for(ti in tempTests)
         {   
        #grab all of ti requirements
        tiReq <-subset(Reqs, NameCD==ti,
                select=c(Requirements))$Requirements

        #number of new tests
        #i.e. number of requirements ti has that reduced suite doesn't
        numberNew <- numberNotShared(ReducedReqsCovered, tiReq)
    
            if(numberNew >= 0)
            {

           #calculate EfficiencyRatio for specific test
           #if both the time and requirements covered is 0
           #arithmetic won't work so set ratio to inital ratio to
           # skip test
           if(Times$Time[ti]==0 & numberNew==0)
           {     
                 tiEfficiencyRatio <- EfficiencyRatio

           } else {

          #otherwise calculate that test's efficiency ratio
          tiEfficiencyRatio <-(Times$Time[ti] / numberNew)
           }



           #if this test's efficiency ratio is the lowest 
           #it becomes new best test
           if(EfficiencyRatio > tiEfficiencyRatio)
           {
              goodTest <- ti
              goodTestReq <-tiReq
              EfficiencyRatio <- tiEfficiencyRatio    
           }

            } else {
           #remove ti from list of tests 
           tempTests <- tempTests[-(which(tempTests==ti))]
            }    
         }    

         #add good test to set of reduced tests
         ReducedTests <- c(ReducedTests, goodTest)
   
    
         #add good test's requirements 
         ReducedReqsCovered <- union(ReducedReqsCovered, goodTestReq) 

      }

      #remove tests in reduced suite from original suite 
      #Tests <- removeReducedTests(Tests, ReducedTests)
      
      #add reduced test set to total prioritized set
      #PrioritizedTests <- c(PrioritizedTests, ReducedTests)
   #}
   
   return(ReducedTests) 
}


############################################
#FUNCTION: RunGreedyPrioritize()
#
#this function runs the greedy algoritm 
#and also calculates CE value 
#it returns them in a dataframe, Reqs
#
############################################
RunGreedyPrioritize = function(Coverage, Timing)
{
   #run experiment
   PrioritizedTestSuite <- GreedyPrioritize(Coverage, Timing)

   #debugging statement
   #print(PrioritizedTestSuite)

   return(PrioritizedTestSuite)
}

############################################
#FUNCTION: RunGreedyReduce()
#
#this function runs the greedy algoritm 
#and also calculates CE value 
#it returns them in a dataframe, Reqs
#
############################################
RunGreedyReduce = function(Coverage, Timing)
{
   #run experiment
   ReducedTestSuite <- GreedyReduce(Coverage, Timing)

   #debugging statement
   #print(PrioritizedTestSuite)

   return(ReducedTestSuite)
}

# FUNCTION: This function converts the coverage data in the binary
# matrix format to the external format that is used by the Coverage
# Effectiveness (CE) calculator.
#
# From RandomlyGenerateTestSuite.R, don't know the author.
# Modified by Jonathan Miller Kauffman.
ConvertCoverageSummaryRandomMatrix = function(CoverageMatrix)
{

  # Remember that the tests are a column and the requirements are a
  # row.  So, we need to find out how many columns there are inside of
  # the input CoverageMatrix (also, the last column contains summary
  # information that we do not need to include in the coverage report)
  #
  # Jonathan Miller Kauffman - Although the comment said to account
  # for the summary row and column, the code did not.  Subtracted one
  # from the number of tests and requirements because of the summary
  # row and column.
  NumberOfTests = ncol(CoverageMatrix) - 1
  NumberOfRequirements = nrow(CoverageMatrix) - 1

  # make the vector that stores the names of the test cases
  NameCD = c()

  # make the vector that stores the names of the requirements
  Requirements = c()
  
  # go through each of the test cases and then look at its coverage   
  for( CurrentTestIndex in 1:NumberOfTests )
    {

      # extract the current test case information
      CurrentTestTooMuch = CoverageMatrix[,CurrentTestIndex]
      CurrentTest = CurrentTestTooMuch[1:NumberOfRequirements]
      
      # debugging information
      #print("Test")
      #print(CurrentTest)
      
      # go through each of the requirements 
      for( CurrentRequirementIndex in 1:NumberOfRequirements )
        {

          # extract the current requirement
          CurrentRequirement = CurrentTest[CurrentRequirementIndex]

          # we have found a 1 and we add to the coverage report
          if( CurrentRequirement == 1 )
            {

              # put the test case into the vector
              NameCD = c(NameCD, CurrentTestIndex)

              # put the requirement into the vector
              Requirements = c(Requirements, CurrentRequirementIndex)

            }

        }
      
    }

  return(data.frame(NameCD, Requirements))
  
}


