from sys import argv as args
import subprocess
from pathlib import Path
import os

SOURCE_KEY, TESTS_KEY = 'source', 'tests'
BUILD_DIRS = {
    'chart': {SOURCE_KEY: 'build/.', TESTS_KEY: 'build-tests/'},
    'lang': {SOURCE_KEY: "target/classes/", TESTS_KEY: "target/tests/"},
    'math': {SOURCE_KEY: "target/classes/", TESTS_KEY: "target/test-classes/"},
    'time': {SOURCE_KEY: "target/classes/", TESTS_KEY: "target/test-classes/"},
}
ALGO_NAMES = ["random", "additionalgreedy", "greedy", "randomsearch", "geneticalgorithm"]
times_launching_algos = 20
KANONIZO_JAR = "tools/kanonizo.jar"
DEFECTS4J_DIR = args[1]
PROJECT_IDs = args[2:]


def run_query_from_current_dir(query):
    subprocess.Popen(query, shell=True, executable="/bin/bash", stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE).communicate()


def run_query_from_d4j_dir(query):
    subprocess.Popen(query, shell=True, executable="/bin/bash", stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE, cwd=PROJECT_DIR).communicate()


def remove_file_if_exist(file):
    if os.path.exists(file):
        os.remove(file)


if __name__ == "__main__":
    for PROJECT_ID in PROJECT_IDs:
        if PROJECT_ID == 'closure':
            continue  # the Kanonizo does not launch with the Closure project.

        PROJECT_DIR = f"{DEFECTS4J_DIR}/tmp/{PROJECT_ID}_1_buggy"
        BUILD_DIR = BUILD_DIRS[PROJECT_ID][SOURCE_KEY]
        BUILD_TEST_DIR = BUILD_DIRS[PROJECT_ID][TESTS_KEY]
        RESULT_DIR = f"{PROJECT_ID}_kanonizo_res/"

        if PROJECT_ID == 'chart':  # remove buggy files if they exist, because it breaks the kanonizo launching.
            buggy_files_dir = f"{PROJECT_DIR}/{BUILD_DIR[:-2]}/org/jfree/chart/servlet"
            remove_file_if_exist(f"{buggy_files_dir}/ChartDeleter.class")
            remove_file_if_exist(f"{buggy_files_dir}/DisplayChart.class")

        COPY_KANONIZO_FILE_QUERY = f"cp {KANONIZO_JAR} {PROJECT_DIR}"
        run_query_from_current_dir(COPY_KANONIZO_FILE_QUERY)

        KANONIZO_RAW_FILES_DIR = f'D4J_projects/{PROJECT_ID}/results/prioritized_orderings/kanonizo/raw'
        Path(KANONIZO_RAW_FILES_DIR).mkdir(parents=True, exist_ok=True)

        for algo_name in ALGO_NAMES:
            print(algo_name)
            RESULT_FILENAME = f"{PROJECT_ID}_{algo_name}_res"
            TEST_RANDOM_QUERY = f"java -jar kanonizo.jar -s {BUILD_DIR} -t {BUILD_TEST_DIR} -a {algo_name} " \
                           f"-Dlog_dir={RESULT_DIR} -Dlog_filename={RESULT_FILENAME}_"
            for i in range(times_launching_algos):
                print(f"{i + 1} file processing")
                run_query_from_d4j_dir(TEST_RANDOM_QUERY + str(i + 1))
                full_results_filename = f'{PROJECT_DIR}/{RESULT_DIR}/ordering/{RESULT_FILENAME}_' + str(i + 1) + '.csv'

                move_query = f"mv {full_results_filename} {KANONIZO_RAW_FILES_DIR}"
                run_query_from_current_dir(move_query)
