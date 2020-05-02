from pathlib import Path

PROJECT_ID = "lang"
PROJECT_DIR = f"../D4J/{PROJECT_ID}/method_coverage/getlo/2"

if __name__ == "__main__":
    with open(f"{PROJECT_DIR}/{PROJECT_ID}_numeric_ordering", "r") as space_file:
        test_ids = []
        for line in space_file:
            if line.strip() == "" or line.split()[0].isalpha():
                continue
            test_ids.extend(line.split())

    Path(PROJECT_DIR).mkdir(parents=True, exist_ok=True)

    with open(f"{PROJECT_DIR}/{PROJECT_ID}_processed_numeric_ordering", "w") as proc_space_file:
        proc_space_file.write(",".join(test_ids))
