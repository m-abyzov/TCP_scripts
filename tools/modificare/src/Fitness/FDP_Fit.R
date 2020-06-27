## Convert a KM fault matrix logical format, remove summary column
makeLogFM <- function(FM)
{
  FM <- as.matrix(FM)
  somevar<- apply(FM[-nrow(FM), -ncol(FM)], 2, as.logical) 
  return(somevar)
}

## (N) APFD Calculator
APFD <- function(Ord, lFM)
{
  #Number of Tests
  FbyT <- dim(lFM)

  # Handle the case when there is only one test case in a reduction.
  if(length(Ord) == 1)
  {
    # Since there is only one test case, it is the first test case to reveal
    # all the faults that it reveals.
    reveal <- lFM[,Ord]
    reveal <- as.numeric(reveal)
    # Change all 0 values to NA.
    # NOTE: The original author of this function claims that for loops are less
    # efficient than apply, but this article suggests otherwise:
    # http://stackoverflow.com/questions/1504832/help-me-replace-a-for-loop-with-an-apply-function
    for(x in 1:length(reveal))
    {
        if(reveal[x] == 0)
        {
            reveal[x] = NA
        }
    }
  }
  else
  {
    reveal <- apply(lFM[,Ord], 1, function(x) {which(x)[1]})
  }

  # Removes NA values before computing reveal.
  # reveal <- apply(lFM[,Ord][ , !apply(is.na(lFM[,Ord]), 2, all)], 1,
  # function(x) {which(x)[1]})

  # calculate p
  pval <- sum(!is.na(reveal)) / FbyT[1]

  # Calculate p - (SigmaReveal / nm)  
  fitscore <- pval - (sum(reveal, na.rm=TRUE) / (FbyT[1] * FbyT[2])) +
              (pval / (2 * FbyT[2]))
  
  return(fitscore)
}

# Computes the requirements covered by an ordering or reduction.
ReqsCovered <- function(Ord, lFM)
{
    # logical vector that will hold the requirements covered
    Reqs <- c()

	if(length(Ord) == 1)
	{
		Reqs <- lFM[,Ord]
	}
	else
	{
		#print("Ord")
		#print(Ord)
    	for(i in 1:nrow(lFM[,Ord]))
        	Reqs <- c(Reqs,(TRUE %in% lFM[,Ord][i,]))
	}


    return(Reqs)
}
