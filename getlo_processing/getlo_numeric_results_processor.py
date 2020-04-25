PROJECT_ID = "chart"

if __name__ == "__main__":
    with open(f"../D4J/{PROJECT_ID}/getlo/{PROJECT_ID}_numeric_ordering", "r") as space_file:
        test_ids = []
        for line in space_file:
            if line.strip() == "" or line.split()[0].isalpha():
                continue
            test_ids.extend(line.split())

    with open(f"../D4J/{PROJECT_ID}/getlo/{PROJECT_ID}_processed_numeric_ordering", "w") as proc_space_file:
        proc_space_file.write(",".join(test_ids))
