
## function to load in cluster libraries and start a cluster of all
# the new dell machines in alden 101/103
AllNewDellClusterInit <- function()
{
 
  cl <- makeSOCKcluster(c("aldenv100", "aldenv100", "aldenv101",
        "aldenv101", "aldenv102", "aldenv102", "aldenv103",
        "aldenv103", "aldenv104", "aldenv104", "aldenv105",
        "aldenv105", "aldenv106", "aldenv106", "aldenv107",
        "aldenv107", "aldenv122", "aldenv122", "aldenv123", 
        "aldenv123", "aldenv151", "aldenv151", "aldenv152",
        "aldenv152", "aldenv153", "aldenv153", "aldenv154",
        "aldenv154", "aldenv184", "aldenv184", "aldenv185",
        "aldenv185", "aldenv186", "aldenv186", "aldenv187",
        "aldenv187", "aldenv188", "aldenv188", "aldenv189", 
        "aldenv189"))
        
  return(cl)
}

Alden101DellClusterInit <- function()
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

Alden103DellClusterInit <- function(){
  cl <- makeSOCKcluster(c("aldenv100", "aldenv100", "aldenv101",
        "aldenv101", "aldenv102", "aldenv102", "aldenv103",
        "aldenv103", "aldenv104", "aldenv104", "aldenv105",
        "aldenv105", "aldenv106", "aldenv106", "aldenv107",
        "aldenv107"))
        
  return(cl)
}

AllAldenMachines <- function()
{
       cl <- makeSOCKcluster(c("aldenv122","aldenv122","aldenv123","aldenv123",
"aldenv150","aldenv150","aldenv151","aldenv151","aldenv152","aldenv152",
"aldenv153","aldenv153","aldenv154","aldenv154","aldenv155","aldenv155",
"aldenv156","aldenv156",
"aldenv157","aldenv157","aldenv158","aldenv158","aldenv159","aldenv159",
"aldenv160","aldenv160","aldenv161","aldenv161","aldenv162","aldenv162",
"aldenv163","aldenv163","aldenv164","aldenv164","aldenv165","aldenv165",
"aldenv166","aldenv166","aldenv167","aldenv167","aldenv168","aldenv168",
"aldenv169","aldenv169","aldenv170","aldenv170","aldenv171","aldenv171",
"aldenv172","aldenv172","aldenv173","aldenv173","aldenv174","aldenv174",
"aldenv175","aldenv175","aldenv176","aldenv176","aldenv177","aldenv177",
"aldenv178","aldenv178","aldenv179","aldenv179","aldenv180","aldenv180",
"aldenv181","aldenv181","aldenv182","aldenv182","aldenv184","aldenv184",
"aldenv185","aldenv185","aldenv186","aldenv186","aldenv187","aldenv187",
"aldenv188","aldenv188","aldenv189","aldenv189","aldenv100","aldenv100",
"aldenv101","aldenv101","aldenv102","aldenv102","aldenv103","aldenv103",
"aldenv104","aldenv104","aldenv105","aldenv105","aldenv106","aldenv106",
"aldenv107","aldenv107","aldenv145","aldenv145",
"aldenv146","aldenv146","aldenv18","aldenv18",
"aldenv61","aldenv61",
"aldenv134","aldenv134","aldenv135","aldenv135",
"aldenv136","aldenv136","aldenv137","aldenv137","aldenv138","aldenv138",
"aldenv139","aldenv139","aldenv141","aldenv141","aldenv147","aldenv147",
"aldenv148","aldenv148"))

}

Alden109Cluster <- function()
{
       cl <- makeSOCKcluster(c("aldenv3","aldenv3","aldenv18","aldenv18",
"aldenv23","aldenv23","aldenv26","aldenv26","aldenv61","aldenv61",
"aldenv125","aldenv125","aldenv126","aldenv126","aldenv127","aldenv127",
"aldenv128","aldenv128","aldenv134","aldenv134","aldenv135","aldenv135",
"aldenv136","aldenv136","aldenv137","aldenv137","aldenv138","aldenv138",
"aldenv141","aldenv141","aldenv147","aldenv147",
"aldenv148","aldenv148","aldenv149","aldenv149"))
       return(cl)
}

KapfhammerOuterOffice <- function()
{
       cl <- makeSOCKcluster(c("aldenv145","aldenv145","aldenv146","aldenv146"))
       return(cl)
}
