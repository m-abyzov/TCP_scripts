# Takes in the aggregate data frame and adds ten columns to each row containing
# the NAPFD scores corresponding to a percentage of the test suite.
# TODO: Remove references to column numbers.
computeDailyNightlyBuildTestingResults <- function(dataFrame)
{
	# I return a matrix of results, where each row contains one column of daily/nightly
	# build testing results.
	#  row 1 - 10% of the number of test cases
	#  row 2 - 20%
	#  row 3 - 30%
	#  row 4 - 40%
	#  row 5 - 50%
	#  row 6 - 60%
	#  row 7 - 70%
	#  row 8 - 80%
	#  row 9 - 90%
	#  row 10 - 100%
	temp <- apply(dataFrame,1,
		function(row)
		{
			# Read in the matrix and store information about it.
			filename <- as.character(row["fFM"])
			#print("Filename")
			#print(filename)
			matrix <- makeLogFM(read.table(filename))
			numStatements <- nrow(matrix)
			numTests <- ncol(matrix)
			#print("NumTests")
			#print(numTests)

			# Extract the prioritization from the row.
			prioritization <- as.numeric(row["Ord"])
			for(i in 1:268)
			{
				name <- paste("Ord",i,sep="")
				prioritization <- c(prioritization, as.numeric(row[name]))
			}
			prioritization <- prioritization[!is.na(prioritization)]
			prioritization <- prioritization[prioritization <= numTests]
			# print(reduction)

			# Get the appropriate percentages of the test suite and store the new
			# APFD scores.
			percents <- c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)
			scores <- c()
			for(i in percents)
			{
				new <- prioritization[1:(numTests * i)]
				#print("Prioritization")
				#print(prioritization)

				# Recompute NAPFD.
				napfd <- APFD(Ord=prioritization,lFM=matrix)
				scores <- c(scores,napfd)

				#print(napfd)
			}

			return(scores)
		})

	# Take the APFD scores from the rows of the matrix and store them as columns
	# in the original data frame.
	dataFrame$TenPercent <- temp[1,]
	dataFrame$TwentyPercent <- temp[2,]
	dataFrame$ThirtyPercent <- temp[3,]
	dataFrame$FortyPercent <- temp[4,]
	dataFrame$FiftyPercent <- temp[5,]
	dataFrame$SixtyPercent <- temp[6,]
	dataFrame$SeventyPercent <- temp[7,]
	dataFrame$EightyPercent <- temp[8,]
	dataFrame$NintyPercent <- temp[9,]
	dataFrame$OneHundredPercent <- temp[10,]

	return(dataFrame)
}
