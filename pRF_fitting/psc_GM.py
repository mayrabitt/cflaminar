# %%
import numpy as np
import matplotlib.pyplot as plt
import nibabel as nib
import os

# %%
#args: subject, session, task, nruns, denoising

subject=f'sub-{sys.argv[1:][0]}'
session=sys.argv[2:][0]
task=sys.argv[3:][0]
nruns=sys.argv[4:][0]
MAIN_PATH=os.getenv("DERIVATIVES")
project=os.getenv("PROJECT")
resampling='resampled'
denoising=sys.argv[5:][0]
filter=1
depth_list=['GM']
#depth_list=['0.0', '0.12', '0.25', '0.38', '0.5', '0.62', '0.75', '0.88']

#Now we repeat the calculation for giftis

#Get pybest outputs as .npy files and calculate psc:
for depth in range(depth_list.__len__()):
    proc_tc_L = []
    proc_tc_R = []
    proc_tc = []
    for run in range(nruns):
        proc_tc_L = nib.load(
            f'{MAIN_PATH}/{project}/derivatives/{resampling}/{subject}/ses-{session}/{denoising}/{subject}_ses-{session}_task-{task}_run-{run + 1}_space-fsnative_hemi-L_desc-{denoising}_bold_{depth_list[depth]}.gii')
        proc_tc_R = nib.load(
            f'{MAIN_PATH}/{project}/derivatives/{resampling}/{subject}/ses-{session}/{denoising}/{subject}_ses-{session}_task-{task}_run-{run + 1}_space-fsnative_hemi-R_desc-{denoising}_bold_{depth_list[depth]}.gii')
        # pybest_tc_L = nib.load(
        #     '/Users/mayra/Library/CloudStorage/OneDrive-UMCG/Postdoc/CFLam/derivatives/pybest/sub-001/ses-1/unzscored/sub-001_ses-1_task-ret_run-'f'{run + 1}_space-fsnative_hemi-L_desc-denoised.gii')
        # pybest_tc_R = nib.load(
        #     '/Users/mayra/Library/CloudStorage/OneDrive-UMCG/Postdoc/CFLam/derivatives/pybest/sub-001/ses-1/unzscored/sub-001_ses-1_task-ret_run-'f'{run + 1}_space-fsnative_hemi-R_desc-denoised.gii')
        tc = np.vstack([proc_tc_L.agg_data(), proc_tc_R.agg_data()]).T
        if tc.shape[0]>225:
            tc=tc[:225,:]
        tc=tc[5:215,:]
        tc_m = tc * np.expand_dims(np.nan_to_num((100 / np.mean(tc, axis=0))), axis=0)
        #do baseline correction
        baseline = np.median(tc_m[:9], axis=0)
        tc_m = tc_m - baseline

        #baseline = np.median(tc_m[0:19], axis=0)
        if filter==1:
            from scipy import signal
            #remove linear trend without demeaning
            mean=np.mean(tc_m, axis=0)
            tc_m=signal.detrend(tc_m, axis=0)+mean
            #do highpass-filtering
            TR = 3
            fs = 1 / TR  # Hz
            lowcut=0.001 # cut-off freq of the filter
            highcut=0.015 # cut-off freq of the filter
            nyquist=0.5*fs
            f_low = lowcut/nyquist;
            f_high = highcut/nyquist;
            sos = signal.butter(8, [f_low],'highpass', fs=fs,output='sos')
            tc_m = signal.sosfiltfilt(sos, tc_m, axis=0)

        proc_tc.append(tc_m)
    mean_proc_tc = np.median(np.array(proc_tc), axis=0)
    psc = (mean_proc_tc)

    if resampling == 'resampled4curve':
        output_folder='pRFM4curve'
    else:
        output_folder='pRFM'
    path=f'{MAIN_PATH}/{project}/derivatives/{output_folder}/{subject}/ses-{session}/{denoising}/'
    os.makedirs(path, exist_ok=True)
    np.save(f'{MAIN_PATH}/{project}/derivatives/{output_folder}/{subject}/ses-{session}/{denoising}/{subject}_ses-{session}_task-{task}_hemi-LR_desc-avg_bold_{depth_list[depth]}.npy',psc)

# %%
f'{MAIN_PATH}/{project}/derivatives/{resampling}/{subject}/ses-{session}/{denoising}/{subject}_ses-{session}_task-{task}_run-{run + 1}_space-fsnative_hemi-L_desc-{denoising}_bold_{depth_list[depth]}.gii'

# %%



