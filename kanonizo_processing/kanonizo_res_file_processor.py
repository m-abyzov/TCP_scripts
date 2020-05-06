from pathlib import Path
import os

PROJECT_IDs = ["chart"]
D4J_ROOT_DIR = "../D4J"


def construct_filename(raw_file_path):
    """
    Creates dir for the processed files, and returns filename of the
    file, into which processed test names will be written.
    :param raw_file_path: filepath to the raw (as it produced by the
    tool) Kanonizo results.
    :return: filename of the file, into which processed test names
    will be written.
    """
    # name of the algo inside kanonizo. It should be in the filename
    # after first '_' symbol.
    algo_name = raw_file_path.split('/')[-1].split('_')[1]
    processed_file_path = '/'.join(
        raw_file_path.split('/')[:-2] + ['processed'] + [algo_name]
    )
    # creating a folder 'processed' in the D4J project dir.
    Path(processed_file_path).mkdir(parents=True, exist_ok=True)

    # full processed filepath with filename.
    return (processed_file_path
            + f"/processed_{raw_file_path.split('/')[-1]}")


if __name__ == "__main__":
    for PROJECT_ID in PROJECT_IDs:
        KANONIZO_RAW_FILES_DIR = f"{D4J_ROOT_DIR}/{PROJECT_ID}/kanonizo/raw"
        for file in os.scandir(KANONIZO_RAW_FILES_DIR):
            raw_file_path = file.path

            # read the raw file
            res_string = ""
            with open(raw_file_path, "r") as file_to_process:
                for line_num, line in enumerate(file_to_process):
                    if line_num == 0:
                        continue

                    processed_line = line.split(',')[0]
                    method_name = processed_line.split('(')[0]

                    full_name = f'{processed_line.split("(")[1][:-1]}::{method_name}\n'
                    res_string += full_name

            # write to the processed file.
            processed_file_path = construct_filename(file.path)
            with open(processed_file_path, "w") as processed_file:
                processed_file.write(res_string[:-1])
