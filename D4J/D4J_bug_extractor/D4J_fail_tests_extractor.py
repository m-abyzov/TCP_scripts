import subprocess
import os

ENCODING = 'utf-8'

D4J_MAIN_DIR = "/home/misha/TCP_tools/defects4j"
D4J_FRAMEWORK_DIR = f'{D4J_MAIN_DIR}/framework/bin'

# Queries for bash:
ACTIVATE_ENV_QUERY = "source /home/misha/environments/main/bin/activate"
ACTIVATE_D4J_QUERY = f'export PATH=$PATH:{D4J_FRAMEWORK_DIR}'


D4J_projects_bugs = {"Chart": 26, "Closure": 176, "Lang": 65, "Math": 106,
                     "Mockito": 38, "Time": 27}

# D4J_projects_bugs = {"Chart": 5}

for project_id, project_bugs in D4J_projects_bugs.items():

    RESULT_FILENAME = f"D4J/D4J_bug_extractor/{project_id.lower()}_bugs_revealing_info"
    if os.path.exists(RESULT_FILENAME):
        os.remove(RESULT_FILENAME)

    for bug_number in range(1, project_bugs + 1):

        PROJECT_TMP_DIR = f'{D4J_MAIN_DIR}/tmp/{project_id.lower()}_{bug_number}_buggy'
        # PROJECT_TMP_DIR = f'{D4J_MAIN_DIR}/tmp/lang_{bug_number}_buggy'
        # D4J_EXPORT_PROJECT_QUERY = f'defects4j checkout -p Lang -v {bug_number}b -w {PROJECT_TMP_DIR}'
        D4J_EXPORT_PROJECT_QUERY = f'defects4j checkout -p {project_id} -v {bug_number}b -w {PROJECT_TMP_DIR}'
        D4J_EXPORT_FAIL_TEST_QUERY = f'defects4j export -p tests.trigger -w {PROJECT_TMP_DIR}'
        # D4J_FULL_EXPORT_QUERY = f'{D4J_EXPORT_PROJECT_QUERY} && {D4J_EXPORT_FAIL_TEST_QUERY}'


        exporting_proj_proc = subprocess.Popen(f'{ACTIVATE_ENV_QUERY} && {ACTIVATE_D4J_QUERY} && {D4J_EXPORT_PROJECT_QUERY}',
                                shell=True, executable="/bin/bash", stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        exporting_proj_res = exporting_proj_proc.communicate()

        if "Version id does not exist" in exporting_proj_res[1].decode(ENCODING):
            output = ""
        else:
            if "FAIL\nExecuted command" in exporting_proj_res[1].decode(ENCODING):
                exporting_proj_proc_repeat = subprocess.Popen(f'{ACTIVATE_ENV_QUERY} && {ACTIVATE_D4J_QUERY} && {D4J_EXPORT_PROJECT_QUERY}',
                    shell=True, executable="/bin/bash", stdout=subprocess.PIPE, stderr=subprocess.PIPE)

                exporting_proj_res_repeat = exporting_proj_proc_repeat.communicate()

            proc_test = subprocess.Popen(f'{ACTIVATE_ENV_QUERY} && {ACTIVATE_D4J_QUERY} && {D4J_EXPORT_FAIL_TEST_QUERY}',
                shell=True, executable="/bin/bash", stdout=subprocess.PIPE)

            result = proc_test.communicate()

            output = result[0].decode(ENCODING).strip().replace("\n", ",") if result[0] is not None else ""

        if output != "":
            print(output)

        with open(RESULT_FILENAME, "a+") as result_file:
            result_file.write(output + "\n")


# subprocess.call(["source " + conda_activation_file + " && conda activate " + conda_environment + " && " + query],
#                         executable="/bin/bash", shell=True)
