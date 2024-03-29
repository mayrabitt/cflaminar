#! /bin/bash
#! /usr/bin/env python
#! /usr/bin/env bash
#$ -N fitpRF
#$ -S /bin/sh
#$ -j y
#$ -q long.q
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/code/logs
#$ -u bittencourt
#$ -V

#arg1: subject_id, arg2: denoising, arg3: depth, arg4: ncores: depth (e.g. 001 nordic_sm4 GM 16)

python '/data1/projects/dumoulinlab/Lab_members/Mayra/programs/cflaminar/postproc/main_fitpRF_atlas.py' $1 $2 $3 $4