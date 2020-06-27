## kirklinAcceptanceProbability
#   sample function to compute acceptance probability as presented in 
#   Brian Kirklin's senior thesis e^(-abs(deltaFit)) / temp)
AF_kirklin <- function(DeltaFitness, Temperature)
{
  # euler's number, google did not return  this as predefined in R
    e <- 2.71828183
    # compute the exponent
    APexponent =  ((-DeltaFitness) / Temperature)

    accprob<-e^APexponent

    # return the resulting acceptance probability
    return(accprob)
}
