# THIS IS ALSO NOT OBLIGATORY SCRIPT FOR LAUNCHING. USE IT IN CASE IF YOU WANT TO RENAME ALL THE GENERATED
# COVERAGE REPORTS. ALSO IF YOU WANT RUN IT CHANGE THE DIRECTORY AND RULES OF RENAMING.

import subprocess
import os

REPORT_DIR = "/home/misha/TCP_tools/CoberturaCoverageParser/coverage_files"

queries = []
files_data = dict()
for file in os.scandir(REPORT_DIR):
    # strings = get_file_strings(file.path)
    raw_test_method_name = file.name.split("Test_")[1]
    test_class_name = file.name.replace(raw_test_method_name, "")

    test_method_name = raw_test_method_name
    while test_method_name[0] == "_":
        test_method_name = test_method_name[1:]
    test_method_name = test_method_name.replace('.xml', "")

    new_filename = f'{test_class_name}__{test_method_name}.xml'

    queries.append(f"mv {file.name} {new_filename}")


# for query in queries:
import time
prev_i = 0
for i in range(100, len(queries), 100):
    partial_query = " && ".join(queries[prev_i: i])
    exporting_proj_proc = subprocess.Popen(partial_query,
                                           shell=True,
                                           executable="/bin/bash", stdout=subprocess.PIPE,
                                           stderr=subprocess.PIPE, cwd=REPORT_DIR)
    exporting_proj_res = exporting_proj_proc.communicate()
    prev_i = i
    time.sleep(0.5)

partial_query = " && ".join(queries[prev_i:])
exporting_proj_proc = subprocess.Popen(partial_query,
                                           shell=True,
                                           executable="/bin/bash", stdout=subprocess.PIPE,
                                           stderr=subprocess.PIPE, cwd=REPORT_DIR)
exporting_proj_res = exporting_proj_proc.communicate()