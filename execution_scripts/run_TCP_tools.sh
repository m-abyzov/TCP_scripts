# provide 3 args (dirs actual for your machine):
# 1) Path till the Defects4J project dir , e.g. "/home/misha/TCP_tools/defects4j"
# ?) Path till the current project, e.g. "/home/misha/PycharmProjects/TCP_scripts"
# TODO: Uncomment for all the projects!
#projects=(chart lang math closure time)
projects=(chart)

# Preprocess and copy data to the GeTLO dir
python ./src/getlo/getlo_data_processing/getlo_coverage_preprocessor.py ${projects[*]}


# Copy data and run the Modificare tool.
#python ./src/modificare/prepare_folders.py ${projects[*]}
#cd tools/modificare/
#Rscript run_experiments.R ${projects[*]}

# Run the Kanonizo tool:
#python ./src/kanonizo/run_kanonizo.py $1 ${projects[*]}
#python ./src/kanonizo/kanonizo_res_file_processor.py ${projects[*]}

# Launching via, e.g.
# . execution_scripts/run_TCP_tools.sh "/home/misha/TCP_tools/GeTLO" "/home/misha/TCP_tools/modificare" "/home/misha/PycharmProjects/TCP_scripts"