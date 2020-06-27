# AFL_Ochiai.R
#
# Computes suspiciousness scores per the Ochiai technique.
#
# Jonathan Miller Kauffman

# Use the Ochiai fault localization technique to rank the statements
# in the program in order of suspiciousness.
runOchiai <- function(lFM, failingTests, liveTests)
{
    passFail <- calculateTotalLivePassFail(failingTests=failingTests,liveTests=liveTests)

    passFailRatio <- calculatePassFailRatio(lFM=lFM,totalLivePass=passFail$TotalLivePass,totalLiveFail=passFail$TotalLiveFail,failingTests=failingTests,liveTests=liveTests)

    suspiciousnessConfidence <- calculateSuspiciousnessOchiai(passRatio=passFailRatio$PassRatio,failRatio=passFailRatio$FailRatio,totalLivePass=passFail$TotalLivePass,totalLiveFail=passFail$TotalLiveFail)

    rank <- calculateRank(suspiciousness=suspiciousnessConfidence$Suspiciousness)

    return(list(Suspiciousness=suspiciousnessConfidence$Suspiciousness,Confidence=suspiciousnessConfidence$Confidence,Rank=rank))
}

# Calculates the suspiciousness score for each statement given the
# passRatio, failRatio, and number of live passing and failing
# test cases.
calculateSuspiciousnessOchiai <- function(passRatio, failRatio,totalLivePass, totalLiveFail)
{
    # The number of statements.
    numStmts <- length(passRatio)

    # Initialize the suspiciousness vector.
    suspiciousness <- rep(0,numStmts)

    for(i in 1:numStmts)
    {
        # This shouldn't be possible.
        if(totalLiveFail==0 && totalLivePass==0)
        {
            suspiciousness[i] <- -1
        }
        # If no test cases executed this statement, we can't determine
        # how suspicious the statement is.
        else if(failRatio[i]==0 && passRatio[i]==0)
        {
            suspiciousness[i] <- -1
        }
        # Calculate suspiciousness per its equation.
        else
        {
            suspiciousness[i] <- (failRatio[i]*totalLiveFail) /sqrt(totalLiveFail * ((failRatio[i]*totalLiveFail) + (passRatio[i]*totalLivePass)))
        }
    }

    # Return the suspiciousness vector as a list.
    return(list(Suspiciousness=suspiciousness))
}
