from pathlib import Path

PROJECT_ID = "chart"

KANONIZO_RES_FILE = f"../D4J/chart/kanonizo/chart_random_res_2.csv"
PROCESSED_KANONIZO_RES_FILE = KANONIZO_RES_FILE.replace(KANONIZO_RES_FILE.split("/")[-1], "") \
                              + "processed/processed_" + KANONIZO_RES_FILE.split("/")[-1]

Path("/".join(PROCESSED_KANONIZO_RES_FILE.split('/')[:-1])).mkdir(parents=True, exist_ok=True)

res_string = ""

with open(KANONIZO_RES_FILE, "r") as file_to_process:
    for line_num, line in enumerate(file_to_process):
        if line_num == 0:
            continue

        processed_line = line.split(',')[0]
        method_name = processed_line.split('(')[0]
        # if len(processed_line.split("(")) == 1:
        #     print()

        full_name = f'{processed_line.split("(")[1][:-1]}::{method_name}\n'

        res_string += full_name

with open(PROCESSED_KANONIZO_RES_FILE, "w") as processed_file:
    processed_file.write(res_string[:-1])
