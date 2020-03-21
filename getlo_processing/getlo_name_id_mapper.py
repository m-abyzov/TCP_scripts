PROJECT_IDS = ["time", "lang", "math"]


for PROJECT_ID in PROJECT_IDS:
    # processed with XMLCoverageParser (CoberturaCoverageParser) all test file .
    ALL_TEST_FILE = F"../D4J/{PROJECT_ID}/{PROJECT_ID}_all_tests"

    # processed numeric ordering with "getlo_numeric_results_processor.py".
    NUMERIC_ORDERING_FILE = F"../D4J/{PROJECT_ID}/getlo/{PROJECT_ID}_processed_numeric_ordering"
    RESULT_ORDERING_FILE = F"../D4J/{PROJECT_ID}/getlo/{PROJECT_ID}_result_ordering"

    test_id_name_mapper = {}

    with open(ALL_TEST_FILE, "r") as all_tests_file:
        for test_id, test_name in enumerate(all_tests_file):
            test_name = test_name.strip()
            if len(test_name) > 0:
                test_id_name_mapper[test_id + 1] = test_name

    with open(NUMERIC_ORDERING_FILE, "r") as ordering_file, \
            open(RESULT_ORDERING_FILE, "w") as result_file:
        tests_id_order = [int(test_id) for test_id in ordering_file.read().split(',') if test_id != ""]

        for i in range(0, len(tests_id_order)):
            test_id = tests_id_order[i]
            if test_id in test_id_name_mapper:
                result_file.write(test_id_name_mapper[test_id])
                if i < len(tests_id_order) - 1:
                    result_file.write("\n")
