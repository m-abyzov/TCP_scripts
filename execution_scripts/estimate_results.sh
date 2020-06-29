# This is a script for obtaining VD-A statistics, APFD values
# and whiskers plots, based on the obtained results orderings.
#
# Launching via
# . execution_scripts/estimate_results.sh

#projects=(chart lang math closure time)
projects=(chart lang)

python ./src/apfd/vd_a_estimation.py ${projects[*]}
