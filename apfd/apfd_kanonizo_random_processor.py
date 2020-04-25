import time
import subprocess

PROJECT_ID = "chart"
PROJECT_DIR = f"/home/misha/TCP_tools/defects4j/tmp/{PROJECT_ID}_1_buggy"

BUILD_DIR = "build/"
BUILD_TEST_DIR = "build-tests/"
RESULT_DIR = f"{PROJECT_ID}_kanonizo_res/"
RESULT_FILENAME = f"{PROJECT_ID}_random_res"

TEST_RANDOM_QUERY = f"java -jar kanonizo.jar -s {BUILD_DIR} -t {BUILD_TEST_DIR} -a random " \
               f"-Dlog_dir={RESULT_DIR} -Dlog_filename={RESULT_FILENAME}_"

for i in range(100):
    print(f"{i + 1} file processing")
    exporting_proj_proc = subprocess.Popen(TEST_RANDOM_QUERY + str(i + 1),
                                           shell=True,
                                           executable="/bin/bash", stdout=subprocess.PIPE,
                                           stderr=subprocess.PIPE, cwd=PROJECT_DIR)
    exporting_proj_res = exporting_proj_proc.communicate()
    time.sleep(0.5)
