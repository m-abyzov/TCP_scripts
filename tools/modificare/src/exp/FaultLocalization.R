# Takes in the aggregate data frame and adds four columns to each row containing
# the expense scores of the fault localization techniques.
# TODO: Remove references to column numbers.
computeFaultLocalizationResults <- function(dataFrame)
{
	# I return a matrix of results, where each row contains one column of fault
	# localization results.
	#  row 1 - Tarantula
	#  row 2 - Jaccard
	#  row 3 - Ochiai
	#  row 4 - Simple Matching
	temp <- apply(dataFrame,1,
		function(row)
		{
			# Extract the reduction from the row.
			reduction <- as.numeric(row["Ord"])
			for(i in 1:268)
			{
				name <- paste("Ord",i,sep="")
				reduction <- c(reduction, as.numeric(row[name]))
			}
			reduction <- reduction[!is.na(reduction)]
			# print(reduction)

			# Read in the matrix and store information about it.
			filename <- as.character(row["fFM"])
			matrix<-makeLogFM(read.table(filename))
			numStatements <- nrow(matrix)
			numTests <- ncol(matrix)
			#print("Filename")
			#print(filename)

			# Generate the list of live test cases.
			liveTests <- rep(FALSE,numTests)
			liveTests[reduction] <- TRUE
			#print("Live Tests")
			#print(liveTests)

			# All tests initially pass.
			passFail <- rep(FALSE,numTests)

			# Choose the faulty statement based on the application.
			# Choose the pass/fail information based on the application.
			if(filename == "reqMatrices/StatementCoverageMatrices/Barbecue_1_line_true_Coverage.dat")
			{
				faultyEntity <- 327
				passFail[c(74,95,96,120)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/Barbecue_1_method_true_Coverage.dat")
			{
				faultyEntity <- 205
				passFail[c(38,93,95,97,100,104,106,110,111,117,119,122,126,128,129,130)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/Barbecue_1_class_true_Coverage.dat")
			{
				faultyEntity <- 16
				passFail[c(25,59)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/CommissionEmployee_1_line_true_Coverage.dat")
			{
				faultyEntity <- 17
				passFail[c(1,2,4,5,6,8,9,10,11,12,13,14)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/CommissionEmployee_1_method_true_Coverage.dat")
			{
				faultyEntity <- 12
				passFail[c(1,2,3,5,6,9,10,11)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/CommissionEmployee_1_class_true_Coverage.dat")
			{
				faultyEntity <- 2
				passFail[c(3,5,6,9,15)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/CommonsMath_1_line_true_Coverage.dat")
			{
				faultyEntity <- 1366
				passFail[c(3)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/CommonsMath_1_method_true_Coverage.dat")
			{
				faultyEntity <- 2303
				passFail[c(1,3)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/CommonsMath_1_class_true_Coverage.dat")
			{
				faultyEntity <- 4
				passFail[c(1,2,3)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/DataStructures_1_line_true_Coverage.dat")
			{
				faultyEntity <- 90
				passFail[c(52,58,65)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/DataStructures_1_method_true_Coverage.dat")
			{
				faultyEntity <- 34
				passFail[c(1,3)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/DataStructures_1_class_true_Coverage.dat")
			{
				faultyEntity <- 9
				passFail[c(35,37,41,73,74,76,82)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/Employee_1_line_true_Coverage.dat")
			{
				faultyEntity <- 24
				passFail[c(2,5,8,14)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/Employee_1_method_true_Coverage.dat")
			{
				faultyEntity <- 19
				passFail[c(1,2)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/Employee_1_class_true_Coverage.dat")
			{
				faultyEntity <- 2
				passFail[c(2,4,5,6,7,9,12,14)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/JDepend_1_line_true_Coverage.dat")
			{
				faultyEntity <- 508
				passFail[c(13,25,38,39)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/JDepend_1_method_true_Coverage.dat")
			{
				faultyEntity <- 125
				passFail[c(2,3,4,13,23,25)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/JDepend_1_class_true_Coverage.dat")
			{
				faultyEntity <- 24
				passFail[c(13,23,25,38,39)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/JodaTime_1_line_true_Coverage.dat")
			{
				faultyEntity <- 12174
				passFail[c(2,4,10,11,12,20,21,22,23,26,27,28,32,34,56,60,61,62,
					64,67,70,72,73,77,78,80,86,87,89,90,91,92,94,96,99,		
					100,101,104,105,106,107,109,113,114,115,119,123,125,126,
					127,128,129,130,132,134,136,138,140,143,145,146,147,148,
					150,152,154,155,157,161,162,164,167,169,172,173,177,180,
					185,186,187,192,194,195,196,197,199,200,201,202,203,204,205,206)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/JodaTime_1_method_true_Coverage.dat")
			{
				faultyEntity <- 2500
				passFail[c(33,73,78,166,176)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/JodaTime_1_class_true_Coverage.dat")
			{
				faultyEntity <- 152
				passFail[c(2,4,6,10,13,15,19,20,21,23,24,31,32,34,58,59,60,62,63,
68,70,74,77,79,81,82,83,84,87,88,89,92,96,97,100,104,107,108,
110,111,112,114,115,117,120,121,123,126,127,128,129,130,131,132,134,137,141,
143,146,148,152,154,157,159,160,161,162,164,165,166,170,173,176,177,178,179,
180,182,186,187,191,196,199,203,204)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/LoopFinder_1_line_true_Coverage.dat")
			{
				faultyEntity <- 8
				passFail[c(7,9,10,11,13)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/LoopFinder_1_method_true_Coverage.dat")
			{
				faultyEntity <- 4
				passFail[c(2,5,12,13)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/LoopFinder_1_class_true_Coverage.dat")
			{
				faultyEntity <- 1
				passFail[c(1,2,4,6,7,8,9,12,13)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/ReductionAndPrioritization_1_line_true_Coverage.dat")
			{
				faultyEntity <- 1111
				passFail[c(28,30,32,33,36)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/ReductionAndPrioritization_1_method_true_Coverage.dat")
			{
				faultyEntity <- 77
				passFail[c(17,20,21,27,29,30,34,35,36,37,38)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/ReductionAndPrioritization_1_class_true_Coverage.dat")
			{
				faultyEntity <- 17
				passFail[c(1,2,4,5,7,8,11,12,13,14,15,17,18,21,22,23,24,26,28,29,31,33,35,37)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/Point_1_line_true_Coverage.dat")
			{
				faultyEntity <- 10
				passFail[c(12,13)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/Point_1_method_true_Coverage.dat")
			{
				faultyEntity <- 4
				passFail[c(3,6,9)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/Point_1_class_true_Coverage.dat")
			{
				faultyEntity <- 2
				passFail[c(1,3,6)] <- TRUE
			}
			else if(filename == "reqMatrices/StatementCoverageMatrices/Sudoku_1_line_true_Coverage.dat")
			{
				faultyEntity <- 62
				passFail[c(21,25)] <- TRUE
			}
			else if(filename == "reqMatrices/MethodCoverageMatrices/Sudoku_1_method_true_Coverage.dat")
			{
				faultyEntity <- 38
				passFail[c(10,11,21,22)] <- TRUE
			}
			else if(filename == "reqMatrices/ClassCoverageMatrices/Sudoku_1_class_true_Coverage.dat")
			{
				faultyEntity <- 1
				passFail[c(4,5,6,7,11,14,19,20,21,25)] <- TRUE
			}
			else
				return(NA,NA,NA,NA,NA,NA)

			#print("Pass/Fail")
			#print(passFail)

			# Perform fault localization on the reduced test suites.
			#print("Tarantula Reduction")
			tarantulaReduction <- Expense(rankings=runTarantula(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank$Rank,faultyStatement=faultyEntity)$Expense
			#if(is.na(tarantulaReduction))
			#{
				#print("tarantulaReduction")
				#print(runTarantula(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank)
				#Sys.sleep(5)
			#}
			#print("Jaccard Reduction")
			jaccardReduction <- Expense(rankings=runJaccard(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank,faultyStatement=faultyEntity)$Expense
			#if(is.na(jaccardReduction))
			#{
			#	print("jaccardReduction")
			#	print(runJaccard(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank)
			#	Sys.sleep(5)
			#}
			#print("Ochiai Reduction")
			ochiaiReduction <- Expense(rankings=runOchiai(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank,faultyStatement=faultyEntity)$Expense
			#if(is.na(ochiaiReduction))
			#{
			#	print("ochiaiReduction")
			#	Sys.sleep(5)
			#}
			#print("Simple Matching Reduction")
			simpleMatchingReduction <- Expense(rankings=runSimpleMatching(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank,faultyStatement=faultyEntity)$Expense
			#if(is.na(simpleMatchingReduction))
			#{
			#	print("simpleMatchingReduction")
			#	Sys.sleep(5)
			#}

			liveTests <- rep(TRUE,numTests)

			# Perform fault localization on the original test suites.
			tarantulaOriginal <- Expense(rankings=runTarantula(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank$Rank,faultyStatement=faultyEntity)$Expense
			jaccardOriginal <- Expense(rankings=runJaccard(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank,faultyStatement=faultyEntity)$Expense
			ochiaiOriginal <- Expense(runOchiai(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank,faultyStatement=faultyEntity)$Expense
			simpleMatchingOriginal <- Expense(runSimpleMatching(lFM=matrix, failingTests=passFail, liveTests=liveTests)$Rank,faultyStatement=faultyEntity)$Expense

			return(c(tarantulaReduction,jaccardReduction,ochiaiReduction,simpleMatchingReduction,
				tarantulaOriginal,jaccardOriginal,ochiaiOriginal,simpleMatchingOriginal))
		})

	print(temp)

	dataFrame$TarantulaReduction <- temp[1,]
	dataFrame$JaccardReduction <- temp[2,]
	dataFrame$OchiaiReduction <- temp[3,]
	dataFrame$SimpleMatchingReduction <- temp[4,]
	dataFrame$TarantulaOriginal <- temp[5,]
	dataFrame$JaccardOriginal <- temp[6,]
	dataFrame$OchiaiOriginal <- temp[7,]
	dataFrame$SimpleMatchingOriginal <- temp[8,]

	return(dataFrame)
}
