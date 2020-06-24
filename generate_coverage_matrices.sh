# provide 3 args (change current values to ones actual for your machine):
# 1) path till defects4j home dir, e.g. "/home/misha/TCP_tools/defects4j"
# 2) as second arg provide path till the environment into which you have
# integrated defects4j command, e.g. "/home/misha/environments/main/bin/activate"
# 3) as third argument provide full path till the current project location,
# e.g. "/home/misha/PycharmProjects/TCP_scripts"

python ./src/D4J_fail_tests_extractor.py $1 $2
python ./src/coverage_runner.py $1 $2 $3
java -jar parser.jar
python ./src/time_extractor.py $1 $2