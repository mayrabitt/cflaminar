#! /bin/sh
#$ -N antsTransform
#$ -S /bin/sh
#$ -j y
#$ -q long.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#$ -u bittencourt

# Load modules
module load afni
module load ANTs

# Usage: source upsampling.sh sub-xxx
# Upsamples Nifti files

subject=sub-$1
session=1

OLDPWD=${PWD}
PROJ_DIR=/data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp
cd $PROJ_DIR

COREG_DIR=$PROJ_DIR/derivatives/coreg/${subject}/ses-${session}

masked_T1w=${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1w.nii.gz
T2w=${PROJ_DIR}/derivatives/upsampling/${subject}/ses-${session}/anat/${subject}_ses-${session}_acq-3DTSE_T2w.nii.gz
outputPrefix=${COREG_DIR}/out

# Transform masked T1w
#antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${masked_T1w} -r ${masked_T1w} -o ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wWarped.nii.gz -t ${outputPrefix}1Warp.nii.gz -t ${outputPrefix}0GenericAffine.mat #forward transform
#antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${masked_T1w} -r ${masked_T1w} -o ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wWarped.nii.gz -t [${outputPrefix}0GenericAffine.mat, 1] #inverse transform
#cp ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wWarped.nii.gz ${PROJ_DIR}/derivatives/masked_mp2rage/${subject}/ses-${session}/anat/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1w.nii.gz
#antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${masked_T1w} -r ${masked_T1w} -o ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1winitcheck.nii.gz -t ${PROJ_DIR}/derivatives/coreg/${subject}/ses-1/init_coreg.txt
#antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${masked_T1w} -r ${masked_T1w} -o ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wAffine.nii.gz -t ${PROJ_DIR}/derivatives/coreg/${subject}/ses-1/init_coreg.txt #forward transform
cp ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wWarped.nii.gz ${PROJ_DIR}/derivatives/masked_mp2rage/${subject}/ses-${session}/anat/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1w.nii.gz

#Transform T2w

antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${T2w} -r ${T2w} -o ${COREG_DIR}/${subject}_ses-${session}_acq-3DTSE_T2wWarped.nii.gz -t ${outputPrefix}1Warp.nii.gz -t ${outputPrefix}0GenericAffine.mat -t ${PROJ_DIR}/derivatives/coreg/${subject}/ses-1/init_coreg.txt
cp ${COREG_DIR}/${subject}_ses-${session}_acq-3DTSE_T2wWarped.nii.gz ${PROJ_DIR}/${subject}/ses-${session}/anat/${subject}_ses-${session}_acq-3DTSE_T2w.nii.gz
