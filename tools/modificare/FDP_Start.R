# FDP_Start.R
#
# Sourcing this file will add several functions to the environment
# that can be used to load libraries and functions.

# Loads all of the prioritization algorithms.
zTryReload <- function()
{
    zLoadFit()
    zLoadRand()
    zLoadHC()
    zLoadSANN()
    zLoadGA()
    zLoadART()
    zLoadGRD()
}

# Loads the libraries, fitness calculator, synthetic report generator,
# and prioritization algorithms.
zLoadFaultExperiment <- function() 
{
    zLoadFaultLibraries()
    zLoadFit()
    zLoadRand()
    zLoadHC()
    zLoadSANN()
    zLoadGA()
    zLoadART()
    zLoadGRD()
}

# Loads the fault localization algorithms.
zLoadFaultLocalizationExperiment <- function()
{
    zLoadTarantula()
    zLoadSimpleMatching()
    zLoadJaccard()
    zLoadOchiai()
    source("src/FaultLocalization/AFL_Common.R")
}

# Loads libraries and the prioritization algorithms.
zLoadFaultLibraries <- function()
{
    library(plyr)
    library(snowfall)
    library(snow)
    library(doMC)
    library(gtools)
    
    zTryReload()
}

# Load the fitness function and the synthetic report generator.
zLoadFit <- function() 
{
    source("src/Fitness/FDP_Fit.R")
    source("src/GenerateSynthetic.R")
    source("src/FaultLocalization/AFL_Metrics.R")
}

# Load the random prioritization algorithm.
zLoadRand <- function() 
{
    source("src/Random/FDP_Rand.R")
}

# Load the hill climbing prioritization algorithm.
zLoadHC <- function()
{
    source("src/HillClimbing/FDP_HC.R")
    source("src/HillClimbing/FDP_HC_NG.R")
}

# Load the simulated annealing prioritization algorithm.
zLoadSANN <- function()
{
    source("src/Sann/FDP_SA.R")
    source("src/Sann/FDP_SA_NF.R")
    source("src/Sann/FDP_SA_CF.R")
    source("src/Sann/FDP_SA_AF.R")    
}    

# Load the genetic algorithm prioritization algorithm.
zLoadGA <- function()
{
    source("src/Genetic/FDP_GA.R")
    source("src/Genetic/FDP_GA_CrossOps.R")
    source("src/Genetic/FDP_GA_MutOps.R")
    source("src/Genetic/FDP_GA_SelOps.R")
    source("src/Genetic/FDP_GA_TransOps.R")
    source("src/FDP_Termination.R")
}

# Load the adaptive random prioritization algorithm.
zLoadART <- function()
{
    source("src/AdaptiveRandom/FDP_ART.R")
}

# Load the greedy prioritization algorithm.
zLoadGRD <- function()
{
    source("src/Greedy/FDP_GRD.R")
}

# Loads functions for creating clusters of computers.
zLoadCluster <- function()
{
    source("src/exp/DistExp.R")
}

zLoadTarantula <- function()
{
    source("src/FaultLocalization/AFL_Tarantula.R")
}

zLoadSimpleMatching <- function()
{
    source("src/FaultLocalization/AFL_SimpleMatching.R")
}

zLoadJaccard <- function()
{
    source("src/FaultLocalization/AFL_Jaccard.R")
}

zLoadOchiai <- function()
{
    source("src/FaultLocalization/AFL_Ochiai.R")
}

zLoadProduceOrderingReductionDataFile <- function()
{
    source("src/ProduceOrderingReductionDataFile.R")
}
