# require(plyr)
# HILLCLIMBING - First, Steepest, Random ascent
# See readme

# fFM : "logical" Fault matrix file location
# lFM : "logitcal Fault matrix in memory
# HC : Hillclimber :: HC_FA || HC_SA 
# NG :: Neighborhood generator :: NG_FS || NG_LS
# Trials :: Number of trials to run with a SINGLE CONFIGURATION
# Seed :: Random Seed value

# quoted string or numeric params, or sequence of these
# All permutations will be generated and executed
HC_Multi_Rep <- function(HC, fFM, NG, Trials=10, RandSeed=100,
                Par=FALSE)
{
    set.seed(RandSeed)
    HC_Multi_Rep_real(HC, fFM, NG, Trials, RandSeed, Par)
}
HC_Multi_Rep_real <- function(HC, fFM, NG, Trials=10, RandSeed=100,
                     Par=FALSE)
{
  #set.seed(RandSeed)
  
  ParamMatrix <- expand.grid(fFM=fFM, HC=HC, NG=NG, Trials=Trials, 
        stringsAsFactors=FALSE, KEEP.OUT.ATTRS=FALSE)
  
  print(c("Configurarions to be executed: ", ParamMatrix))
  
    resDF <- adply(ParamMatrix, 1, function(pDF) 
  {
    print(c("Current configuration under execution: ", pDF))
  
    pList <- list(lFM=makeLogFM(read.table(pDF$fFM)), HC=pDF$HC,
             NG=pDF$NG)
    #print(c("The Param List", pList))
    
    batchDF <- ldply(runif(pDF$Trials, 1, 1000), function(tSeed,
               argList)
    {
      argList$Seed <- tSeed

      rTime <- system.time(expOut <- do.call(argList$HC, 
                                             args=argList[-2]))[[3]]
      
      expOut[[1]] <- unname(expOut$Ord)
      expOut$Runtime <- rTime
      
      theReturn <- data.frame(rbind(unlist(expOut)),
                   stringsAsFactors=FALSE)
      
      return(theReturn)
    }, argList=pList, .parallel=FALSE)
    
        return(cbind(batchDF, fFM=pDF$fFM))
  }, .parallel=Par, .progress="text")

    return(resDF)
}

# Needs lFM, NG, Seed
# Returns list of Ord, Fit, TotalIt
HC_FA <- function(lFM, NG="NG_FS", Ord=NA, Seed=100)
{
    set.seed(Seed)
    HC_FA_real(lFM, NG, Ord, Seed)
}
HC_FA_real = function(lFM, NG="NG_FS", Ord=NA, Seed=100)
{    
  #set.seed(Seed)
  
    nT <- ncol(lFM)
  
  # If a starting Order is defined, use it, otherwise 
  #create a random starting location
  if(!is.na(Ord))
       CurrOrd <- Ord 
  else
     CurrOrd <- sample(1:nT)
 
 # Fitness value for the initial sequence
    CurrOrdFit <- APFD(Ord=CurrOrd, lFM)
  
  NumberOfIterations <- 0

    repeat 
    {
    OldOrd <- CurrOrd
        Neighborhood <- do.call(NG, list(Ordering=CurrOrd))
        
        for(i in 1:ncol(Neighborhood)) 
        {
      NeighborFit <- APFD(Neighborhood[,i], lFM)
            
            if(NeighborFit > CurrOrdFit) 
            {
                CurrOrdFit <- NeighborFit
                CurrOrd <- Neighborhood[,i]

                break
            }            
        }
        
        if(identical(CurrOrd, OldOrd))
            break

        NumberOfIterations <- NumberOfIterations + 1
    }
        
    return(list(Ord=CurrOrd, Fit=CurrOrdFit, Pri="HC_FA", Conf=NG,
    TotalIt=NumberOfIterations, Seed=Seed))    
}
HC_FA_reduction <- function(lFM, NG="NG_RO", Ord=NA, Seed=100)
{
    set.seed(Seed)
    HC_FA_reduction_real(lFM,NG,Ord,Seed)
}
HC_FA_reduction_real = function(lFM, NG="NG_FS", Ord=NA, Seed=100)
{ 
  #set.seed(Seed)
  
    nT <- ncol(lFM)
  
  # If a starting Order is defined, use it, otherwise 
  #create a random starting location
  if((!is.na(Ord))[1])
	{
		print("here")
       CurrOrd <- Ord
} 
  else
     CurrOrd <- sample(1:nT)

 
 # Fitness value for the initial sequence
    CurrOrdFit <- APFD(Ord=CurrOrd, lFM)
 # Initial number of requirements covered, used to determine if we can remove
 # a test case.
    InitReqsCov <- ReqsCovered(Ord=CurrOrd, lFM)
  
  NumberOfIterations <- 0

    repeat 
    {
    OldOrd <- CurrOrd
        Neighborhood <- do.call(NG, list(Ordering=CurrOrd))

		if(length(Neighborhood) == 1)
			break
        
        for(i in 1:ncol(Neighborhood)) 
        {
      NeighborFit <- APFD(Neighborhood[,i], lFM)
            
            if(NeighborFit > CurrOrdFit) 
            {
                CurrOrdFit <- NeighborFit
                CurrOrd <- Neighborhood[,i]

                break
            }            
        }

		# Remove a test case from the ordering.  Choose the first test case
		# if the first swap neighborhood generator is being used, and choose the
		# last test case if the last swap neighborhood generator is being used.
		if(NG == "NG_LS")
			ReducedCurrOrd <- CurrOrd[-length(CurrOrd)]
		else
			ReducedCurrOrd <- CurrOrd[-1]

		# Calculate requirements covered by the reduced ordering.
		NeighborReqs <- ReqsCovered(ReducedCurrOrd, lFM)

		# If removing the last test case doesn't change the number of
		# requirements covered, keep the reduced ordering.
		if(identical(InitReqsCov,NeighborReqs))
			CurrOrd <- ReducedCurrOrd
        
        if(identical(CurrOrd, OldOrd))
            break

        NumberOfIterations <- NumberOfIterations + 1
    }
        
    return(list(Ord=CurrOrd, Fit=CurrOrdFit, Pri="HC_FA_reduction", Conf=NG,
    TotalIt=NumberOfIterations, Seed=Seed))    
}   

## FDP_HCSA : Steepest-ascent hill climbing
#  Climbes the hill by evaluating each neighborhood and choosing the
#  most fit individual
HC_SA <- function(lFM, NG="NG_FS", Ord=NA, Seed=100)
{
    set.seed(Seed)
    HC_SA_real(lFM, NG, Ord, Seed)
}
HC_SA_real = function(lFM, NG="NG_FS", Ord=NA, Seed=100)
{
  #set.seed(Seed)
  
    nT <- ncol(lFM)
  
  # If a starting Order is defined, use it, otherwise create a random 
  #starting location
  if(!is.na(Ord))
       CurrOrd <- Ord
     else 
       CurrOrd <- sample.int(nT)
 
  # Fitness value for the initial sequence
    CurrOrdFit <- APFD(Ord=CurrOrd, lFM)
  
  NumberOfIterations <- 0
  
    repeat 
    {
    OldOrd <- CurrOrd
      
    Neighborhood <- do.call(NG, list(Ordering=CurrOrd))
    NeighborhoodFit <- apply(Neighborhood, 2, APFD, lFM)
    
    # Get the index of the ordering with greatest fitness
    BestNeighbor <- which.max(NeighborhoodFit)
    
        if(NeighborhoodFit[BestNeighbor] > CurrOrdFit)
        {
            CurrOrdFit <- NeighborhoodFit[BestNeighbor]
            CurrOrd <- Neighborhood[,BestNeighbor]
        }
        
        if(identical(CurrOrd, OldOrd))
        {
            break
        }
        
    # Keep track of the Iterations
        NumberOfIterations <- NumberOfIterations + 1
    }
    
    return(list(Ord=CurrOrd, Fit=CurrOrdFit, Pri="HC_SA", Conf=NG, 
    TotalIt=NumberOfIterations, Seed=Seed))
}

HC_SA_reduction <- function(lFM, NG="NG_FS", Ord=NA, Seed=100)
{
    set.seed(Seed)
    HC_SA_reduction_real(lFM, NG, Ord, Seed)
}
HC_SA_reduction_real = function(lFM, NG="NG_FS", Ord=NA, Seed=100)
{
  #set.seed(Seed)
  
    nT <- ncol(lFM)
  
  # If a starting Order is defined, use it, otherwise create a random 
  #starting location
  if(!is.na(Ord))
       CurrOrd <- Ord
     else 
       CurrOrd <- sample.int(nT)

# Initial number of requirements covered, used to determine if we can remove
 # a test case.
    InitReqsCov <- ReqsCovered(Ord=CurrOrd, lFM)
 
  # Fitness value for the initial sequence
    CurrOrdFit <- APFD(Ord=CurrOrd, lFM)
  
  NumberOfIterations <- 0
  
    repeat 
    {
    OldOrd <- CurrOrd
      
    Neighborhood <- do.call(NG, list(Ordering=CurrOrd))
	if(length(Neighborhood) == 1)
		NeighborhoodFit <- APFD(Neighborhood,lFM)
	else
    	NeighborhoodFit <- apply(Neighborhood, 2, APFD, lFM)
    
    # Get the index of the ordering with greatest fitness
    BestNeighbor <- which.max(NeighborhoodFit)
    
        if(NeighborhoodFit[BestNeighbor] > CurrOrdFit)
        {
            CurrOrdFit <- NeighborhoodFit[BestNeighbor]
            CurrOrd <- Neighborhood[,BestNeighbor]
        }

		# Remove a test case from the ordering.  Choose the first test case
		# if the first swap neighborhood generator is being used, and choose the
		# last test case if the last swap neighborhood generator is being used.
		if(NG == "NG_LS")
			ReducedCurrOrd <- CurrOrd[-length(CurrOrd)]
		else
			ReducedCurrOrd <- CurrOrd[-1]

		# Calculate requirements covered by the reduced ordering.
		NeighborReqs <- ReqsCovered(ReducedCurrOrd, lFM)

		# If removing the last test case doesn't change the number of
		# requirements covered, keep the reduced ordering.
		if(identical(InitReqsCov,NeighborReqs))
		{
			CurrOrd <- ReducedCurrOrd
		}
        
        if(identical(CurrOrd, OldOrd))
        {
            break
        }
        
    # Keep track of the Iterations
        NumberOfIterations <- NumberOfIterations + 1
    }
    
    return(list(Ord=CurrOrd, Fit=CurrOrdFit, Pri="HC_SA_reduction", Conf=NG, 
    TotalIt=NumberOfIterations, Seed=Seed))
}

# Random ascent hill climbing, described in ...
### Substitute a mutation operator for NG!!!!!!
HC_RA <- function(lFM, NG, Ord=NA, Seed)
{
    set.seed(Seed)
    HC_RA_real(lFM, NG, Ord, Seed)
}
HC_RA_real <- function(lFM, NG, Ord=NA, Seed)
{
  # Reproducibility
    #set.seed(Seed)
    
    # Number of Tests
    nT <- ncol(lFM)
    
    # Initialize the individual, calculate the fitness
    if(is.na(Ord))
    {
        CurrOrd <- sample.int(nT)
    } else 
    {
        CurrOrd <- Ord
    }

    CurrOrdFit <- APFD(CurrOrd, lFM)
          
    # Iteration Counter
    It <- 0
    LastItOfImprovement <- 0
    
    while(It < ItLimit)
    {
        # Choose a neigbor and evaluate its fitness
        Neighbor <- do.call(NG, list(Ordering=BestIndividual))
        NeighborFit <- APFD(Neighbor, lFM)
    
    # Move to the neighbor if it offers a fitness improvement
        if(NeighborFit > CurrOrdFit)
        {
            CurrOrd <- Neighbor
            CurrOrdFit <- NeighborFit
            LastItOfImprovement <- It
        }
        
        # Increment Iterations
        It <- It + 1
    }
    
    return(list(Ord=BestIndividual, Fit=BestIndividualFitness, 
            TotalIt=It, Seed=Seed))
    
}
