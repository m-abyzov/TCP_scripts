# This is a script for launching full pipeline of the experiments with
# GeTLO, Kanonizo, and Modificare test case prioritization tools.
#
# provide 3 args (dirs actual for your machine):
# 1) path till Defects4J home dir, e.g. "/home/misha/TCP_tools/defects4j"
# 2) as second arg provide path till the environment into which you have
# integrated defects4j command, e.g. "/home/misha/environments/main/bin/activate"
# or "/home/misha/anaconda3/bin/activate"
# 3) as third argument provide full path till the current project location,
# e.g. "/home/misha/PycharmProjects/TCP_scripts"
#
# Launching via, e.g.
# . execution_scripts/run_all_stages.sh "/home/misha/TCP_tools/defects4j" "/home/misha/environments/main/bin/activate" "/home/misha/PycharmProjects/TCP_scripts"


. execution_scripts/generate_coverage_matrices.sh $1 $2 $3
. execution_scripts/run_TCP_tools.sh $1
. execution_scripts/estimate_results.sh
