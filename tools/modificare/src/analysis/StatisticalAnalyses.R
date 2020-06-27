#
# StatisticalAnalyses.R
#
# The main function, PerformStatisticalAnalyses, takes in a data frame
# with the following attributes:
#
# Application, Technique, AnalysisTime, PrioritizationTime, APFD
#
# The function will store all of the statistical information about all
# of the techniques, or algorithms, in xtables and then write them to file
# according to the suggestions in "A Practical Guide for Using Statistical
# Tests to Assess Randomized Algorithms in Software Engineering" by Andrea
# Arcuri and Lionel Briand.
#
# TODO: If I use a SQL database to store the experimental data, then I 
# will need to modify this code to use SQL queries.
#


# The main function.
PerformStatisticalAnalyses <- function(dataFrame)
{
	# Needed to find the skew.
	library(psych)
	# Needed to create LaTeX tables from R data frames.
	library(xtable)

	# Get the list of all techniques, or algorithms.
	techniqueList <- unique(subset(dataFrame,TRUE,select="Pri"))$Pri

	# Get the list of all applications.
	applicationList <- unique(subset(dataFrame,select="Application"))$Application

	# Remove existing tables from pairwiseComparisonsFile and fullStatisticsFile.
	write("",file="pairwiseComparisonsFile.tex",append=FALSE)
	write("",file="fullStatisticsFile.tex",append=FALSE)

	# Print full statistics for each technique.
	for(technique in techniqueList)
		FullStatistics(dataFrame,technique,applicationList)
	
	# Perform a pairwise comparison if the techniques are different.
	for(technique1 in techniqueList)
		for(technique2 in techniqueList)
		{
			if(technique1 != technique2 && technique1 != paste(technique2,"_reduction",sep="")
				&& technique2 != paste(technique1,"_reduction",sep=""))
				PairwiseComparison(dataFrame,technique1,technique2,applicationList)
		}

}

# Takes in the data frame, technique, and a list of applications and creates
# tables containing full statistics for efficiency and effectiveness results.
FullStatistics <- function(dataFrame,technique,applicationList)
{
	# Create a table with an application for each row and a statistic
	# for each column.
	table <- mat.or.vec(length(applicationList),8)
	table <- as.data.frame(table)
	names(table) <- c("Mean","Std Dev","Median","Var","Min","Max","Skew","Abs Dev")
	row.names(table) <- applicationList

	# Keep track of the current row when adding information to the table.
	currentRow <- 1

	# Compute the mean, standard deviation, median, variance, min, max,
	# skew, and absolute deviation for each application for effectiveness data.
	for(application in applicationList)
	{
		effectivenessData <- subset(dataFrame,select=c("Pri","Fit","Application"),Pri==technique)
		effectivenessData <- subset(effectivenessData,select=c("Pri","Fit","Application"),Application==application)$Fit

		# Mean
		table[[1]][currentRow] <- mean(effectivenessData)
		# Standard Deviation
		table[[2]][currentRow] <- sd(effectivenessData)
		# Median
		table[[3]][currentRow] <- median(effectivenessData)
		# Variance
		table[[4]][currentRow] <- var(effectivenessData)
		# Minimum
		table[[5]][currentRow] <- min(effectivenessData)
		# Maximum
		table[[6]][currentRow] <- max(effectivenessData)
		# Skewness
		table[[7]][currentRow] <- skew(effectivenessData)
		# Absolute Deviation
		table[[8]][currentRow] <- mad(effectivenessData)

		currentRow <- currentRow + 1
	}

	# Create a LaTeX table and add it to a file that will later be inserted
	# into the master LaTeX document.
	table <- xtable(table,caption=paste(technique,"Effectiveness",sep="-"),align=c('|','c','|','c','c','c','c','c','c','c','c','|'))

	print(table,file="fullStatisticsFile.tex",append=TRUE)

	# Create a table with an application for each row and a statistic
	# for each column.
	table <- mat.or.vec(length(applicationList),8)
	table <- as.data.frame(table)
	names(table) <- c("Mean","Std Dev","Median","Var","Min","Max","Skew","Abs Dev")
	row.names(table) <- applicationList

	# Keep track of the current row when adding information to the table.
	currentRow <- 1

	# Compute the mean, standard deviation, median, variance, min, max,
	# skew, and absolute deviation for each application for efficiency data.
	for(application in applicationList)
	{
		efficiencyData <- subset(dataFrame,select=c("Pri","Runtime","Application"),Pri==technique)
		efficiencyData <- subset(efficiencyData,select=c("Pri","Runtime","Application"),Application==application)$Runtime

		# Mean
		table[[1]][currentRow] <- mean(efficiencyData)
		# Standard Deviation
		table[[2]][currentRow] <- sd(efficiencyData)
		# Median
		table[[3]][currentRow] <- median(efficiencyData)
		# Variance
		table[[4]][currentRow] <- var(efficiencyData)
		# Minimum
		table[[5]][currentRow] <- min(efficiencyData)
		# Maximum
		table[[6]][currentRow] <- max(efficiencyData)
		# Skewness
		table[[7]][currentRow] <- skew(efficiencyData)
		# Absolute Deviation
		table[[8]][currentRow] <- mad(efficiencyData)

		currentRow <- currentRow + 1
	}

	# Create a LaTeX table and add it to a file that will later be inserted
	# into the master LaTeX document.
	table <- xtable(table,caption=paste(technique,"Efficiency",sep="-"),align=c('|','c','|','c','c','c','c','c','c','c','c','|'))
	print(table,file="fullStatisticsFile.tex",append=TRUE)
}

# Takes in a data frame, two techniques, and a list of applications and
# performs a pairwise comparison.
PairwiseComparison <- function(dataFrame, technique1, technique2,applicationList)
{
	# Create a table with an application for each row and a statistic
	# for each column.
	table <- mat.or.vec(length(applicationList),2)
	table <- as.data.frame(table)
	names(table) <- c("p-value","effect size")
	row.names(table) <- applicationList

	# Keep track of the current row when adding information to the table.
	currentRow <- 1

	# Find W, p-value, and effect size for each application for effectiveness data.
	for(application in applicationList)
	{
		effectivenessData1 <- subset(dataFrame,select=c("Pri","Fit","Application"),Pri==technique1)
		effectivenessData1 <- subset(effectivenessData1,select=c("Pri","Fit","Application"),Application==application)$Fit
		effectivenessData2 <- subset(dataFrame,select=c("Pri","Fit","Application"),Pri==technique2)
		effectivenessData2 <- subset(effectivenessData2,select=c("Pri","Fit","Application"),Application==application)$Fit

		if(length(effectivenessData1) != 0 && length(effectivenessData2) != 0)
		{
			w <- wilcox.test(effectivenessData1, effectivenessData2)
			R1 <- sum(rank(c(effectivenessData1,effectivenessData2))[seq_along(effectivenessData1)])
			A12 <- ((R1/length(effectivenessData1)) - ((length(effectivenessData1) +1) / 2)) / length(effectivenessData2)

			table[[1]][currentRow] <- w[3]
			table[[2]][currentRow] <- A12

			currentRow <- currentRow + 1
		}
	}

	# Create a LaTeX table and add it to a file that will later be inserted
	# into the master LaTeX document.
	table <- xtable(table,caption=paste(technique1,technique2,"Effectiveness",sep="-"),align=c('|','c','|','c','c','|'))
	print(table,file="pairwiseComparisonsFile.tex",append=TRUE)

	# Create a table with an application for each row and a statistic
	# for each column.
	table <- mat.or.vec(length(applicationList),2)
	table <- as.data.frame(table)
	names(table) <- c("p-value","effect size")
	row.names(table) <- applicationList
	currentRow <- 1

	# Find W, p-value, and effect size for each application for efficiency data.
	for(application in applicationList)
	{
		efficiencyData1 <- subset(dataFrame,select=c("Pri","Runtime","Application"),Pri==technique1)
		efficiencyData1 <- subset(efficiencyData1,select=c("Pri","Runtime","Application"),Application==application)$Runtime

		efficiencyData2 <- subset(dataFrame,select=c("Pri","Runtime","Application"),Pri==technique2)
		efficiencyData2 <- subset(efficiencyData2,select=c("Pri","Runtime","Application"),Application==application)$Runtime

		if(length(efficiencyData1) != 0 && length(efficiencyData2) != 0)
		{
			w <- wilcox.test(efficiencyData1, efficiencyData2)
			R1 <- sum(rank(c(efficiencyData1,efficiencyData2))[seq_along(efficiencyData1)])
			A12 <- ((R1/length(efficiencyData1)) - ((length(efficiencyData1) +1) / 2)) / length(efficiencyData2)

			table[[1]][currentRow] <- w[3]
			table[[2]][currentRow] <- A12

			currentRow <- currentRow + 1
		}
	}

	# Create a LaTeX table and add it to a file that will later be inserted
	# into the master LaTeX document.
	table <- xtable(table,caption=paste(technique1,technique2,"Efficiency",sep="-"),align=c('|','c','|','c','c','|'))
	print(table,file="pairwiseComparisonsFile.tex",append=TRUE)
}
