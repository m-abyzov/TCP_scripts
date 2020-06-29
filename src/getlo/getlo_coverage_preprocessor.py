from pathlib import Path

import pandas as pd
import numpy as np
from sys import argv as args

BASE_DIR = f'D4J_projects'

if __name__ == "__main__":
    projects = args[1:]
    for project_id in projects:
        coverage_matrix_path = f'{BASE_DIR}/{project_id}/{project_id}_method_coverage_matrix.txt'
        coverage_df = pd.read_csv(coverage_matrix_path, sep=" ", header=None)
        coverage_df = coverage_df.iloc[:, :-1]  # remove last column
        coverage_df = coverage_df[:-1]  # remove last row
        processed_matrix_path = f'tools/getlo/{project_id}_getlo_method_coverage_matrix.txt'
        np.savetxt(processed_matrix_path, coverage_df.T.values, fmt='%d')

        GETLO_RAW_FILES_DIR = f'{BASE_DIR}/{project_id}/results/prioritized_orderings/getlo/raw'
        Path(GETLO_RAW_FILES_DIR).mkdir(parents=True, exist_ok=True)
