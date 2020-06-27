# ProduceOrderingReductionDataFile.R
#
# Takes the name of a timings file and a prioritization/reduction and
# produces the data.dat file used by Protect.
#
# Jonathan Miller Kauffman

produceOrderingReductionDataFile <- function(timingsFile, testSuite)
{
    fileLines <- c()
    names <- as.vector(read.table(timingsFile,sep='\t')$V1)
    
    for(test in testSuite)
        fileLines <- c(fileLines,names[test])

    return(fileLines)
}
