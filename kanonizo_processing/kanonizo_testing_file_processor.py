KANONIZO_RES_FILE = "../D4J/time/kanonizo/joda_randomsearch_res.csv"
PROCESSED_KANONIZO_RES_FILE = KANONIZO_RES_FILE.replace(KANONIZO_RES_FILE.split("/")[-1], "") \
                              + "processed/processed_" + KANONIZO_RES_FILE.split("/")[-1]

res_string = ""

with open(KANONIZO_RES_FILE, "r") as file_to_process:
    for line_num, line in enumerate(file_to_process):
        if line_num == 0:
            continue

        processed_line = line.split(',')[0]

        method_name = processed_line.split('.')[-1]
        class_name = processed_line.replace(method_name, "")[:-1]

        full_name = f'{class_name}::{method_name}\n'

        res_string += full_name

with open(PROCESSED_KANONIZO_RES_FILE, "w") as processed_file:
    processed_file.write(res_string[:-1])
