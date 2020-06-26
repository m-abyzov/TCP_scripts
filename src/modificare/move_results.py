import subprocess

BASE_DIR = "D4J_projects"
MODIFICARE_ALGORITHMS = ['ART_man_avg', 'genetic', 'greedy', 'HC_FA', 'HC_SA', 'random', 'SANN']


def run_from_terminal(query):
    subprocess.Popen(f'{query}', shell=True, executable="/bin/bash",
                     stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()

if __name__ == "__main__":
