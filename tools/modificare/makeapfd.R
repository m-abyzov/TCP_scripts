
makeaprc <- function(inDat, inlFM) {
  
  sep <- which(colnames(inDat) == "Sep")
  
  ord <- inDat[,c(1:(sep-1))]
  
  detectScore <- apply(ord, 1, APFD, lFM=makeLogFM(inlFM))

  covScore <- inDat[,"Fit"]
    
  outdf <- cbind(subset(inDat, select=-c(Fit)), APRC=covScore,
           APFD=detectScore)
  
  return(outdf)
}
