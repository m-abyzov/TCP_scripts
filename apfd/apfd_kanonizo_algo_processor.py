import time
import subprocess

# TODO: specify these params before launching
PROJECT_ID = "chart"
PROJECT_DIR = f"/home/misha/TCP_tools/defects4j/tmp/{PROJECT_ID}_1_buggy"

BUILD_DIR = "build/"
BUILD_TEST_DIR = "build-tests/"
RESULT_DIR = f"{PROJECT_ID}_kanonizo_res/"

ALGO_NAMES = ["additionalgreedy", "greedy", "randomsearch",
              "geneticalgorithm", "random"]
times_launching_algos = 10

for algo_name in ALGO_NAMES:
    print(algo_name)
    RESULT_FILENAME = f"{PROJECT_ID}_{algo_name}_res"
    TEST_RANDOM_QUERY = f"java -jar kanonizo.jar -s {BUILD_DIR} -t {BUILD_TEST_DIR} -a {algo_name} " \
                   f"-Dlog_dir={RESULT_DIR} -Dlog_filename={RESULT_FILENAME}_"
    for i in range(times_launching_algos):
        print(f"{i + 1} file processing")
        exporting_proj_proc = subprocess.Popen(TEST_RANDOM_QUERY + str(i + 1),
                                               shell=True,
                                               executable="/bin/bash", stdout=subprocess.PIPE,
                                               stderr=subprocess.PIPE, cwd=PROJECT_DIR)
        exporting_proj_res = exporting_proj_proc.communicate()
        time.sleep(0.5)
