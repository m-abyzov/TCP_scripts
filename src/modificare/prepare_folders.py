import subprocess
from pathlib import Path
from sys import argv as args

BASE_DIR = "D4J_projects"
MODIFICARE_ALGORITHMS = ['ART_man_avg', 'genetic', 'greedy', 'HC_FA', 'HC_SA', 'random', 'SANN']


# def run_from_terminal(query):
#     subprocess.Popen(f'{query}', shell=True, executable="/bin/bash",
#                      stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()


def create_results_folders(project_id):
    RESULTS_FOLDER = f'{BASE_DIR}/{project_id}/results/prioritized_orderings/modificare'
    # MODIFICARE_RESULTS_FOLDER = f'{modificare_path}/results/{project_id}'
    for algo_name in MODIFICARE_ALGORITHMS:
        Path(f'{RESULTS_FOLDER}/{algo_name}').mkdir(parents=True, exist_ok=True)
        # Path(f'{MODIFICARE_RESULTS_FOLDER}/{algo_name}').mkdir(parents=True, exist_ok=True)


if __name__ == "__main__":
    # modificare_path = args[1]
    # coverage_matrix_path = f'{modificare_path}/reqMatrices/D4J_method_matrices'
    # timing_file_path = f'{modificare_path}/reqMatrices/TimingsFiles'
    projects_to_run = args[1:]
    for project in projects_to_run:
        create_results_folders(project)
        # copy_matrix_query = f'cp D4J_projects/{project}/{project}_method_coverage_matrix.txt {coverage_matrix_path}'
        # run_from_terminal(copy_matrix_query)
        # copy_timing_file_query = f'cp D4J_projects/{project}/{project}_id_name_mapping.txt {timing_file_path}'
        # run_from_terminal(copy_timing_file_query)
