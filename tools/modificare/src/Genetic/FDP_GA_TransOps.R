#######################################################
########### Transformation Operators
################################################

# Exponential Transformation Operator (EXP)
#  Takes the square route of each fitness ordering and returns the
#  result
TO_EXP <- function(FitnessScores)
{
    return(sqrt(FitnessScores))
}

# Linear Ranking Transformation Operator (LIN)
TO_LIN <- function(FitnessScores)
{
    return(((rank(FitnessScores) - 1) / length(FitnessScores)))
}

# No Transformation Operator (UNT)
TO_UNT <- function(FitnessScores)
{
    return(FitnessScores)
}
