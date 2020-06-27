# FDP_Termination.R
#
# This file contains three functions that determine whether the
# genetic algorithm should halt.

# Terminate after EndCond seconds.
TermTime <- function(currExecTime, EndCond, ...)
{    
    return(currExecTime < EndCond)
}

# Terminate if no fitness improvement is made for EndCond iterations.
TermStag <- function(currStagIt, EndCond, ...)
{
    return(currStagIt < EndCond)
} 

# Terminate after EndCond iterations pass.
TermTotalIt <- function(currTotalIt, EndCond, ...)
{
    return(currTotalIt < EndCond)
}

