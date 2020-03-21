from pathlib import Path
import subprocess
import time
import os

# PROJECT_PATH = "tmp/lang_1_fixed"

# Path(PROJECT_PATH).mkdir(parents=True, exist_ok=True)
PROJECT_NAME = "closure"

D4J_MAIN_DIR = "/home/misha/TCP_tools/defects4j"
D4J_FRAMEWORK_DIR = f'{D4J_MAIN_DIR}/framework/bin'

COMPILATION_DIR = f"{D4J_MAIN_DIR}/tmp/{PROJECT_NAME}_1_buggy"

ALL_TEST_METHOD_NAMES = f'{COMPILATION_DIR}/all_tests'

ACTIVATE_ENV_QUERY = "source /home/misha/environments/main/bin/activate"
ACTIVATE_D4J_QUERY = f'export PATH=$PATH:{D4J_FRAMEWORK_DIR}'

COVERAGE_QUERY = "defects4j coverage -i all-classes.txt -t "


# todo: extract all the test method names.
def extract_test_methods():
    test_methods = []
    with open(ALL_TEST_METHOD_NAMES, 'r') as all_test_methods_file:
        for test_method in all_test_methods_file:
            test_methods.append(test_method.strip())
    return test_methods


# todo: start running d4j coverage
def construct_query_for_test_methods(raw_test_method: str):
    test_method_parts = raw_test_method.split('(', 1)

    test_method_name = test_method_parts[0]
    test_class_name = test_method_parts[1][:-1]

    #  e.g., org.apache.commons.lang3.AnnotationUtilsTest::testOneArgNull
    processed_test_method = f"{test_class_name}::{test_method_name}"
    return COVERAGE_QUERY + processed_test_method


DESTINATION_COVERAGE_FOLDER = f"/home/misha/TCP_tools/CoberturaCoverageParser/{PROJECT_NAME}_files/{PROJECT_NAME}_coverage_reports/"
def construct_query_for_obtaining_coverage(raw_test_method):
    # e.g, org.apache.commons.lang3.AnnotationUtilsTest::testOneArgNull
    test_method_for_query = construct_query_for_test_methods(raw_test_method)

    test_class = test_method_for_query.split('::')[0].split('.')[-1]
    test_method = test_method_for_query.split('::')[1]

    coverage_file_name = f'{test_class}___{test_method}.xml'

    return f'{ACTIVATE_ENV_QUERY} && {ACTIVATE_D4J_QUERY} && {test_method_for_query} ' \
           f'&& mv coverage.xml {coverage_file_name} && mv {coverage_file_name} {DESTINATION_COVERAGE_FOLDER}'



raw_test_methods = extract_test_methods()
tests_count = len(raw_test_methods)
prev_percentage = 0
Path(DESTINATION_COVERAGE_FOLDER).mkdir(parents=True, exist_ok=True)

start_time = time.time()
checkpoint_time = start_time
for test_num, raw_test_method in enumerate(raw_test_methods):

    percentage = round(test_num / tests_count * 100)
    if percentage != prev_percentage:
        prev_percentage = percentage
        print(f"processed {test_num + 1} files ({percentage}%), it took {round((time.time() - checkpoint_time) / 60, 2)} minutes from prev. iteration, "
              f"{round((time.time() - start_time) / 3600, 2)} hours from launching")
        checkpoint_time = time.time()

    query_for_obtaining_coverage = construct_query_for_obtaining_coverage(raw_test_method)
    full_file_path = DESTINATION_COVERAGE_FOLDER + query_for_obtaining_coverage.split()[-2]

    if not os.path.isfile(full_file_path):  # if there is no report already generated -> generate it.
        exporting_proj_proc = subprocess.Popen(query_for_obtaining_coverage,
                                               shell=True,
                                               executable="/bin/bash", stdout=subprocess.PIPE,
                                               stderr=subprocess.PIPE, cwd=COMPILATION_DIR)
        exporting_proj_res = exporting_proj_proc.communicate()

print(f"Processing is finished. It took {round((time.time() - start_time) / 3600, 2)} hours")
