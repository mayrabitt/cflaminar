#! /bin/sh
#$ -N spmMoCo
#$ -S /bin/sh
#$ -j y
#$ -q long.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp_beta/code/logs
#$ -u bittencourt
#$ -V

module load matlab/R2021b
#addpath(genpath('/packages/matlab/toolbox/spm12/r7771'))
#addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Mayra/programs/cflaminar/utils'))
cd '/data1/projects/dumoulinlab/Lab_members/Mayra/programs/cflaminar/utils'
echo "Running spmMoCo on $1"
SPM_PATH=${SPM}

matlab -nodesktop -nodisplay -nosplash -r "main_spmmoco('$1')"
