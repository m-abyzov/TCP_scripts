# TCP_scripts
Scripts with experiments and its results for the paper "Automated test prioritization"

# How to repeat all the experiments absolutely from scratch:
1) Set up [Defects4J](https://github.com/rjust/defects4j). 
Make all the steps described in the installation guide.
2) 




n) Run GeTLO with depth 1. In case of other depth change depth parameter in the GeTLO function:
clone [GeTLO](https://github.com/sepehr3pehr/GeTLO) project.
open it via MATLAB environment. 
In the command window type following commands:
    - cd "path/till/GeTLO/project"
    - GeTLO(load('path/till/coverageMatrix'), 1) 