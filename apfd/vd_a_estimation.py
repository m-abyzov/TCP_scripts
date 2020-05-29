from bisect import bisect_left
from typing import List
import scipy.stats as ss
from apfd import estimate_single_experiment
import os


D4J_ROOT_DIR = "../D4J"


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
        return f"../D4J/D4J_bug_extractor/{PROJECT_ID}_bugs_revealing_info.csv"

    def estimate_getlo_APFDs(project_id, project_path):
        project_getlo_path = f"{project_path}/getlo"
        getlo_APFDs = []
        for i in range(1, n_launches + 1):
            getlo_ordering_file = f"{project_getlo_path}/{i}/{project_id}_tests_ordering"
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
        project_path = f"{D4J_ROOT_DIR}/{project_id}"
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
    with open(f"{D4J_ROOT_DIR}/{project_id}/APFD_projects_tools_statistics.txt", "w") as apfd_file:
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


# def run_custom_example(treatment, control):
#     print(VD_A(treatment, control))


# def run_single_real_experiment():
#     chart_getlo = [0.5543337191764005, 0.5543337191764005, 0.5543337191764005, 0.5543337191764005,
#                    0.5543337191764005]
#     kanonizo_random = [0.6013350574913501, 0.6059483451577954, 0.6245238178450355, 0.5591689092370602,
#                        0.6534267640582953]
#     run_custom_example(chart_getlo, kanonizo_random)


if __name__ == "__main__":
    # run_simple_example()
    projects_list = ['chart']
    # run_single_real_experiment()
    CONTROL_RANDOM_TOOL = 'modificare'

    for project_id in projects_list:
        all_APFDs = estimate_orderings_foreach_project(projects_list, n_launches=10)
        log_results(all_APFDs, project_id)

        # compute and log VD_A statistics results:
        tools_list = ['getlo', 'kanonizo', 'modificare']
        with open(f"{D4J_ROOT_DIR}/{project_id}/VD_A_projects_tools_statistics.txt", "w") as vd_a_file:
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
