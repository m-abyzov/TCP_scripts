from pathlib import Path
import subprocess
import time
import os
from sys import argv as args

D4J_MAIN_DIR = args[1].strip()
# D4J_MAIN_DIR = "/home/misha/TCP_tools/defects4j"
D4J_FRAMEWORK_DIR = f'{D4J_MAIN_DIR}/framework/bin'

# Queries for bash:
ENV_PATH = args[2].strip()
ACTIVATE_ENV_QUERY = f"source {ENV_PATH}"
# ACTIVATE_ENV_QUERY = "source /home/misha/environments/main/bin/activate"
ACTIVATE_D4J_QUERY = f'export PATH=$PATH:{D4J_FRAMEWORK_DIR}'

COVERAGE_QUERY = "defects4j coverage -i all-classes.txt -t "

# REPORT_PARSER_PATH = '/home/misha/PycharmProjects/TCP_scripts'
REPORT_PARSER_PATH = args[3].strip()


def extract_test_methods():
    run_process_in_compilation_dir("defects4j compile && defects4j test")
    test_methods = []
    with open(ALL_TEST_METHOD_NAMES, 'r') as all_test_methods_file:
        for test_method in all_test_methods_file:
            test_methods.append(test_method.strip())
    project_dir = f"{REPORT_PARSER_PATH}/D4J_projects/{project_id}"
    run_process_in_compilation_dir(f"mv {ALL_TEST_METHOD_NAMES} {project_dir}")

    subprocess.Popen(f'mv {project_dir}/all_tests {project_dir}/{project_id}_all_tests',
                            shell=True, executable="/bin/bash", stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE).communicate()
    return test_methods


# start running d4j coverage
def construct_query_for_test_methods(raw_test_method: str):
    test_method_parts = raw_test_method.split('(', 1)

    test_method_name = test_method_parts[0]
    test_class_name = test_method_parts[1][:-1]

    #  e.g., org.apache.commons.lang3.AnnotationUtilsTest::testOneArgNull
    processed_test_method = f"{test_class_name}::{test_method_name}"
    return COVERAGE_QUERY + processed_test_method


def construct_query_for_obtaining_coverage(raw_test_method):
    # e.g, org.apache.commons.lang3.AnnotationUtilsTest::testOneArgNull
    test_method_for_query = construct_query_for_test_methods(raw_test_method)

    test_class = test_method_for_query.split('::')[0].split('.')[-1]
    test_method = test_method_for_query.split('::')[1]

    coverage_file_name = f'{test_class}___{test_method}.xml'.replace('$', '_')

    return f'{test_method_for_query} && mv coverage.xml {coverage_file_name} ' \
           f'&& mv {coverage_file_name} {DESTINATION_COVERAGE_FOLDER}'


def run_process_in_compilation_dir(query):
    proc = subprocess.Popen(f'{ACTIVATE_ENV_QUERY} && {ACTIVATE_D4J_QUERY} && {query}',
                            shell=True, executable="/bin/bash", stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, cwd=COMPILATION_DIR)
    proc.communicate()


if __name__ == "__main__":
    projects_list = {'chart': 'org.jfree.chart.**.*',
                     'lang': 'org.apache.commons.**.*',
                     'time': 'org.joda.time.**.*',
                     'math': 'org.apache.commons.**.*',
                     'closure': 'com.google.**.*'}
    projects_to_run = args[4:]
    for project_id in projects_to_run:
        print(f"Process project {project_id}")
        COMPILATION_DIR = f"{D4J_MAIN_DIR}/tmp/{project_id}_1_buggy"

        with open(f'{COMPILATION_DIR}/all-classes.txt', 'w+') as all_classes_file:
            all_classes_file.write(projects_list[project_id])

        ALL_TEST_METHOD_NAMES = f'{COMPILATION_DIR}/all_tests'
        DESTINATION_COVERAGE_FOLDER = f"{REPORT_PARSER_PATH}/D4J_projects/{project_id}/{project_id}_coverage_reports/"
        Path(DESTINATION_COVERAGE_FOLDER).mkdir(parents=True, exist_ok=True)

        raw_test_methods = extract_test_methods()
        tests_count = len(raw_test_methods)
        prev_percentage = 0

        start_time = time.time()
        checkpoint_time = start_time
        for test_num, raw_test_method in enumerate(raw_test_methods):

            percentage = round(test_num / tests_count * 100)
            if percentage != prev_percentage:
                prev_percentage = percentage
                print(f"processed {test_num + 1} files ({percentage}%), "
                      f"it took {round((time.time() - checkpoint_time) / 60, 2)} minutes from prev. iteration, "
                      f"{round((time.time() - start_time) / 3600, 2)} hours from launching")
                checkpoint_time = time.time()

            query_for_obtaining_coverage = construct_query_for_obtaining_coverage(raw_test_method)
            full_file_path = DESTINATION_COVERAGE_FOLDER + query_for_obtaining_coverage.split()[-2]

            if not os.path.isfile(full_file_path):  # if there is no report already generated -> generate it.
                run_process_in_compilation_dir(query_for_obtaining_coverage)

        print(f"Processing is finished. It took {round((time.time() - start_time) / 3600, 2)} hours")
