# THIS SCRIPT JUST CALCULATES AVERAGE APFDs ACROSS ALL RANDOM ALGORITHMS IN MODIFICARE TOOL.
# IT IS NOT OBLIGATORY FOR LAUNCHING. ALSO NEED TO TEST IT.

import os
from apfd import read_bugs_info, read_test_order, calculate_APFD

PROJECT_ID = "chart"

DIR_WITH_RANDOM_ORDERINGS = f"../D4J_projects/{PROJECT_ID}/modificare/random"
BUGS_INFO_FILE = f"../D4J_projects/{PROJECT_ID}/{PROJECT_ID}_bugs_revealing_info.csv"

average_random_APFD = 0
tests_revealings, bugs_count = read_bugs_info(BUGS_INFO_FILE)

for file_num, random_ordering_file in enumerate(os.scandir(DIR_WITH_RANDOM_ORDERINGS)):
    random_order_file_path = random_ordering_file.path
    # print("Random filename is:", random_order_file_path)
    calculated_order = read_test_order(random_order_file_path)

    apfd = calculate_APFD(calculated_order, tests_revealings, bugs_count)
    average_random_APFD += apfd

print("file_num:", file_num + 1)
print("Average random APFD is:", round(average_random_APFD / (file_num + 1), 4))