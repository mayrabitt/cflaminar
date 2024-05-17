function main_spmmoco_6runs(project, subject)
%set(0, 'DefaultFigureVisible','off');
fig=figure;
addpath(genpath('/packages/matlab/toolbox/spm12/r7771'));
addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Mayra/programs/cflaminar/shell'));

mybatchpath ='/data1/projects/dumoulinlab/Lab_members/Mayra/programs/cflaminar/shell/';
myfilespath =['/data1/projects/dumoulinlab/Lab_members/Mayra/projects/' project '/derivatives/spm/'];
cd(myfilespath)
subjects=dir;
spm_jobman('initcfg');

cd(mybatchpath)
load('batch_spmmoco_6runs.mat');

cd ([myfilespath 'sub-' subject '/ses-1/no_moco']);
niigzFiles=dir('*nii.gz')
for f=1:numel(niigzFiles)
    niigzFile=niigzFiles(f).name
    gunzip(niigzFile,[myfilespath 'sub-' subject '/ses-1/func'])
end
cd([myfilespath 'sub-' subject '/ses-1/func']);
functionals1 = spm_select('ExtFPListRec', pwd, '^*run-1_desc-preproc_bold.nii',1:1000);
functionals2 = spm_select('ExtFPListRec', pwd, '^*run-2_desc-preproc_bold.nii',1:1000);
functionals3 = spm_select('ExtFPListRec', pwd, '^*run-3_desc-preproc_bold.nii',1:1000);
functionals4 = spm_select('ExtFPListRec', pwd, '^*run-4_desc-preproc_bold.nii',1:1000);
functionals5 = spm_select('ExtFPListRec', pwd, '^*run-5_desc-preproc_bold.nii',1:1000);
functionals6 = spm_select('ExtFPListRec', pwd, '^*run-6_desc-preproc_bold.nii',1:1000);

matlabbatch{1}.spm.spatial.realign.estwrite.data = {
    cellstr(functionals1)
    cellstr(functionals2)
    cellstr(functionals3)
    cellstr(functionals4)
    cellstr(functionals5)
    cellstr(functionals6)
                                        }';

matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];

spm_jobman('run', matlabbatch)


end
