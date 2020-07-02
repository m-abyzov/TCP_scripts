# This is the script for launching experiments with the GeTLO, Kanonizo, and
# Modificare test case prioritization tools.
#
# provide 1 arg (dir actual for your machine):
# 1) Path till the Defects4J home dir , e.g. "/home/misha/TCP_tools/defects4j"
#
# Launching via, e.g.
# . execution_scripts/run_TCP_tools.sh "/home/misha/TCP_tools/defects4j"

#projects=(chart lang math closure time)
projects=(chart lang)


# Run the Kanonizo tool:
python ./src/kanonizo/run_kanonizo.py $1 ${projects[*]}
python ./src/kanonizo/kanonizo_res_file_processor.py ${projects[*]}

# Preprocess and copy data to the GeTLO dir. Then run the GeTLO prioritization tool.
python ./src/getlo/getlo_coverage_preprocessor.py ${projects[*]}
cd tools/getlo
depth=1
for project in "${projects[@]}"
do
  a="${project}_getlo_method_coverage_matrix.txt"
  dir_to_save="../../D4J_projects/${project}/results/prioritized_orderings/getlo/raw/${project}_getlo_depth_${depth}.txt"
  echo $dir_to_save
  matlab -nodisplay -nosplash -nodesktop -r "GeTLO(load('${a}'), ${depth}, '${dir_to_save}');exit;"
done
python ./src/getlo/getlo_name_id_mapper.py ${projects[*]}  # postprocess GeTLO.
cd ../..

# Copy data and run the Modificare tool.
python ./src/modificare/prepare_folders.py ${projects[*]}
cd tools/modificare/
Rscript run_experiments.R ${projects[*]}
cd ../..
