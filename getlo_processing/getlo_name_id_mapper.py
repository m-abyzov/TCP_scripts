
def process_5_ids_orderings_to_test_names(PROJECT_ID, PROJECT_DIR, n=5):
    # processed with XMLCoverageParser (CoberturaCoverageParser) all test file .
    ALL_TEST_FILE = F"../D4J/{PROJECT_ID}/{PROJECT_ID}_id_name_mapping.txt"

    test_id_name_mapper = {}

    with open(ALL_TEST_FILE, "r") as all_tests_file:
        for test_id, test_name in enumerate(all_tests_file):
            test_name = test_name.strip().split()[0]
            if len(test_name) > 0:
                test_id_name_mapper[test_id + 1] = test_name

    for i in range(1, n + 1):
        full_project_dir = f"{PROJECT_DIR}/{i}"
        # processed numeric ordering with "getlo_numeric_results_processor.py".
        NUMERIC_ORDERING_FILE = F"{full_project_dir}/{PROJECT_ID}_processed_numeric_ordering"
        RESULT_ORDERING_FILE = F"{full_project_dir}/{PROJECT_ID}_tests_ordering"

        with open(NUMERIC_ORDERING_FILE, "r") as ordering_file, \
                open(RESULT_ORDERING_FILE, "w") as result_file:
            tests_id_order = [int(test_id) for test_id in ordering_file.read().split(',') if test_id != ""]

            for i in range(0, len(tests_id_order)):
                test_id = tests_id_order[i]
                if test_id in test_id_name_mapper:
                    result_file.write(test_id_name_mapper[test_id])
                    if i < len(tests_id_order) - 1:
                        result_file.write("\n")
