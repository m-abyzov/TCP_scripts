import subprocess
import os
from pathlib import Path
from sys import argv as args

ENCODING = 'utf-8'
D4J_MAIN_DIR = args[1].strip()
# D4J_MAIN_DIR = "/home/misha/TCP_tools/defects4j"

D4J_FRAMEWORK_DIR = f'{D4J_MAIN_DIR}/framework/bin'

# Queries for bash:
ENV_PATH = args[2].strip()
# ACTIVATE_ENV_QUERY = "source /home/misha/environments/main/bin/activate"
ACTIVATE_ENV_QUERY = f"source {ENV_PATH}"
ACTIVATE_D4J_QUERY = f'export PATH=$PATH:{D4J_FRAMEWORK_DIR}'

D4J_projects_bugs = {"Chart": 26, "Closure": 176, "Lang": 65, "Math": 106, "Time": 27}


def execute_from_terminal(query, get_error=True):
    full_query = f'{ACTIVATE_ENV_QUERY} && {ACTIVATE_D4J_QUERY} && {query}'
    if get_error:
        exporting_proj_proc = subprocess.Popen(
            full_query, shell=True, executable="/bin/bash", stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
    else:
        exporting_proj_proc = subprocess.Popen(
            full_query, shell=True, executable="/bin/bash", stdout=subprocess.PIPE
        )
    return exporting_proj_proc.communicate()


projects_to_run = args[3:]
for project_id, project_bugs in D4J_projects_bugs.items():
    project_name = project_id.lower()
    if project_name not in projects_to_run:
        continue

    print(f'project {project_id} is processing')
    PROJECT_FOLDER = f'D4J_projects/{project_name}'
    Path(PROJECT_FOLDER).mkdir(parents=True, exist_ok=True)

    RESULT_FILENAME = f"{PROJECT_FOLDER}/{project_name}_bugs_revealing_info.csv"
    if os.path.exists(RESULT_FILENAME):
        os.remove(RESULT_FILENAME)

    for bug_number in range(1, project_bugs + 1):
        PROJECT_TMP_DIR = f'{D4J_MAIN_DIR}/tmp/{project_name}_{bug_number}_buggy'
        Path(f'{D4J_MAIN_DIR}/tmp').mkdir(parents=True, exist_ok=True)

        D4J_EXPORT_PROJECT_QUERY = f'defects4j checkout -p {project_id} -v {bug_number}b -w {PROJECT_TMP_DIR}'
        D4J_EXPORT_FAIL_TEST_QUERY = f'defects4j export -p tests.trigger -w {PROJECT_TMP_DIR}'

        exporting_proj_res = execute_from_terminal(D4J_EXPORT_PROJECT_QUERY)

        if "Version id does not exist" in exporting_proj_res[1].decode(ENCODING):
            output = ""
        else:
            if "FAIL\nExecuted command" in exporting_proj_res[1].decode(ENCODING):
                exporting_proj_res_repeat = execute_from_terminal(D4J_EXPORT_PROJECT_QUERY)

            result = execute_from_terminal(D4J_EXPORT_FAIL_TEST_QUERY, get_error=False)
            output = result[0].decode(ENCODING).strip().replace("\n", ",") if result[0] is not None else ""

        if output != "":
            print(output)

        with open(RESULT_FILENAME, "a+") as result_file:
            result_file.write(output + "\n")

        print(f'bug {bug_number} is extracted')
