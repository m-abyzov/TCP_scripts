# FDP_GA.R
#
# A genetic algorithm.

#require(plyr)

# Using this function, we can execute the genetic algorithm in a wide
# variety of configurations and a number of trials.
GA_Multi_Rep <- function(fFM, GA="GA_real", cPopSize=100, cChildDens=0.2,
                cMutRate=0.2, CrossOp="CO_OX1", MutOp="MO_SIM",
                SelOp="SO_TRU", TransOp="TO_LIN", TermCond="TermStag",
                EndCond=25, Trials=10, RandSeed=100, Par=FALSE)
{
    set.seed(RandSeed)
    GA_Multi_Rep_real(fFM,GA,cPopSize,cChildDens,cMutRate,CrossOp,MutOp,
                      SelOp,TransOp,TermCond,EndCond,Trials,Par)
}
GA_Multi_Rep_real <- function(fFM, GA="GA_real", cPopSize=100, cChildDens=0.2,
                     cMutRate=0.2, CrossOp="CO_OX1", MutOp="MO_SIM",
                     SelOp="SO_TRU", TransOp="TO_LIN",
                     TermCond="TermStag", EndCond=25, Trials=10,
                     Par=FALSE) 
{
    #set.seed(RandSeed)

  ParamMatrix <- expand.grid(fFM=fFM, GA=GA, cPopSize=cPopSize,
                 cMutRate=cMutRate, cChildDens=cChildDens,
                 CrossOp=CrossOp, MutOp=MutOp, SelOp=SelOp,
                 TransOp=TransOp, Trials=Trials, 
                 stringsAsFactors=FALSE, KEEP.OUT.ATTRS=FALSE)
  
  print(c("Configurations to be executed:", ParamMatrix))
  
    resDF <- adply(ParamMatrix, 1, function(pDF)
  {
    print(c("Current configuration under execution: ", pDF))
    
    pList <- as.list(pDF[-c(1,10)])
    pList$lFM <- makeLogFM(read.table(pDF$fFM))
    
    batchDF <- ldply(runif(pDF$Trials, 1, 1000),
               function(tSeed, argList)
    {
      argList$Seed <- tSeed
      print("Arg List")
      print(argList[1])
      rTime <- system.time(expOut <- do.call(argList$GA,
               args=argList[-1]))[[3]]
      
      expOut[[1]] <- unname(expOut$Ord)
      expOut$Runtime <- rTime
      
      theReturn <- data.frame(rbind(unlist(expOut)),
                   stringsAsFactors=FALSE)
      
      return(theReturn)
    }, argList=pList, .parallel=Par)
    
    return(cbind(batchDF, fFM=pDF$fFM))
  }, .progress="text")
  
    return(resDF)
}

# Genetic based prioritization, single run
# lFM, 
# TransOp, SelOp, CrossOp, MutOp, 
# cPopSize, cChildDens, cMutRate
# TermCond, TermConds(targExecTime, targTotalIt, targStagIt)
# Seed
GA <- function(lFM, cPopSize=100, cChildDens=0.2, cMutRate=0.2,
               CrossOp="CO_OX1", MutOp="MO_SIM", SelOp="SO_TRU",
               TransOp="TO_LIN", TermCond="TermStag", EndCond=25,
               Seed=100)
{
    set.seed(Seed)
    GA_real(lFM,cPopSize,cChildDens,cMutRate,CrossOp,MutOp,SelOp,
            TransOp,TermCond,EndCond,Seed)
}
GA_real <-function(lFM, cPopSize=100, cChildDens=0.2, cMutRate=0.2,
          CrossOp="CO_OX1", MutOp="MO_SIM", SelOp="SO_TRU",
          TransOp="TO_LIN", TermCond="TermStag", EndCond=25, Seed)
{
  #set.seed(Seed)
    nT <- ncol(lFM)
  
    # Generate an initial population, compute fitness, find elites
    Pop <- replicate(cPopSize, sample.int(nT))
    PopFit <- apply(Pop, 2, APFD, lFM)
  BestFit <- max(PopFit)
    Best <- Pop[,which.max(PopFit)]
  
  # Compute Constants
    cParentSize <- as.integer((cChildDens*cPopSize))
    cChildSize <- as.integer((cPopSize*cChildDens))
    cMutSize <- as.integer((cMutRate*cPopSize))
  
  TermList <- list(Epoch=proc.time()[3], currExecTime=0, currStagIt=0, 
                   currTotalIt=0, EndCond=EndCond)
  
    while(do.call(TermCond, args=TermList))
  {
        # Get TransFits, do selection, get children
        TransFit <- do.call(TransOp, args=list(PopFit))
        iParents <- do.call(SelOp, args=list(TransFit, cParentSize))
        
    # Get children, target for mutation, perform mutation
    Children <- GetChildren(Pop, iParents, CrossOp=CrossOp)
        iTargetMuts <- sample(1:cChildSize, cMutSize)
        Children[,iTargetMuts] <- apply(Children[,iTargetMuts], 2,
            function(x) 
      { 
        do.call(MutOp, args=list(x))
      })
        dimnames(Children) <- NULL
    
        # Get Child fit, select survivors, construct population, 
        # get fitness
        iSurvive <- sample(1:ncol(Pop), (ncol(Pop) - cChildSize))
    Pop <- cbind(Children, Pop[,iSurvive])
        PopFit <- apply(Pop, 2, APFD, lFM)

    # Examine The best individuals in the pop, update term conds
        if(max(PopFit) <= BestFit)  
      {    
          TermList$currStagIt <- TermList$currStagIt + 1
        PopFit[which.min(PopFit)] <- BestFit
        Pop[,which.min(PopFit)] <- Best
      } else
    {
        TermList$currStagIt <- 0    
    }
        BestFit <- max(PopFit)
  
        Best <- Pop[,which.max(PopFit)]

        TermList$currTotalIt <- TermList$currTotalIt + 1
        TermList$currExecTime <- proc.time()[3] - TermList$Epoch
    }
    return(list(Ord=Best, Fit=BestFit, cPopSize=cPopSize,
           cChildDens=cChildDens, cMutRate=cMutRate, CrossOp=CrossOp,
           MutOp=MutOp, SelOp=SelOp, TransOp=TransOp,
           TermCond=TermCond, EndCond=EndCond,
           TotalIt=TermList$currTotalIt, StagIt=TermList$currStagIt, 
           Seed=Seed))
}

# Genetic based reduction, single run
# lFM, 
# TransOp, SelOp, CrossOp, MutOp, 
# cPopSize, cChildDens, cMutRate
# TermCond, TermConds(targExecTime, targTotalIt, targStagIt)
# Seed
GA_reduction <- function(lFM, cPopSize=100, cChildDens=0.2, cMutRate=0.2,
               CrossOp="CO_OX1", MutOp="MO_SIM", SelOp="SO_TRU",
               TransOp="TO_LIN", TermCond="TermStag", EndCond=25,
               Seed=100)
{
    set.seed(Seed)
    GA_reduction_real(lFM,cPopSize,cChildDens,cMutRate,CrossOp,MutOp,SelOp,
            TransOp,TermCond,EndCond,Seed)
}
GA_reduction_real <-function(lFM, cPopSize=100, cChildDens=0.2, cMutRate=0.2,
          CrossOp="CO_OX1", MutOp="MO_SIM", SelOp="SO_TRU",
          TransOp="TO_LIN", TermCond="TermStag", EndCond=25, Seed)
{
  #set.seed(Seed)
    nT <- ncol(lFM)
  
    # Generate an initial population, compute fitness, find elites
    Pop <- replicate(cPopSize, sample.int(nT))
    PopFit <- apply(Pop, 2, APFD, lFM)
  BestFit <- max(PopFit)
    Best <- Pop[,which.max(PopFit)]

    InitReqsCov <- ReqsCovered(Ord=Best, lFM)
	lastTest <- length(Best)
  
  # Compute Constants
    cParentSize <- as.integer((cChildDens*cPopSize))
    cChildSize <- as.integer((cPopSize*cChildDens))
    cMutSize <- as.integer((cMutRate*cPopSize))
  
  TermList <- list(Epoch=proc.time()[3], currExecTime=0, currStagIt=0, 
                   currTotalIt=0, EndCond=EndCond)
  
    while(do.call(TermCond, args=TermList))
  {
        # Get TransFits, do selection, get children
        TransFit <- do.call(TransOp, args=list(PopFit))
        iParents <- do.call(SelOp, args=list(TransFit, cParentSize))
        
    # Get children, target for mutation, perform mutation
    Children <- GetChildren(Pop, iParents, CrossOp=CrossOp)
        iTargetMuts <- sample(1:cChildSize, cMutSize)
        Children[,iTargetMuts] <- apply(Children[,iTargetMuts], 2,
            function(x) 
      { 
        do.call(MutOp, args=list(x))
      })
        dimnames(Children) <- NULL
    
        # Get Child fit, select survivors, construct population, 
        # get fitness
        iSurvive <- sample(1:ncol(Pop), (ncol(Pop) - cChildSize))
    Pop <- cbind(Children, Pop[,iSurvive])
        PopFit <- apply(Pop, 2, APFD, lFM)

    # Examine The best individuals in the pop, update term conds
        if(max(PopFit) <= BestFit)  
      {    
          TermList$currStagIt <- TermList$currStagIt + 1
        PopFit[which.min(PopFit)] <- BestFit
        Pop[,which.min(PopFit)] <- Best
      } else
    {
        TermList$currStagIt <- 0    
    }
        BestFit <- max(PopFit)
  
        Best <- Pop[,which.max(PopFit)]

		# Remove a test case from the ordering.  Choose the first test case
		# if the first swap neighborhood generator is being used, and choose the
		# last test case if the last swap neighborhood generator is being used.
		#if(NG == "NG_LS")
			ReducedBest <- c(Best[-lastTest],NA)
			lastTest <- lastTest - 1
		#else
		#	ReducedBest <- Best[-1]

		# Calculate requirements covered by the reduced ordering.
		NeighborReqs <- ReqsCovered(ReducedBest, lFM)

		# If removing the last test case doesn't change the number of
		# requirements covered, keep the reduced ordering.
		if(identical(InitReqsCov,NeighborReqs))
		{
			Best <- ReducedBest
		}

        TermList$currTotalIt <- TermList$currTotalIt + 1
        TermList$currExecTime <- proc.time()[3] - TermList$Epoch
    }
    return(list(Ord=Best[!is.na(Best)], Fit=BestFit, cPopSize=cPopSize,
           cChildDens=cChildDens, cMutRate=cMutRate, CrossOp=CrossOp,
           MutOp=MutOp, SelOp=SelOp, TransOp=TransOp,
           TermCond=TermCond, EndCond=EndCond,
           TotalIt=TermList$currTotalIt, StagIt=TermList$currStagIt, 
           Seed=Seed))
}

GetChildren <- function(Pop, cParents, CrossOp) 
{ 
    byTwo <- seq(from=1, to=(length(cParents) - 1), by=2)
      
    # apply the cross op to each pair of parents sequentially 
    childPop <- sapply(byTwo, function(x, CO) {return(do.call(CO, 
        list(Pop[,x], Pop[,(x+1)])))}, CrossOp, simplify=FALSE)

  childPop <- matrix(unlist(childPop), nrow=nrow(Pop),
              ncol=(length(cParents)))

    return(childPop)
}
