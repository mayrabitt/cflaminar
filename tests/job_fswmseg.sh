#!/bin/bash
#$ -S /bin/bash
#$ -N fs_wmseg
#$ -wd /data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/derivatives/freesurfer
#$ -o /data1/projects/dumoulinlab/Lab_members/Mayra/freesurfer/CFLamUp/fs_wmseg.log
#$ -j Y
#$ -q short.q@jupiter
#$ -V


cd '/data1/projects/dumoulinlab/Lab_members/Mayra/projects/CFLamUp/derivatives/freesurfer/sub-001'

mri_segment -wlo 95 mri/brainmask.mgz mri/wm_test.mgz 

#recon-all -skullstrip -wsthresh 25 -no-wsgcaatlas -clean-bm -subjid sub-001
#recon-all -subjid ${subject} -hires -parallel -openmp 15 -autorecon2 -autorecon3 -T2pial
