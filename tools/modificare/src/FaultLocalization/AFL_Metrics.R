# AFL_Metrics.R
#
# Contains metrics for fault localization techniques.
#
# Jonathan Miller Kauffman


# Computes the percent reduction in test suite size.  This is a
# higher is better (HIB) metric; i.e., we want as large of a
# reduction as possible.
Reduction <- function(originalSize, reducedSize)
{
    reduction <- (1 - (reducedSize / originalSize)) * 100

    return(list(Reduction=reduction))
}


# Computes the expense of performing fault localization.  This is a
# lower is better (LIB) metric; i.e., we want to examine as few
# statements as possible before finding the fault.
#
# rankings - Contains the rankings for each statement in order
#            of statements.
#
# faultStatement - Which statement contains the fault.
#
# A return value of NA probably indicates that the number of the
# faulty statement is too large.
Expense <- function(rankings, faultyStatement)
{
	#print(rankings)
	#print(is.character(rankings))
	#print(faultyStatement)
	#print(is.numeric(faultyStatement))
	#print(length(rankings))
	#print("Expense Rankings")
	#print(rankings)
	#rankings <- rankings[[1]]
    expense <- rankings[faultyStatement] / length(rankings) * 100

    return(list(Expense=expense))
}
