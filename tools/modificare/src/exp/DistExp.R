ClusterSann <- function(outPath, fFM, cluster="Alden101", Trials=1000,
               RandSeed=100, Par=FALSE) {
  require(snow)
  require(doSNOW)
  require(plyr)
  require(foreach)
  require(multicore)
  
  #setwd("~/elliton-senior-comp/")
  zLoadFit()
  zLoadSANN()
  
  cl <- do.call(cluster, list())
  clusterExport(cl, c("APFD", "makeLogFM", "InOrdSwap", "NF_FS",
                "NF_LS", "NF_FLS", "NF_BLS", "AF_kirklin",
                "CF_kirklin", "SANN", "SANN_real", "SANN_Multi_Rep",
                "SANN_Multi_Rep_real","SANN_reduction","SANN_reduction_real"))
  registerDoSNOW(cl)
  
  out <- SANN_Multi_Rep(fFM=fFM, SANN="SANN_reduction_real", NF=c("NF_FS", "NF_LS", "NF_FLS",
         "NF_BLS"), AF="AF_kirklin", CF="CF_kirklin", Trials=Trials,
         RandSeed=RandSeed,Par=Par)
  
  stopCluster(cl)
  
  write.table(out, file=outPath)
  
  return(cat("Output of dim", dim(out), "written to", outPath))
}

ClusterRand <- function(outPath, fFM, cluster="Alden101", Trials=1000,
               RandSeed=100, Par=FALSE) {
    require(snow)
    require(doSNOW)
    require(plyr)
    require(foreach)
    require(multicore)

    zLoadFit()
    zLoadRand()

    cl <- do.call(cluster, list())
    clusterExport(cl, c("APFD", "makeLogFM", "InOrdSwap",
                  "Rand_Multi_Rep", "Rand_Multi_Rep_real", "Rand_POP",
                  "Rand_POP_real", "Rand_LIN", "Rand_LIN_real","Rand_POP_reduction","Rand_POP_reduction_real",
				  "Rand_LIN_reduction","Rand_LIN_reduction_real"))
    registerDoSNOW(cl)

    out <- Rand_Multi_Rep(Rand=c("Rand_LIN_real","Rand_LIN_reduction_real"),
                          fFM=fFM, cPopSize=c(10,20,30),
                          Trials=Trials,RandSeed=RandSeed, Par=Par)

    stopCluster(cl)

    write.table(out, file=outPath)

    return(cat("Output of dim", dim(out), "written to", outPath))
}

ClusterGA <- function(outPath, fFM, cluster="Alden101", RandSeed=100,
             Trials=1000, Par=FALSE) {
  require(snow)
  require(doSNOW)
  require(plyr)
  require(foreach)
  require(multicore)
  
  #setwd("~/elliton-senior-comp/")
  zLoadFit()
  zLoadGA()
  
  cl <- do.call(cluster, list())
  clusterExport(cl, c("APFD", "makeLogFM", "CO_OX1", "CO_OX2",
                "CO_MPX", "CO_POS", "CO_VR", "MO_DM", "MO_EM",
                "MO_ISM", "MO_IVM", "MO_SIM", "MO_SM", "GA_Multi_Rep",
                "GA_Multi_Rep_real","GA","GA_real","GetChildren",
                "SO_ROU", "SO_TRU","TO_EXP","TO_LIN","TO_UNT",
                "TermTime","TermStag","TermTotalIt","GA_reduction","GA_reduction_real"))
  registerDoSNOW(cl)
  
  out <- GA_Multi_Rep(fFM=fFM, cPopSize=c(20),
                      cChildDens=c(.4), cMutRate=c(.2),
                      CrossOp=c("CO_OX1","CO_MPX"),MutOp=c("MO_DM","MO_ISM"),
					  SelOp=c("SO_ROU","SO_TRU"),TransOp=c("TO_EXP"),
                      TermCond=c("TermTotalIt"),
                      EndCond=c(10),Trials=Trials,
                      RandSeed=RandSeed, Par=Par)
  
  stopCluster(cl)
  
  write.table(out, file=outPath)
  
  return(cat("Output of dim", dim(out), "written to", outPath))
}

ClusterART <- function(outPath, fFM, cluster="Alden101", RandSeed=100,
              Trials=1000, Par=FALSE) {
  require(snow)
  require(doSNOW)
  require(plyr)
  require(foreach)
  require(multicore)
  
  #setwd("~/elliton-senior-comp/")
  zLoadFit()
  zLoadART()
  
  cl <- do.call(cluster, list())
  clusterExport(cl, c("APFD", "makeLogFM", "ART", "ART_real",
                "ART_Multi_Rep", "ART_Multi_Rep_real", "generate",
                "select", "JaccardDistance", "EuclideanDistance",
                "ManhattanDistance", "FurthestTestCase","ART_reduction",
				"ART_reduction_real"))
  registerDoSNOW(cl)
  
  out <- ART_Multi_Rep(fFM=fFM, ART=c("ART_reduction_real"),
         similarityMetric=c("ManhattanDistance"),furthestAwayMetric=c("max"),
         Trials=Trials, RandSeed=RandSeed, Par=Par)
  
  stopCluster(cl)
  
  write.table(out, file=outPath)
  
  return(cat("Output of dim", dim(out), "written to", outPath))
}

ClusterGRD <- function(outPath, fFM, fTF, cluster="Alden101",
              RandSeed=100, Trials=1000, Par=FALSE) {
  require(snow)
  require(doSNOW)
  require(plyr)
  require(foreach)
  require(multicore)
  
  #setwd("~/elliton-senior-comp/")
  zLoadFit()
  zLoadGRD()
  
  cl <- do.call(cluster, list())
  clusterExport(cl, c("APFD", "makeLogFM", "GRD", "GRD_real",
                "GRD_reduction", "GRD_reduction_real",
                "numberNotShared","orderRequirements",
                "removeReducedTests", "compairRequirements",
                "findNewReq","GreedyPrioritize","GreedyReduce",
                "RunGreedyPrioritize","RunGreedyReduce",
                "ConvertCoverageSummaryRandomMatrix"))
  registerDoSNOW(cl)
  
  out <- GRD_Multi_Rep(fFM=fFM, fTF=fTF, GRD=c("GRD_real","GRD_reduction_real"),Trials=Trials,
         RandSeed=RandSeed, Par=Par)
  
  stopCluster(cl)
  
  write.table(out, file=outPath)
  
  return(cat("Output of dim", dim(out), "written to", outPath))
}

ClusterHC <- function(outPath, fFM, cluster="Alden101", RandSeed=100,
             Trials=1000, Par=FALSE) {
  require(snow)
  require(doSNOW)
  require(plyr)
  require(foreach)
  require(multicore)
  
  #setwd("~/elliton-senior-comp/")
  zLoadFit()
  zLoadHC()
  
  cl <- do.call(cluster, list())
  clusterExport(cl, c("APFD", "makeLogFM", "NG_FS", "NG_LS",
                "HC_Multi_Rep", "HC_Multi_Rep_real", "HC_FA",
                "HC_FA_real", "HC_SA", "HC_SA_real", "HC_RA",
                "HC_RA_real","HC_SA_reduction","HC_SA_reduction_real",
				"HC_FA_reduction","HC_FA_reduction_real"))
  registerDoSNOW(cl)
  
  out <- HC_Multi_Rep(fFM=fFM, HC=c("HC_FA_reduction_real","HC_SA_reduction_real"),
         NG=c("NG_FS","NG_LS"),Trials=Trials, RandSeed=RandSeed,
         Par=Par)
  
  stopCluster(cl)
  
  write.table(out, file=outPath)
  
  return(cat("Output of dim", dim(out), "written to", outPath))
}

Alden101 <- function()
{
  cl <- makeSOCKcluster(c("aldenv151", "aldenv151", "aldenv152",
        "aldenv152", "aldenv153", "aldenv153", "aldenv154",
        "aldenv154", "aldenv184", "aldenv184", "aldenv185",
        "aldenv185", "aldenv186", "aldenv186", "aldenv187",
        "aldenv187", "aldenv188", "aldenv188", "aldenv189",
        "aldenv189", "aldenv122", "aldenv122", "aldenv123",
        "aldenv123"))
  
  return(cl)
}

Test <- function()
{
    cl <- makeSOCKcluster(c("localhost"))
    return(cl)
}
