# This is a script for generating coverage matrices for each project.
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
# . execution_scripts/generate_coverage_matrices.sh "/home/misha/TCP_tools/defects4j" "/home/misha/environments/main/bin/activate" "/home/misha/PycharmProjects/TCP_scripts"

#projects=(chart lang math closure time)
projects=(chart lang)

python ./src/D4J_fail_tests_extractor.py $1 $2 ${projects[*]}
python ./src/coverage_runner.py $1 $2 $3 ${projects[*]}
java -jar parser.jar ${projects[*]}
python ./src/time_extractor.py $1 $2 ${projects[*]}