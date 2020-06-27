# Takes a directory and filename pattern as arguments and merges all data files
# matching that pattern.
mergeDataFiles <- function(directory="datasets/KauffmanThesisData/raw/", pattern="*.dat")
{
	# Create a list of all files in the directory that match the pattern.
	files <- list.files(path=directory,pattern=pattern,full.names=TRUE)

	# Will contain the attributes in all data frames.
	attributes <- c()

	# Create the list of the attributes in all files.
	for(file in files)
	{
		temp <- read.table(file)
		attributes <- union(attributes, names(temp))
	}

	# Make the data frame that will hold all data frames.  Create a row of
	# NA values.  Set the data frame attributes.
	dataFrame <- data.frame(t(rep(NA,length(attributes))))
	names(dataFrame) <- attributes

	#print(attributes)

	for(file in files)
	{
		temp <- read.table(file)
		diff <- setdiff(attributes, names(temp))
		
		for(column in diff)
		{
			temp[ncol(temp):ncol(temp)+1,column]<-NA
		}

		dataFrame <- rbind(dataFrame, temp)
	}

	# Remove the NA row.
	dataFrame<-subset(dataFrame,fFM != "NA")


	return(dataFrame)
}

# Takes in the aggregate data frame and changes the coverage/fault matrix file names
# an application name and a coverage criteria.
# TODO: This function assumes that the filenames will be in the format that I used
# (which is not entirely uniform).  Create a uniform naming format and include
# this information in the documentation.
filenameToApplicationAndCriteria <- function(dataFrame)
{
	dataFrame$Criteria <- apply(dataFrame,1,
		function(row)
		{
			# TODO: I refer to the column containing the name of the matrix file,
			# but this is likely to change in the future.  Find a way to refer
			# to column fFM (note that 'row$fFM' does not work.
			filename <- as.character(row[217])
			matrixName <- strsplit(filename, split="/")[[1]][3]
			splitMatrixName <- strsplit(matrixName, split="_")
			criteria <- splitMatrixName[[1]][length(splitMatrixName[[1]])]
			if(criteria == "FDM.dat")
				return("fault")
			else if(criteria == "Coverage.dat")
				return(splitMatrixName[[1]][3])
		})

	dataFrame$Application <- apply(dataFrame,1,
		function(row)
		{
			# TODO: I refer to the column containing the name of the matrix file,
			# but this is likely to change in the future.  Find a way to refer
			# to column fFM (note that 'row$fFM' does not work.
			filename <- as.character(row[217])
			matrixName <- strsplit(filename, split="/")[[1]][3]
			splitMatrixName <- strsplit(matrixName, split="_")
			application <- splitMatrixName[[1]][1]
			if(application == "Barbecue")
				return("BQ")
			else if(application == "DataStructures")
				return("DS")
			else if(application == "ReductionAndPrioritization")
				return("RP")
			else if(application == "Sudoku")
				return("SK")
			else if(application == "Employee")
				return("EP")
			else if(application == "CommissionEmployee")
				return("CE")
			else if(application == "Point")
				return("PT")
			else if(application == "JDepend")
				return("JD")
			else if(application == "LoopFinder")
				return("LF")
			else if(application == "CommonsMath")
				return("CM")
			else if(application == "JodaTime")
				return("JT")
			return(application)
		})

	dataFrame$Type <- apply(dataFrame,1,
		function(row)
		{
			# TODO: I refer to the column containing the name of the technique,
			# but this is likely to change in the future.  Find a way to refer
			# to column Pri (note that 'row$Pri' does not work.
			technique <- as.character(row[212])
			if("reduction" %in% strsplit(technique,split="_")[[1]])
				return("reduction")
			return("prioritization")
		})

	dataFrame$NS <- apply(dataFrame,1,
		function(row)
		{
			# TODO: I refer to the column containing the name of the technique,
			# but this is likely to change in the future.  Find a way to refer
			# to column Pri (note that 'row$Pri' does not work.
			technique <- as.character(row[212])
			if(technique == "HC_FA")
				return("FA")
			else if(technique == "HC_SA")
				return("SA")
			else if(technique == "HC_FA_reduction")
				return("FA")
			else if(technique == "HC_SA_reduction")
				return("SA")
			return(NA)
		})

	return(dataFrame)
}
