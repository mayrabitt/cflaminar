#! /bin/bash
#! /usr/bin/env python
#! /usr/bin/env bash
#$ -N fitpRF
#$ -S /bin/sh
#$ -j y
#$ -q mayra.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#SBATCH --job-name=pRFfit
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=m.bittencourt@umcg.nl
#SBATCH --time=2:00:00
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --profile=task

#arg1: subject_id, arg2: denoising, arg3: depth, arg4: atlas, arg5: ncores  (e.g. 001 nordic_sm4 GM benson 16)

python ${PATH_HOME}/programs/cflaminar/pRF_fitting/main_fitpRF_atlas.py $1 $2 $3 $4 $5

