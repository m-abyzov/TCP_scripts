# GenerateSynthetic.R

# Creates a synthetic matrix as described in "Using Synthetic Test 
# Suites to Empirically Compare Search-Based and Greedy Prioritizers."
# by Williams and Kapfhammer.
GenerateSyntheticlFM <- function(nT, FactorReq, FactorCov)
{
  RT <- nT * FactorReq
  
  out <- matrix(FALSE, nrow=RT, ncol=nT)
  
  numCovered <- FactorCov * RT * nT
  
  out[sample(c(1:(RT*nT)), numCovered)] <- TRUE

  return(out)
  
}
