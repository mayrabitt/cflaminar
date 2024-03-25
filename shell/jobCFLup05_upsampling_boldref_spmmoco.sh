#! /bin/sh
#$ -N ups_boldref
#$ -S /bin/sh
#$ -j y
#$ -q short.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#$ -u bittencourt

# Load modules
module load afni

# Usage: source upsampling.sh sub-xxx / qsub -V script.sh sub-xxx
# Upsamples Nifti files

subject=sub-$1
session=1

module load fsl

OLDPWD=${PWD}
PROJ_DIR=/data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp
cd $PROJ_DIR

# Boldref
# Upsampling nifti and copying json files from original bids folder to derivatives/upsampling

denoising='nordic'

UP_DIR=$PROJ_DIR/derivatives/upsampling/${subject}/ses-${session}/func/${denoising}

if [[ ! -d $UP_DIR ]]; then
  echo "$UP_DIR does not exist. Run upsampling_func."
  exit 1
fi

NII_DIR=$PROJ_DIR/derivatives/spm/${subject}/ses-1/func
suffix='ret_run-1' 
filename=${subject}_ses-${session}_task-${suffix}_boldref
if [[ ! -f ${UP_DIR}/${filename}_ores.nii.gz ]]; then
cp ${NII_DIR}/${filename}.nii.gz ${UP_DIR}/${filename}_ores.nii.gz
else
echo "backup of original resolution ${suffix} file already exists"
fi
3dresample -dxyz 0.4 0.4 0.4 -rmode Cubic -prefix ${UP_DIR}/${filename}.nii.gz -input ${NII_DIR}/${filename}.nii.gz -overwrite
echo "replaced original ${suffix} file by upsampled in ${UP_DIR}."

cd ${OLDPWD}
