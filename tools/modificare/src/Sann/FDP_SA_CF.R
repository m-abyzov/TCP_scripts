## kirklinCoolingFunction
#   sample function to which linearly reduces temperature
#   to be called at each iteration of sann
#   taken from Brian Kirklin's senior thesis
CF_kirklin <- function(Temperature)
{
    return((Temperature * .99))
}
