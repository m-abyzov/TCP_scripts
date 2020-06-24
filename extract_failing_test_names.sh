# provide 2 args (change current values to ones actual for your machine):
# 1) path till defects4j home dir, e.g. "/home/misha/TCP_tools/defects4j"
# 2) as second arg provide path till the environment into which you have integrated defects4j command, e.g. "/home/misha/environments/main/bin/activate"
python ./src/D4J_fail_tests_extractor.py $1 $2

# launching:
# . extract_failing_test_names.sh "/home/misha/TCP_tools/defects4j" "/home/misha/environments/main/bin/activate"