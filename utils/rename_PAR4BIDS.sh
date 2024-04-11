#! /bin/sh
#$ -N PAR2BIDS
#$ -S /bin/sh
#$ -j y
#$ -q short.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#$ -u bittencourt
#$ -V

subject=sub-$1
session=1
echo "Running subject: $subject"

OLDPWD=${PWD}
PROJ_DIR=${DIR_DATA_SOURCE}/${subject}/ses-${session}
cd ${PROJ_DIR}

for ii in *.PAR; do sed -i 's/'${subject}'/'${subject}'_ses-'${session}'/g' $ii; done

for run in 1 2 3 4 5
do 
for ii in *.PAR; do sed -i 's/fmri_run'${run}'/task-ret_run-'${run}'_bold/g' $ii; done
done