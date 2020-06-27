# Takes in the aggregate data frame and adds ten columns to each row containing
# the NAPFD scores corresponding to a percentage of the test suite.
# TODO: Remove references to column numbers.
computeRealNapfd <- function(dataFrame)
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
	dataFrame$RealFitness <- apply(dataFrame,1,
		function(row)
		{
			# Read in the matrix and store information about it.
			#filename <- as.character(row["fFM"])
			criteria <- as.character(row["Criteria"])
			application <- as.character(row["Application"])
			if(criteria == "class" && application == "LF")
				filename <- "../../reqMatrices/ClassCoverageMatrices/LoopFinder_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "LF")
				filename <- "../../reqMatrices/MethodCoverageMatrices/LoopFinder_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "LF")
				filename <- "../../reqMatrices/StatementCoverageMatrices/LoopFinder_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "LF")
				filename <- "../../reqMatrices/FaultDetectionMatrices/LoopFinder_FDM.dat"
			else if(criteria == "class" && application == "CE")
				filename <- "../../reqMatrices/ClassCoverageMatrices/CommissionEmployee_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "CE")
				filename <- "../../reqMatrices/MethodCoverageMatrices/CommissionEmployee_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "CE")
				filename <- "../../reqMatrices/StatementCoverageMatrices/CommissionEmployee_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "CE")
				filename <- "../../reqMatrices/FaultDetectionMatrices/CommissionEmployee_FDM.dat"
			else if(criteria == "class" && application == "PT")
				filename <- "../../reqMatrices/ClassCoverageMatrices/Point_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "PT")
				filename <- "../../reqMatrices/MethodCoverageMatrices/Point_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "PT")
				filename <- "../../reqMatrices/StatementCoverageMatrices/Point_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "PT")
				filename <- "../../reqMatrices/FaultDetectionMatrices/Point_FDM.dat"
			else if(criteria == "class" && application == "EP")
				filename <- "../../reqMatrices/ClassCoverageMatrices/Employee_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "EP")
				filename <- "../../reqMatrices/MethodCoverageMatrices/Employee_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "EP")
				filename <- "../../reqMatrices/StatementCoverageMatrices/Employee_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "EP")
				filename <- "../../reqMatrices/FaultDetectionMatrices/Employee_FDM.dat"
			else if(criteria == "class" && application == "DS")
				filename <- "../../reqMatrices/ClassCoverageMatrices/DataStructures_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "DS")
				filename <- "../../reqMatrices/MethodCoverageMatrices/DataStructures_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "DS")
				filename <- "../../reqMatrices/StatementCoverageMatrices/DataStructures_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "DS")
				filename <- "../../reqMatrices/FaultDetectionMatrices/DataStructures_FDM.dat"
			else if(criteria == "class" && application == "SK")
				filename <- "../../reqMatrices/ClassCoverageMatrices/Sudoku_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "SK")
				filename <- "../../reqMatrices/MethodCoverageMatrices/Sudoku_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "SK")
				filename <- "../../reqMatrices/StatementCoverageMatrices/Sudoku_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "SK")
				filename <- "../../reqMatrices/FaultDetectionMatrices/Sudoku_FDM.dat"
			else if(criteria == "class" && application == "JD")
				filename <- "../../reqMatrices/ClassCoverageMatrices/JDepend_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "JD")
				filename <- "../../reqMatrices/MethodCoverageMatrices/JDepend_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "JD")
				filename <- "../../reqMatrices/StatementCoverageMatrices/JDepend_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "JD")
				filename <- "../../reqMatrices/FaultDetectionMatrices/JDepend_FDM.dat"
			else if(criteria == "class" && application == "RP")
				filename <- "../../reqMatrices/ClassCoverageMatrices/ReductionAndPrioritization_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "RP")
				filename <- "../../reqMatrices/MethodCoverageMatrices/ReductionAndPrioritization_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "RP")
				filename <- "../../reqMatrices/StatementCoverageMatrices/ReductionAndPrioritization_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "RP")
				filename <- "../../reqMatrices/FaultDetectionMatrices/ReductionAndPrioritization_FDM.dat"
			else if(criteria == "class" && application == "BQ")
				filename <- "../../reqMatrices/ClassCoverageMatrices/Barbecue_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "BQ")
				filename <- "../../reqMatrices/MethodCoverageMatrices/Barbecue_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "BQ")
				filename <- "../../reqMatrices/StatementCoverageMatrices/Barbecue_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "BQ")
				filename <- "../../reqMatrices/FaultDetectionMatrices/Barbecue_FDM.dat"
			else if(criteria == "class" && application == "JT")
				filename <- "../../reqMatrices/ClassCoverageMatrices/JodaTime_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "JT")
				filename <- "../../reqMatrices/MethodCoverageMatrices/JodaTime_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "JT")
				filename <- "../../reqMatrices/StatementCoverageMatrices/JodaTime_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "JT")
				filename <- "../../reqMatrices/FaultDetectionMatrices/JodaTime_FDM.dat"
			else if(criteria == "class" && application == "CM")
				filename <- "../../reqMatrices/ClassCoverageMatrices/CommonsMath_1_class_true_Coverage.dat"
			else if(criteria == "method" && application == "CM")
				filename <- "../../reqMatrices/MethodCoverageMatrices/CommonsMath_1_method_true_Coverage.dat"
			else if(criteria == "line" && application == "CM")
				filename <- "../../reqMatrices/StatementCoverageMatrices/CommonsMath_1_line_true_Coverage.dat"
			else if(criteria == "fault" && application == "CM")
				filename <- "../../reqMatrices/FaultDetectionMatrices/CommonsMath_FDM.dat"
			else
				filename <- "fake"
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
			#percents <- c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)
			#scores <- c()
			#for(i in percents)
			#{
			#	new <- prioritization[1:(numTests * i)]
				#print("Prioritization")
				#print(prioritization)

				# Recompute NAPFD.
				napfd <- APFD(Ord=prioritization,lFM=matrix)
				#scores <- c(scores,napfd)

				#print(napfd)
			#}

			return(napfd)
		})

	# Take the APFD scores from the rows of the matrix and store them as columns
	# in the original data frame.
	#dataFrame$TenPercent <- temp[1,]
	#dataFrame$TwentyPercent <- temp[2,]
	#dataFrame$ThirtyPercent <- temp[3,]
	#dataFrame$FortyPercent <- temp[4,]
	#dataFrame$FiftyPercent <- temp[5,]
	#dataFrame$SixtyPercent <- temp[6,]
	#dataFrame$SeventyPercent <- temp[7,]
	#dataFrame$EightyPercent <- temp[8,]
	#dataFrame$NintyPercent <- temp[9,]
	#dataFrame$OneHundredPercent <- temp[10,]

	return(dataFrame)
}
