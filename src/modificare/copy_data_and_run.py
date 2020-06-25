import subprocess
from sys import argv as args


def run_from_terminal(query):
    proc = subprocess.Popen(f'{query}', shell=True, executable="/bin/bash", stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    proc.communicate()


if __name__ == "__main__":
    modificare_path = args[1]
    coverage_matrix_path = f'{modificare_path}/reqMatrices/D4J_method_matrices'
    timing_file_path = f'{modificare_path}/reqMatrices/TimingsFiles'
    projects_to_run = args[2:]
    for project in projects_to_run:
        copy_matrix_query = f'cp D4J_projects/{project}/{project}_method_coverage_matrix.txt {coverage_matrix_path}'
        run_from_terminal(copy_matrix_query)
        copy_timing_file_query = f'cp D4J_projects/{project}/{project}_id_name_mapping.txt {timing_file_path}'
        run_from_terminal(copy_timing_file_query)
