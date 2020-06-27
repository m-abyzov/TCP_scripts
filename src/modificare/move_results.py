from sys import argv as args
from os import scandir
import subprocess

BASE_DIR = "D4J_projects"
MODIFICARE_ALGORITHMS = ['ART_man_avg', 'genetic', 'greedy', 'HC_FA', 'HC_SA', 'random', 'SANN']


def run_from_terminal(query):
    subprocess.Popen(f'{query}', shell=True, executable="/bin/bash",
                     stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()

if __name__ == "__main__":
    MODIFICARE_PATH = f"{args[1]}/results"
    evaluation_path = f"{args[2]}/D4J_projects"
    projects = args[3:]
    for project in projects:
        MODIFICARE_PATH += f"/{project}"
        evaluation_path += f"/{project}/results/prioritized_orderings/modificare"
        for algorithm in MODIFICARE_ALGORITHMS:
            for file in scandir(f"{MODIFICARE_PATH}/{algorithm}"):
                query = f"mv {file.path} {evaluation_path}/{algorithm}"
                run_from_terminal(query)
