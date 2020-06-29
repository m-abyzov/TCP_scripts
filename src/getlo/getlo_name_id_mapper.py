from pathlib import Path
from sys import argv as args
from os import scandir

BASE_DIR = "D4J_projects"


def extract_test_names(PROJECT_ID):
    # processed with XMLCoverageParser (CoberturaCoverageParser) all test file .
    ALL_TEST_FILE = F"{BASE_DIR}/{PROJECT_ID}/{PROJECT_ID}_id_name_mapping.txt"
    test_id_name_mapper = {}

    with open(ALL_TEST_FILE, "r") as all_tests_file:
        for test_id, test_name in enumerate(all_tests_file):
            test_name = test_name.strip().split()[0]
            if len(test_name) > 0:
                test_id_name_mapper[test_id + 1] = test_name
    return test_id_name_mapper


if __name__ == "__main__":
    projects = args[1:]
    for project_id in projects:
        test_id_name_mapper = extract_test_names(project_id)
        raw_getlo_dir = f"{BASE_DIR}/{project_id}/results/prioritized_orderings/getlo/raw"
        processed_getlo_dir = f"{BASE_DIR}/{project_id}/results/prioritized_orderings/getlo/processed"
        Path(processed_getlo_dir).mkdir(parents=True, exist_ok=True)

        for numeric_file in scandir(raw_getlo_dir):
            RESULT_ORDERING_FILE = F"{processed_getlo_dir}/{project_id}_tests_ordering"

            with open(numeric_file.path, "r") as ordering_file, \
                    open(RESULT_ORDERING_FILE, "w") as result_file:
                tests_id_order = [int(test_id) for test_id in ordering_file.read().split(',') if test_id != ""]

                for i in range(0, len(tests_id_order)):
                    test_id = tests_id_order[i]
                    if test_id in test_id_name_mapper:
                        result_file.write(test_id_name_mapper[test_id])
                        if i < len(tests_id_order) - 1:
                            result_file.write("\n")
