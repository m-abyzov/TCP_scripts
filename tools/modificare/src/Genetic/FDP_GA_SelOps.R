
##############################################################
################ Selection Operators
################################################

# Roulette Wheel Selection (ROU)
SO_ROU <- function(TransFit, numI)
{  
  return(sample.int(length(TransFit), numI,
         prob=(TransFit / sum(TransFit))))
}


# Truncation selection operator
# Get numI parents of highest fitne  #random chance for each fit
SO_TRU <- function(TransFit, numI)
{
    return(
        sort(TransFit, decreasing=TRUE, index.return=TRUE)$ix[1:numI])
}
