# provide 3 args (dirs actual for your machine):
# 1) Path till the cloned GeTLO project, e.g. "/home/misha/TCP_tools/GeTLO"
# 2) Path till the cloned Modificare project, e.g. "/home/misha/TCP_tools/modificare"
# TODO: Uncomment for all the projects!
#projects=(chart lang math closure time)
projects=(chart lang)

python ./src/getlo/getlo_data_processing/getlo_coverage_preprocessor.py $1 ${projects[*]}