from bisect import bisect_left
from pathlib import Path
from typing import List
import scipy.stats as ss
import matplotlib.pyplot as plt
from apfd import estimate_single_experiment
import os
import numpy as np
from sys import argv as args

D4J_ROOT_DIR = "D4J_projects"


def VD_A(treatment: List[float], control: List[float]):
    """
    Code of this function has taken from:
    https://gist.github.com/jacksonpradolima/f9b19d65b7f16603c837024d5f8c8a65
    Computes Vargha and Delaney A index
    A. Vargha and H. D. Delaney.
    A critique and improvement of the CL common language
    effect size statistics of McGraw and Wong.
    Journal of Educational and Behavioral Statistics, 25(2):101-132, 2000
    The formula to compute A has been transformed to minimize accuracy errors
    See: http://mtorchiano.wordpress.com/2014/05/19/effect-size-of-r-precision/
    :param treatment: a numeric list
    :param control: another numeric list
    :returns the value estimate and the magnitude
    """
    m = len(treatment)
    n = len(control)

    if m != n:
        raise ValueError("Data d and f must have the same length")

    r = ss.rankdata(treatment + control)
    r1 = sum(r[0:m])

    # Compute the measure
    # A = (r1/m - (m+1)/2)/n # formula (14) in Vargha and Delaney, 2000
    A = (2 * r1 - m * (m + 1)) / (2 * n * m)  # equivalent formula to avoid accuracy errors

    levels = [0.147, 0.33, 0.474]  # effect sizes from Hess and Kromrey, 2004
    magnitude = ["negligible", "small", "medium", "large"]
    scaled_A = (A - 0.5) * 2

    magnitude = magnitude[bisect_left(levels, abs(scaled_A))]
    estimate = A

    return estimate, magnitude


def run_simple_example():
    # An example of medium effect:
    C = [0.9108333333333334, 0.8755555555555556, 0.900277777777778, 0.9274999999999999, 0.8777777777777779]
    E = [0.8663888888888888, 0.8802777777777777, 0.7816666666666667, 0.8377777777777776, 0.9305555555555556]
    print(VD_A(C, E))


def estimate_orderings_foreach_project(project_list, n_launches=5):
    def get_bugs_info_path_by_project_id(PROJECT_ID):
        return f"{D4J_ROOT_DIR}/{PROJECT_ID}/{PROJECT_ID}_bugs_revealing_info.csv"

    def estimate_getlo_APFDs(project_id, project_path):
        project_getlo_path = f"{project_path}/getlo/processed"
        getlo_APFDs = []
        for i in range(n_launches):
            getlo_ordering_file = f"{project_getlo_path}/{project_id}_tests_ordering"
            getlo_APFDs.append(
                estimate_single_experiment(getlo_ordering_file,
                                           get_bugs_info_path_by_project_id(project_id),
                                           print_orders=False)
            )
        return getlo_APFDs

    def estimate_kanonizo_modificare_APFDs(project_id, tool_results_path):
        APFDs = {}
        if os.path.isdir(tool_results_path):
            for algorithms_dir in os.scandir(tool_results_path):
                APFDs[algorithms_dir.name] = []
                for i, algo_result_file in enumerate(os.scandir(algorithms_dir)):
                    if i + 1 > n_launches:
                        break
                    APFDs[algorithms_dir.name].append(estimate_single_experiment(
                        algo_result_file.path,
                        get_bugs_info_path_by_project_id(project_id),
                        print_orders=False)
                    )
        return APFDs

    all_APFDs = {}
    for project_id in project_list:
        project_path = f"{D4J_ROOT_DIR}/{project_id}/results/prioritized_orderings"
        all_APFDs[f'{project_id}_getlo'] = estimate_getlo_APFDs(
            project_id, project_path)

        kanonizo_results_path = f"{project_path}/kanonizo/processed"
        all_APFDs[f'{project_id}_kanonizo'] = estimate_kanonizo_modificare_APFDs(
            project_id, kanonizo_results_path)

        modificare_results_path = f"{project_path}/modificare"
        all_APFDs[f'{project_id}_modificare'] = estimate_kanonizo_modificare_APFDs(
            project_id, modificare_results_path)
    return all_APFDs


def log_results(all_APFDs, project_id):
    with open(f"{get_results_folder_by_id(project_id)}/{project_id}_APFD_projects_tools_statistics.txt", "w") as apfd_file:
        for tool_name, tool_results in all_APFDs.items():
            if project_id not in tool_name:
                continue

            if 'getlo' in tool_name:
                apfd_file.write(f"{tool_name}: {tool_results}, avg: {round(sum(tool_results) / len(tool_results), 5)}\n")
                continue

            apfd_file.write(f"{tool_name}: [\n")
            for algo_name, algo_results in tool_results.items():
                apfd_file.write(f"\t{algo_name}: {algo_results}, avg: {round(sum(algo_results) / len(algo_results), 5)}\n")
            apfd_file.write(f"\t]\n")


def plot_whiskers_diagrams():
    def set_labels_to_whiskers(algo_names):
        for i in range(len(algo_names)):
            algo_names[i] = algo_names[i].replace('kanonizo_', 'K ')
            algo_names[i] = algo_names[i].replace('modificare_', 'M ')
            algo_names[i] = algo_names[i].replace('ART_man_avg', 'ART')
            algo_names[i] = algo_names[i].replace('randomsearch', 'random search')
            algo_names[i] = algo_names[i].replace('geneticalgorithm', 'genetic')
            algo_names[i] = algo_names[i].replace('additionalgreedy', 'additional greedy')
        ax1.set_xticklabels(algo_names, rotation=45, fontsize=8)

    position = 0
    def draw_plot(data):
        nonlocal position
        for sample in data:
            data_sample = sample[0]
            color = sample[1]
            bp = ax1.boxplot(data_sample, patch_artist=sample[1], positions=[position + 0.4])

            plt.setp(bp['medians'], color='black')
            if color:
                for element in ['boxes', 'fliers', 'means', 'caps']:
                    plt.setp(bp[element], color='gray')
            position += 0.4

    for project_id in projects_list:
        results = dict()
        for tool_id in tools_list:
            if tool_id == 'getlo':
                results[tool_id] = (all_APFDs[f'{project_id}_{tool_id}'], False)
            else:
                for algo_name, treatment_results in all_APFDs[f'{project_id}_{tool_id}'].items():
                    if tool_id == 'kanonizo':
                        results[f'{tool_id}_{algo_name}'] = (treatment_results, False)
                    else:
                        results[f'{tool_id}_{algo_name}'] = (treatment_results, True)

        fig1, ax1 = plt.subplots()
        ax1.set_title(project_id)
        sort_res = {k: v for k, v in sorted(results.items(), key=lambda item: np.median(item[1][0]), reverse=True)}
        draw_plot(sort_res.values())
        algo_names = list(sort_res.keys())
        set_labels_to_whiskers(algo_names)
        plt.ylabel('APFD score')
        plt.plot()

        # Show the major grid lines with dark grey lines
        plt.grid(which='major', color='#777777', alpha=0.8)

        # Show the minor grid lines with very faint and almost transparent grey lines
        plt.minorticks_on()
        plt.grid(which='minor', color='#999999', alpha=0.2)
        plt.style.use('grayscale')
        plt.savefig(f'{get_results_folder_by_id(project_id)}/{project_id}_APFDs.png')

    plt.show()


def create_results_folder(projects_list):
    for project_id in projects_list:
        Path(f"{D4J_ROOT_DIR}/{project_id}/results").mkdir(parents=True, exist_ok=True)


def get_results_folder_by_id(project_id):
    return f"{D4J_ROOT_DIR}/{project_id}/results"


if __name__ == "__main__":
    projects_list = args[1:]
    create_results_folder(projects_list)
    n_launches = 20
    CONTROL_RANDOM_TOOL = 'modificare'

    all_APFDs = estimate_orderings_foreach_project(projects_list, n_launches=n_launches)
    # compute and log VD_A statistics results:
    tools_list = ['getlo', 'kanonizo', 'modificare']
    plot_whiskers_diagrams()

    for project_id in projects_list:
        log_results(all_APFDs, project_id)
        with open(f"{get_results_folder_by_id(project_id)}/{project_id}_VD_A_projects_tools_statistics.txt", "w") as vd_a_file:
            vd_a_file.write(f"VD_A for {project_id} project:\n")
            control_results = all_APFDs[f"{project_id}_{CONTROL_RANDOM_TOOL}"]['random']
            for tool_id in tools_list:
                if tool_id == 'getlo':
                    treatment_results = all_APFDs[f'{project_id}_{tool_id}']
                    vd_a_file.write(f"VD_A(treatment=getlo, control={CONTROL_RANDOM_TOOL}_random) = {VD_A(treatment_results, control_results)}\n")
                else:
                    for algo_name, treatment_results in all_APFDs[f'{project_id}_{tool_id}'].items():
                        if tool_id == CONTROL_RANDOM_TOOL and algo_name == 'random':
                            continue  # because it is the control group.
                        vd_a_file.write(
                            f"VD_A(treatment={tool_id}_{algo_name}, control={CONTROL_RANDOM_TOOL}_random) = {VD_A(treatment_results, control_results)}\n"
                        )
            vd_a_file.write('\n')
