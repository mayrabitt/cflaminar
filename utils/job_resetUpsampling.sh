#! /bin/sh
#$ -N resetUpsampling
#$ -S /bin/sh
#$ -j y
#$ -q long.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#$ -u bittencourt
#$ -V

subject=sub-$1
session=1
echo "Running subject: $subject"

OLDPWD=${PWD}
PROJ_DIR=/data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp
cd $PROJ_DIR

# ANAT
# Upsampling nifti and copying json files from original bids folder to derivatives/upsampling

UP_DIR=$PROJ_DIR/derivatives/upsampling/${subject}/ses-${session}/anat
if [[ ! -d $UP_DIR ]]; then
  echo "Creating anat folder"
  mkdir -p $UP_DIR
else
  echo "anat folder already exists."
fi
for suffix in acq-MP2RAGE_T1w acq-MP2RAGE_desc-spm_mask acq-MP2RAGE_T1map acq-3DTSE_T2w acq-MP2RAGE_desc-masked_T1w desc-benson_mask
do
  if [[ ${suffix} == "acq-3DTSE_T2w" ]]; then
  NII_DIR=$PROJ_DIR/derivatives/pymp2rage/${subject}/ses-${session}
  elif [[ ${suffix} == "acq-MP2RAGE_desc-masked_T1w" ]]; then
  NII_DIR=$PROJ_DIR/derivatives/masked_mp2rage/${subject}/ses-${session}/anat
  elif [[ ${suffix} == "desc-benson_mask" ]]; then
  NII_DIR=${DIR_DATA_DERIV}/benson_mask/${subject}/ses-${session}
  else
  NII_DIR=$PROJ_DIR/derivatives/denoised/${subject}/ses-${session}
  fi
  # Recovering original resolution files and deleting upsampled files
  if [[ -f ${UP_DIR}/${subject}_ses-${session}_${suffix}_ores.nii.gz ]]; then
    cp ${UP_DIR}/${subject}_ses-${session}_${suffix}_ores.nii.gz ${NII_DIR}/${subject}_ses-${session}_${suffix}.nii.gz
    rm ${UP_DIR}/${subject}_ses-${session}_${suffix}.nii.gz
    echo "Backup of original resolution ${suffix} recovered."
  else
    echo "Backup of original resolution ${suffix} does not exist."
  fi
echo "Ready to re-run anatomical Upsampling."
done
