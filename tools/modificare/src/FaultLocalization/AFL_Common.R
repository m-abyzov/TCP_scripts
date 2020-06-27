# AFL_Common.R
#
# Holds fault localization functions that are common to each techinque

# Calculates the passRatio and failRatio for each statement given
# a binary coverage matrix and the total number of live passing
# and failing test cases.
calculatePassFailRatio <- function(lFM, totalLivePass, totalLiveFail,failingTests, liveTests)
{
    # The number of tests and statements.
    numTests <- ncol(lFM)
    numStmts <- nrow(lFM)

    # Initialize the passRatio and failRatio vectors.
    passRatio <- rep(0,numStmts)
    failRatio <- rep(0,numStmts)

    for(i in 1:numStmts)
    {
        for(j in 1:numTests)
        {
            # If the test case executes the statement, add one.
            if(lFM[[i,j]] && (!failingTests[j]) && liveTests[j])
                passRatio[i] <- passRatio[i] + 1
            if(lFM[[i,j]] && failingTests[j] && liveTests[j])
                failRatio[i] <- failRatio[i] + 1
        }

        # Divide by the number of total passing a failing test cases.
        passRatio[i] <- passRatio[i] / totalLivePass
        failRatio[i] <- failRatio[i] / totalLiveFail

		if(totalLivePass == 0)
			passRatio[i] <- 0
		if(totalLiveFail == 0)
			failRatio[i] <- 0
    }

    # Return the passRatio and failRatio vectors in a list.
    return(list(PassRatio=passRatio,FailRatio=failRatio))
}

# Calculates the total number of live passing and failing test
# cases given two binary vectors:
#
# failingTests - Contains a 1 at position i if test case i fails.
# liveTests - Contains a 1 at position i if test case i is live.
calculateTotalLivePassFail <- function(failingTests, liveTests)
{
    # The number of tests.
    numTests <- length(failingTests)

    # Initialize pass and fail counts.
    totalLivePass <- 0
    totalLiveFail <- 0

    for(i in 1:numTests)
    {
        # If the test case passes and is live.
        if(!failingTests[i] && liveTests[i])
            totalLivePass <- totalLivePass + 1
        # If the test case fails and is live.
        if(failingTests[i] && liveTests[i])
            totalLiveFail <- totalLiveFail + 1
    }

    # Return pass and fail counts in a list.
    return(list(TotalLivePass=totalLivePass,TotalLiveFail=totalLiveFail))
}

# Compute the ranking of each statement based on the suspiciousness
# scores.
calculateRank <- function(suspiciousness)
{
    temp <- as.data.frame(cbind(seq(1:length(suspiciousness)),suspiciousness))
    names(temp) <- c("one","two")
    temp <- temp[order(temp$two,decreasing=TRUE),]
    
    #return(list(Rank=temp$one))
    return(temp$one)
}
