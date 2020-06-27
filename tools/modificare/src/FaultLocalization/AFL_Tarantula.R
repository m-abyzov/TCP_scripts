# AFL_Tarantula.R
#
# Computes suspiciousness and confidence scores per the Tarantula
# technique.
#
# Many of these calculations are based by code provided by James
# A. Jones at:
#
# http://www.ics.uci.edu/~jajones/Tarantula.html
#
# Jonathan Miller Kauffman

# Use the Tarantula fault localization technique to rank the
# statements in the program in order of suspiciousness.
runTarantula <- function(lFM, failingTests, liveTests)
{
    passFail <- calculateTotalLivePassFail(failingTests=failingTests,
    liveTests=liveTests)

    passFailRatio <- calculatePassFailRatio(lFM=lFM,
                     totalLivePass=passFail$TotalLivePass,
                     totalLiveFail=passFail$TotalLiveFail,
                     failingTests=failingTests,liveTests=liveTests)

    suspiciousnessConfidence <- 
        calculateSuspiciousnessConfidenceTarantula(
        passRatio=passFailRatio$PassRatio,
        failRatio=passFailRatio$FailRatio,
        totalLivePass=passFail$TotalLivePass,
        totalLiveFail=passFail$TotalLiveFail)

    rank <- calculateRankTarantula(
            suspiciousness=suspiciousnessConfidence$Suspiciousness,
            confidence=suspiciousnessConfidence$Confidence)

    return(list(
           Suspiciousness=suspiciousnessConfidence$Suspiciousness,
           Confidence=suspiciousnessConfidence$Confidence,Rank=rank))
}

# Compute the ranking of each statement based on the suspiciousness
# and confidence scores.
calculateRankTarantula <- function(suspiciousness, confidence)
{
    temp <- as.data.frame(cbind(seq(1:length(suspiciousness)),
            suspiciousness,confidence))
    names(temp) <- c("one","two","three")
    temp <- temp[order(temp$two,temp$three,decreasing=TRUE),]
    
    return(list(Rank=temp$one))
}

# Calculates the suspiciousness and confidence scores for each
# statement given the passRatio, failRatio, and number of live passing
# and failing test cases.
calculateSuspiciousnessConfidenceTarantula <- function(passRatio,
                                              failRatio,
                                              totalLivePass,
                                              totalLiveFail)
{
    # The number of statements.
    numStmts <- length(passRatio)

    # Initialize the suspiciousness and confidence vectors.
    suspiciousness <- rep(0,numStmts)
    confidence <- rep(0,numStmts)

    for(i in 1:numStmts)
    {
		#print("Fail Ratio")
		#print(failRatio)
		#print("Pass Ratio")
		#print(passRatio)
        # This shouldn't be possible.
        if(totalLiveFail==0 && totalLivePass==0)
        {
            suspiciousness[i] <- -1
            confidence[i] <- -1
        }
        # If no test cases executed this statement, we can't determine
        # how suspicious the statement is.
        else if(failRatio[i]==0 && passRatio[i]==0)
        {
            suspiciousness[i] <- -1
            confidence[i] <- 0
        }
        # Calculate suspiciousness and confidence per their equations.
        else
        {
            suspiciousness[i] <- failRatio[i] / (failRatio[i] +
                                 passRatio[i])
            confidence[i] <- max(failRatio[i], passRatio[i])
        }
    }

    # Return the suspiciousnes and confidence vectors as a list.
    return(list(Suspiciousness=suspiciousness,Confidence=confidence))
}
