import subprocess
import time
from sys import argv as args

D4J_MAIN_DIR = args[1].strip()
# D4J_MAIN_DIR = "/home/misha/TCP_tools/defects4j"
D4J_FRAMEWORK_DIR = f'{D4J_MAIN_DIR}/framework/bin'

# Queries for bash:
# ACTIVATE_ENV_QUERY = "source /home/misha/environments/main/bin/activate"
ENV_PATH = args[2].strip()
ACTIVATE_ENV_QUERY = f"source {ENV_PATH}"
ACTIVATE_D4J_QUERY = f'export PATH=$PATH:{D4J_FRAMEWORK_DIR}'


PROJECT_IDS = args[3:]
for PROJECT_ID in PROJECT_IDS:
    print(f"start measuring test time for \"{PROJECT_ID}\" project:")

    ID_NAME_MAPPING_FILE = F"D4J_projects/{PROJECT_ID}/{PROJECT_ID}_id_name_mapping.txt"

    all_tests_with_time = []
    with open(ID_NAME_MAPPING_FILE, 'r') as all_test_file:
        for test_id, test_name in enumerate(all_test_file):
            test_name = test_name.strip()
            D4J_TEST_QUERY = f'defects4j test -t {test_name}'

            start = time.time_ns()
            exporting_proj_proc = subprocess.Popen(
                f'{ACTIVATE_ENV_QUERY} && {ACTIVATE_D4J_QUERY} && {D4J_TEST_QUERY}',
                shell=True, executable="/bin/bash", stdout=subprocess.PIPE, stderr=subprocess.PIPE
            )
            exporting_proj_proc.communicate()
            all_tests_with_time.append(f"{test_name}\t{time.time_ns() - start}")
            print(f"{(test_id + 1)} tests are executed") if (test_id + 1) % 500 == 0 else ""

    with open(ID_NAME_MAPPING_FILE, 'w') as all_test_file:
        for test_with_time in all_tests_with_time:
            all_test_file.write(test_with_time + "\n")

    print(f"finish measuring test time for \"{PROJECT_ID}\" project:")
    print("---------------------------------------------------------")
