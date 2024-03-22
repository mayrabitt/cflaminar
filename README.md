# cflaminar
Preprocessing pipeline for CF analysis across the cortical depth

[![Documentation Status] ADDLINK TO WEBPAGE

![plot]ADDFIGURE

## In active development
This package is still in development and its API might change. Documentation for this package can be found at [ADDLINK TO WEBPAGE] (not up to date)

## Preprocessing

## General steps:

### Bidsify the data:

-From scanner to BIDS, files should be renamed to be converted from PAR/REC to Nifti and bidsified. Renaming can be done using 'utils/rename_PAR4BIDS.sh':

```bash
cd '{MAIN_PATH}/utils'
source rename_PAR4BIDS.sh xxx
master -m 02a -s 001,002,xxx --lr #(long flag indicates PR direction of BOLD files; subjects separated with commas without spaces)
```
  Output: 
  - Data and .json files acc. to BIDS

  Warning: check if fieldmaps have been correctly assigned to their respective bold files in their .json. 

## Anatomical preprocessing:

### Create T1w MP2RAGE image (if necessary):
master -m 04 -s 001 #spinoza_qmrimaps: creates T1w image from 1st and 2nd inversion images using Pymp2rage

  Output: 
  - derivatives/pymp2rage: T1w, T1wmap, brain mask (desc-spm_mask), copy of T2w 
    
### Create sinus mask using T1w/T2w ratio:
a) Register anatomy to MNI space  
  master -m 05b -s 001 -j xxs (--sge --cmd) (can skip -m 05a) #spinoza_registration (anat-to-MNI) using ANTs. Matrix is necessary for sinus mask (-m 07). 

  Outputs: 
  - derivatives/ants: 





