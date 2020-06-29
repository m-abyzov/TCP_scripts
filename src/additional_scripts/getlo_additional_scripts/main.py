from getlo_numeric_results_processor import process_5_numeric_orderings_to_ids
from getlo_name_id_mapper import process_5_ids_orderings_to_test_names
from apfd import estimate_single_experiment


# THis is a Script for calculating APFD for the GeTLO in the chosen
# D4J project.
PROJECT_IDs = ["closure", "lang", "chart", "time", "math"]
# PROJECT_IDS = [PROJECT_ID]

if __name__ == "__main__":
    n = 10
    for PROJECT_ID in PROJECT_IDs:
        PROJECT_DIR = f"../D4J/{PROJECT_ID}/getlo"
        process_5_numeric_orderings_to_ids(PROJECT_ID, PROJECT_DIR, n)
        process_5_ids_orderings_to_test_names(PROJECT_ID, PROJECT_DIR, n)

        APFD_results = []
        BUGS_INFO_PATH = f"../D4J/D4J_bug_extractor/{PROJECT_ID}_bugs_revealing_info.csv"
        for i in range(1, n + 1):
            TEST_ORDER_PATH = f"{PROJECT_DIR}/{i}/{PROJECT_ID}_tests_ordering"
            APFD_results.append(estimate_single_experiment(TEST_ORDER_PATH, BUGS_INFO_PATH, False))

        with open(f'{PROJECT_DIR}/{PROJECT_ID}_GeTLO_{n}_APFDs', 'w') as res_file:
            res_file.write(f"{PROJECT_ID}_GeTLO_{n}_APFDs: {str(APFD_results)}")
