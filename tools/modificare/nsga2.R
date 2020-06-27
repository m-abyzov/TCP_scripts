
#MutOp, SelOp, CrossOp, cPopSize, FMlist, 
# cChildDens, cMutRate
nsga2 <- function(pEnv) {
  nT <- ncol(FMlist[1])
  
  Pop <- replicate(cPopSize, sample(c(1:nT)))
	PopFit <- apply(Pop, 2, MCOR, ObservList=FMlist)
  
  
  
  
  TotalIt <- 0
  
  iParents <- do.call(pEnv$SelOp, list(TransFit, cParentSize))
  Children <- GetChildren(Pop, iParents, CrossOp=pEnv$CrossOp)
  iTargetMuts <- sample(1:cChildSize, cMutSize)
  Children[,iTargetMuts] <- apply(Children[,iTargetMuts], 2,
    function(x) { do.call(pEnv$MutOp, list(x))})
	dimnames(Children) <- NULL
  
  
  while(TotalIt < 20)
  {
    
  
  
    TotalIt <- TotalIt + 1
  }
}

## Fast Non-Dominated Sort (cPopSize x metrics) matrix
fnds <- function(PopFit)
{
  work <- cbind(PopFit, n=0, front=0)
  cPS <- nrow(PopFit)
  n <- numeric(cPS)
  S <- vector("list", cPS)
  i <- 1
  Fronts <- vector("list")
  
  for(p in c(1:cPS)) {
    for(q in c(1:cPS)[-p]) {
      if((FALSE %in% (PopFit[p,] > PopFit[q,])) == FALSE) {
        S[[p]] <- c(S[[p]], q)
      } else if((FALSE %in% (PopFit[q,] > PopFit[p,])) == FALSE) {
        work[p, "n"] <- work[p, "n"] + 1 
      }
    }
  }

  currFront <- which(work[, "n"] == 0)
  tn <- work[, "n"]

  while(length(currFront) > 0) {
     work[currFront, "front"] <- i
     H <- numeric()
     
     for(p in currFront) {
      for(q in S[[p]]) {
       tn[q] <- tn[q] - 1
       if(tn[q] == 0) {
        H <- c(H, q)
       }
      }
     }
     i <- i + 1
     currFront <- H
  }
  return(work)
}

## Crowding Distance Assignment 
## inset :: Matrix
## Fit, ..., Fit, rank
cda <- function(inSet) 
{
 nP <- nrow(inSet)
 work <- cbind(inSet, dist=0)
 
 for(m in 1:(ncol(inSet) - 2)) {
  work <- work[order(work[ ,m]), ]
  work[1, "dist"] <- work[nP, "dist"] <- Inf
  
  for(i in c(2:(nP - 1))) {
    work[i, "dist"] <- work[i, "dist"] +
        ((work[(i+1), m]) - (work[(i-1), m]))  
  }
 }
 return(work)
}

## Crowding Comparison Operator
cco <- function(Pop)
{
  return(Pop[order(Pop[,"front"], Pop[,"dist"]), ])
}
