
def process_5_numeric_orderings_to_ids(PROJECT_ID, PROJECT_DIR, n=5):
    for i in range(1, n + 1):
        full_project_dir = f"{PROJECT_DIR}/{i}"

        with open(f"{full_project_dir}/{PROJECT_ID}_numeric_ordering", "r") as space_file:
            test_ids = []
            for line in space_file:
                if line.strip() == "" or line.split()[0].isalpha():
                    continue
                test_ids.extend(line.split())

        with open(f"{full_project_dir}/{PROJECT_ID}_processed_numeric_ordering", "w") as proc_space_file:
            proc_space_file.write(",".join(test_ids))
