#! /bin/sh
#$ -N coreg_anat2func
#$ -S /bin/sh
#$ -j y
#$ -q long.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#$ -u bittencourt

# Load modules
module load afni
module load ANTs

#set number of cores
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=15

echo "number of cores: ${ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS}"

# Usage: source job_coreg.sh xxx OR SoGE: qsub -V job_coreg.sh 001
# Upsamples Nifti files

subject=sub-$1
session=1

OLDPWD=${PWD}
PROJ_DIR=/data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp
cd $PROJ_DIR

COREG_DIR=$PROJ_DIR/derivatives/coreg/${subject}/ses-${session}
if [[ ! -d $COREG_DIR ]]; then
  echo "Creating coreg folder"
  mkdir -p $COREG_DIR
else
  echo "$COREG_DIR folder already exists."
fi

Fixed=${COREG_DIR}/${subject}_ses-${session}_task-ret_run-1_boldref.nii.gz
FixedN4=${COREG_DIR}/${subject}_ses-${session}_task-ret_run-1_boldrefN4.nii.gz
Moving=${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1w.nii.gz
spmMask=${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-spm_mask.nii.gz
bensonMask=${COREG_DIR}/${subject}_ses-${session}_desc-benson_mask.nii.gz

UP_DIR=$PROJ_DIR/derivatives/upsampling/${subject}/ses-${session} #folder with upsampled outputs
if [[ ! -d $Moving ]]; then
  cp $UP_DIR/func/nordic/${subject}_ses-${session}_task-ret_run-1_boldref.nii.gz $Fixed
fi

if [[ ! -d $Fixed ]]; then
  cp $UP_DIR/anat/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1w.nii.gz $Moving
fi

if [[ ! -d $spmMask ]]; then
  cp $UP_DIR/anat/${subject}_ses-${session}_acq-MP2RAGE_desc-spm_mask.nii.gz $spmMask
fi

if [[ ! -d $bensonMask ]]; then
  cp $UP_DIR/anat/${subject}_ses-${session}_desc-benson_mask.nii.gz $bensonMask
fi

if [[ ! ${COREG_DIR}/init_coreg.txt ]]; then
  #reset number of threads
  export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
  echo "Missing init_coreg.txt in ${COREG_DIR}."
  exit 0
fi
#
# antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${Moving} -r ${Moving} -o ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wInit.nii.gz -t ${COREG_DIR}/init_coreg.txt #initial coreg
# Moving=${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wInit.nii.gz

slabMask=${COREG_DIR}/${subject}_ses-${session}_desc-slabmask.nii.gz
bensonslabMask=${COREG_DIR}/${subject}_ses-${session}_desc-benson_slabmask.nii.gz

#Create slab mask
3dresample -master ${Fixed} -prefix ${slabMask} -input ${spmMask} -overwrite

#Create benson slab mask
3dresample -master ${slabMask} -prefix ${bensonslabMask} -input ${bensonMask} -overwrite

# make mask of slab image acc to ANTs forum https://github.com/ANTsX/ANTs/issues/1110
N4BiasFieldCorrection -d 3 -i ${Fixed} -o ${FixedN4} -b [100] -c [200x200x200x200,0] -v -s 4
ThresholdImage 3 ${fixedImageN4} $slabMask 100 Inf

outputPrefix=${COREG_DIR}/out
echo "Calculating transform matrix..."

antsRegistration  --verbose 1 \
                  --dimensionality 3 \
                  --float 0 \
                  --interpolation Linear \
                  --use-histogram-matching 0 \
                  --winsorize-image-intensities [0.005, 0.995] \
                  --collapse-output-transforms 1 \
                  --output [${outputPrefix}, ${outputPrefix}Warped.nii.gz, ${outputPrefix}InverseWarped.nii.gz] \
                  --transform translation[0.2] \
                    --metric MI[${FixedN4},${Moving},1,32,Regular,0.5] \
                    --convergence [400x240x100,1e-6,10] \
                    --shrink-factors 8x4x2 \
                    --smoothing-sigmas 0x0x0vox \
                    --masks [${slabMask},NULL] \
                  --transform Rigid[0.2] \
                    --metric MI[${FixedN4},${Moving},1,32,Regular,0.5] \
                    --convergence [500x500x250x50,1e-6,10] \
                    --shrink-factors 6x4x2x1 \
                    --smoothing-sigmas 2x1x0x0vox \
                    --masks [${slabMask},NULL] \
                  --transform Affine[0.1] \
                    --metric MI[${Fixed},${Moving},1,32,Regular,0.25] \
                    --convergence [500x250x100,1e-6,10] \
                    --shrink-factors 3x2x1 \
                    --smoothing-sigmas 1x0x0vox \
                    --masks [${bensonslabMask},NULL]  #\
                  # --transform Syn[0.1,3,0] \
                  #   --metric CC[${Fixed},${Moving},1,4] \
                  #   --convergence [100x100x70x100x25,1e-6,10] \
                  #   --shrink-factors 6x4x3x2x1 \
                  #   --smoothing-sigmas 3x2x2x1x0vox \
                  #   --masks [${bensonslabMask},${bensonslabMask}] \


echo "Transform matrix calculated."

#antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${Fixed} -r ${Fixed} -o ${COREG_DIR}/WarpedANAT.nii.gz -t [${outputPrefix}0GenericAffine.mat, 1]
# Transform masked T1w
antsApplyTransforms --interpolation Linear -d 3 -i ${masked_T1w} -r ${masked_T1w} -o ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wAffine.nii.gz -t ${outputPrefix}0GenericAffine.mat #forward transform
#antsApplyTransforms --interpolation BSpline[5] -d 3 -i ${masked_T1w} -r ${masked_T1w} -o ${COREG_DIR}/${subject}_ses-${session}_acq-MP2RAGE_desc-masked_T1wWarped.nii.gz -t ${outputPrefix}1Warp.nii.gz -t ${outputPrefix}0GenericAffine.mat #forward transform

#reset number of threads
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
