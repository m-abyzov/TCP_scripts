library(microbenchmark)


benchMutOps <- function (sampleSize, times, RandomSeed)
{
    set.seed(RandomSeed)
    theReturn <- microbenchmark("DM"=DM(sample(1:sampleSize)),
                 "EM"=EM(sample(1:sampleSize)),
                 "ISM"=ISM(sample(1:sampleSize)),
                 "IVM"=IVM(sample(1:sampleSize)),
                 "SIM"=SIM(sample(1:sampleSize)),
                 "SM"=SM(sample(1:sampleSize)), times=times)
    theReturn <- cbind(melt(theReturn), "SampleSize"=sampleSize,
                 "Seed"=RandomSeed)
        
    return(theReturn)
}
