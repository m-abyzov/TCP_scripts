
def read_test_order(test_order_file="example_info/calc_ordering"):
    calculated_order = []
    with open(test_order_file, "r") as result_ordering_file:
        for test_name in result_ordering_file:
            calculated_order.append(test_name.strip())
    return calculated_order


def remove_blank_lines_from_bugs_file(bugs_info_file):
    # preprocess bugs info file
    processed_string = ""
    with open(bugs_info_file, "r") as bugs_file:
        for line in bugs_file:
            if line == "" or line == "\n":
                continue
            processed_string += line

    if processed_string[-1] == "\n":
        processed_string = processed_string[:-1]

    with open(bugs_info_file, "w") as bugs_file:
        bugs_file.write(processed_string)


def read_bugs_info(bugs_info_file="example_info/bugs_revealing_info.csv"):
    remove_blank_lines_from_bugs_file(bugs_info_file)

    # tests_revealings dict in format test_name: [bug1, bug2...] with matching
    # of which test reveals which bug.
    tests_revealings = dict()

    with open(bugs_info_file, "r") as bugs_info_file:
        for bug_num, revealing_bug_test_names in enumerate(bugs_info_file):
            test_names = revealing_bug_test_names.split(',')
            test_names = [test_name.strip() for test_name in test_names]
            for test_name in test_names:
                if test_name not in tests_revealings:
                    tests_revealings[test_name] = []
                tests_revealings[test_name].append(bug_num + 1)
        bugs_count = bug_num + 1

    return tests_revealings, bugs_count


def calculate_APFD(tests_order, test_info, bugs_count):
    apfd_numerator = 0
    previously_revealed_bugs = set()
    for test_id, test_name in enumerate(tests_order):
        order_num = test_id + 1
        revealed_bugs = test_info[test_name] if test_name in test_info else []
        for revealed_bug in revealed_bugs:
            if revealed_bug not in previously_revealed_bugs:
                apfd_numerator += order_num

        previously_revealed_bugs.update(revealed_bugs)

    n = len(tests_order)
    apfd = 1 - apfd_numerator / (n * bugs_count) + 1 / (2 * n)
    print("Calculated APFD value is:", apfd)
    return apfd


if __name__ == "__main__":
    calculated_order = read_test_order(
        "D4J/time/modificare/time_random_orderings/time_random_ordering_10.txt")
    # calculated_order = read_test_order("sudoku/gelations/gelations_sudoku_test_order")
    # tests_revealings, bugs_count = read_bugs_info("sudoku/bugs_revealing_info.csv")
    tests_revealings, bugs_count = read_bugs_info("D4J/D4J_bug_extractor/time_bugs_revealing_info.csv")
    print(calculated_order)
    print(tests_revealings)

    apfd = calculate_APFD(calculated_order, tests_revealings, bugs_count)
