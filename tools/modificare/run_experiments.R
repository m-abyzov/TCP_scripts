# Title     : Run modificare algo by this script.
# Objective : test built-in TCP algorithms.
# Created by: misha
# Created on: 15.03.2020


init <- function () {
  source("FDP_Start.R")
  zTryReload()
  zLoadFaultExperiment()
  zLoadFaultLocalizationExperiment()
  zLoadFaultLibraries()
  zLoadProduceOrderingReductionDataFile()
}

save_ordering <- function (y, algoname, seed) {
  ordering <- y$Ord
  ord <- produceOrderingReductionDataFile(testSuite=ordering,
                                          timingsFile=TIMING_FILE)
  results_folder <- sprintf("%s/%s/results/prioritized_orderings/modificare/%s", PARENT_DIR, PROJECT_NAME, algoname)
  write.table(
    ord, row.names=FALSE, col.names=FALSE, quote=FALSE,
    file=sprintf("%s/%s_%s_ordering_%s.txt", results_folder, PROJECT_NAME, algoname, seed)
  )
}

run_random_n_times <- function (times=10) {
  for (seed in init_seed:(init_seed + times - 1)) {
    print(paste("testing random TCP with seed:", seed))
    y <- Rand_POP(lFM=x, cPopSize=20 + seed, Seed=seed)
    save_ordering(y, "random", seed)
  }
}

run_greedy_n_times <- function (times) {
  for (seed in init_seed:(init_seed + times - 1)) {
    print(paste("Testing greedy algorithm with seed:", seed))
    y <- GRD(COV_MATRIX_PATH, TIMING_FILE, seed=seed)
    save_ordering(y, "greedy", seed)
  }
}

run_GA_n_times <- function (times) {
  for (seed in init_seed:(init_seed + times - 1)) {
    print(paste("Testing GA with seed:", seed))
    y <- GA(x, Seed=seed)
    save_ordering(y, "genetic", seed)
  }
}

run_HC_FA_n_times <- function (times) {
  for (seed in init_seed:(init_seed + times - 1)) {
    print(paste("Testing HC_FA with seed:", seed))
    y <- HC_FA(x, Seed=seed)
    save_ordering(y, "HC_FA", seed)
  }
}

run_ART_n_times <- function (times) {
  for (seed in init_seed:(init_seed + times - 1)) {
    print(paste("Testing ART with seed:", seed))
    y <- ART(read.table(COV_MATRIX_PATH), "ManhattanDistance", "avg", seed=seed)
    save_ordering(y, "ART_man_avg", seed)
  }
}

run_HC_SA_n_times <- function (times) {
  for (seed in init_seed:(init_seed + times - 1)) {
    print(paste("Testing HC_SA with seed:", seed))
    y <- HC_SA(x, Seed=seed)
    save_ordering(y, "HC_SA", seed)
  }
}

# Error in HC_RA_real(lFM, NG, Ord, Seed) (FDP_HC.R#352): object 'ItLimit' not found
# run_HC_RA <- function () {
#   print("Running HC_RA algorithm.")
#   y <- HC_RA(x, NG="NG_LS", Seed=100)
#   save_ordering(y, "HC_RA_ordering.txt")
# }

run_SANN_n_times <- function (times) {
  for (seed in init_seed:(init_seed + times - 1)) {
    print(paste("Testing SANN with seed:", seed))
    y <- SANN(x, Seed=seed)
    save_ordering(y, "SANN", seed)
  }
}

PROJECT_NAMES <- commandArgs(trailingOnly=TRUE)
PARENT_DIR <- "../../D4J_projects"
# PROJECT_NAMES <- c("time", "closure")
n <- 20
init_seed <- 0
init()
for (PROJECT_NAME in PROJECT_NAMES) {
  print(sprintf("Running project %s", PROJECT_NAME))
  COV_MATRIX_PATH <- sprintf("%s/%s/%s_method_coverage_matrix.txt", PARENT_DIR, PROJECT_NAME, PROJECT_NAME)
  TIMING_FILE <- sprintf("%s/%s/%s_id_name_mapping.txt", PARENT_DIR, PROJECT_NAME, PROJECT_NAME)
  x <- makeLogFM(read.table(COV_MATRIX_PATH))
  if (PROJECT_NAME == 'lang' || PROJECT_NAME == 'chart') {
    run_greedy_n_times(n)
  }
  run_random_n_times(n)
  run_SANN_n_times(n)
  run_GA_n_times(n)
  run_HC_SA_n_times(n)
  run_HC_FA_n_times(n)
  run_ART_n_times(n)
}
