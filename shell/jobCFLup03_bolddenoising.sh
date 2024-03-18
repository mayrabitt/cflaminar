#! /bin/sh
#$ -N bold_denoising
#$ -S /bin/sh
#$ -j y
#$ -q short.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#$ -u bittencourt

# Usage: source script.sh xxx / qsub -V script.sh 001
subject=sub-$1
session=1

PROJ_DIR=${DIR_DATA_HOME}

mv -v ${PROJ_DIR}/${subject}/ses-${session}/func ${PROJ_DIR}/${subject}/ses-${session}/orig
#mv -v ${PROJ_DIR}/${subject}/ses-${session}/phase ${PROJ_DIR}/${subject}/ses-${session}/orig2
mkdir ${PROJ_DIR}/${subject}/ses-${session}/func
#mkdir ${PROJ_DIR}/${subject}/ses-${session}/phase

#Organize files and folders from fmriprep to home folder to run nordic
for suffix in ret_run-1 ret_run-2 ret_run-3 ret_run-4 ret_run-5 ret_run-6
do
  old_filename=${subject}_ses-${session}_task-${suffix}_desc-preproc_bold
  new_filename=${subject}_ses-${session}_task-${suffix}_desc-nordic_bold
  cp ${PROJ_DIR}/derivatives/fmriprep/${subject}/ses-${session}/func/${old_filename}.nii.gz ${PROJ_DIR}/${subject}/ses-${session}/func/${new_filename}.nii.gz
  cp ${PROJ_DIR}/${subject}/ses-${session}/orig/${subject}_ses-${session}_task-${suffix}_bold.json ${PROJ_DIR}/${subject}/ses-${session}/func/${new_filename}.json
  #cp ${PROJ_DIR}/${subject}/ses-${session}/orig2/${old_filename}_ph.nii.gz ${PROJ_DIR}/${subject}/ses-${session}/phase/${new_filename}_ph.nii.gz
  #cp ${PROJ_DIR}/${subject}/ses-${session}/orig2/${subject}_ses-${session}_task-${suffix}_bold_ph.json ${PROJ_DIR}/${subject}/ses-${session}/func/${new_filename}_ph.json
done

master -m 10 -s $1 --sge --mag -q short.q #Nordic, magnitude only
#master -m 16 -s $1 --sge --func #Pybest, on volume space
