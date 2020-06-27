
# Multi Criteria Observation Ratios
# Please investigate my efficiency
MCOR <- function(Ord, Observlist)
{   
    something <- sapply(Observlist, function(x, Ord)
      {
          # Assuming all CM are same dim
          nT <- ncol(x)
          nF <- nrow(x)

          reveal <- apply(x[,Ord], 1, function(y) {which(y)[1]})
       
          # calculate p
          pval <- sum(!is.na(reveal)) / nF
          
          # Calculate p - (SigmaReveal / nm)  
          fitscore <- pval - (sum(reveal, na.rm=TRUE) / (nT * nF)) +
            (pval / (2 * nT))

          return(fitscore)
      }, Ord=Ord)
    
      return(something)
  
}
