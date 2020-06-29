# TCP_scripts
Scripts with experiments and its results for the master thesis paper 
"Automated test prioritization".

For producing results of the prioritization based on the already built-in
ordering files, just launch the `. execution_scripts/estimate_results.sh` from
the root dir of this project. After that you find files with APFD scores, 
VD-A effect size estimations, and also whisker plots of APFD variances for each 
project by the following directory structure:

``` 
└── D4J_projects 
        └── $project_name
                └── results             
                      ├── APFD_projects_tools_statistics.txt
                      ├── APFDs.png
                      └── VD_A_projects_tools_statistics.txt
```

# Requirements
Python 3 (tested on 3.7). 

Also you need to install libs, mentioned in 
[requirements.txt](https://github.com/Mishabuzov/TCP_scripts/blob/master/requirements.txt)
for example, via 
`pip install -r requirements.txt`

# How to repeat all the experiments absolutely from scratch:
1) Set up [Defects4J](https://github.com/rjust/defects4j). 
Make all the steps described in the installation guide. 
Make sure that `defects4j` command has successfully integrated into your environment.
2) Install **R** language, and all its additional packages, which are required
for launching the [Modificare](https://github.com/Mishabuzov/modificare) tool.
3) Install **Matlab** environment in order to launch the 
[GeTLO](https://github.com/sepehr3pehr/GeTLO) tool.
Make sure that `matlab` command has successfully integrated into your environment.
4) Install **Java** (tested with Java 8) and all the dependencies of the
[Kanonizo](https://github.com/kanonizo/kanonizo) tool for its launching.
5) Run script [run_all_stages.sh](https://github.com/Mishabuzov/TCP_scripts/blob/master/execution_scripts/run_all_stages.sh)
`. execution_scripts/run_all_stages.sh $1 $2 $3` with passing 3 args 
(directories actual for your machine):
    1) As the first argument pass dir till **Defects4J** home.
    2) As second argument provide path till the environment into which you have 
    integrated `defects4j` command and all aforementioned requirements. 
    3) As the third argument provide full path till the current project on your 
    laptop.
