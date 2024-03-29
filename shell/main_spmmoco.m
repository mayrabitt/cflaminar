function main_spmmoco(project)
%set(0, 'DefaultFigureVisible','off');
fig=figure;
addpath(genpath('/packages/matlab/toolbox/spm12/r7771'));
addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Mayra/programs/cflaminar/utils'));

mybatchpath ='/data1/projects/dumoulinlab/Lab_members/Mayra/programs/cflaminar/utils/';
myfilespath =['/data1/projects/dumoulinlab/Lab_members/Mayra/projects/' project '/derivatives/spm/'];
cd(myfilespath)
subjects=dir;
spm_jobman('initcfg');

for i = 1:length(subjects)
cd (mybatchpath)
load('batch_spmmoco.mat');
    try
        subj_dir = subjects(i).name;
        if (subjects(i).isdir==0)
            continue;
        end

        if (strcmp(subj_dir, '.')==1)
            continue;
        end
        
        if (strcmp(subj_dir, '..')==1)
            continue;
        end

        if (strcmp(subj_dir, 'code')==1||strcmp(subj_dir, 'sourcedata')==1||strcmp(subj_dir, 'derivatives')==1)
            continue;
        end
        
        if (subjects(i).isdir ==1)

%             cd([myfilespath subj_dir '/anat']);
%             anat = spm_select('ExtFPListRec', pwd, '^sub.*\.nii',1);
%            cd([myfilespath subj_dir '/func']);
           % matlabbatch{1}.spm.spatial.realign.estwrite.data{1} = cellstr(functionals);
            cd([myfilespath subj_dir '/ses-1/no_moco']);
            niigzFiles=dir('*nii.gz')
            for f=1:numel(niigzFiles)
                niigzFile=niigzFiles(f).name
                gunzip(niigzFile,[myfilespath subj_dir '/ses-1/func'])
            end
            cd([myfilespath subj_dir '/ses-1/func']);
            functionals1 = spm_select('ExtFPListRec', pwd, '^*run-1_desc-preproc_bold.nii',1:1000);
            functionals2 = spm_select('ExtFPListRec', pwd, '^*run-2_desc-preproc_bold.nii',1:1000);
            functionals3 = spm_select('ExtFPListRec', pwd, '^*run-3_desc-preproc_bold.nii',1:1000);
            functionals4 = spm_select('ExtFPListRec', pwd, '^*run-4_desc-preproc_bold.nii',1:1000);
            matlabbatch{1}.spm.spatial.realign.estwrite.data = {
                cellstr(functionals1)
                cellstr(functionals2)
                cellstr(functionals3)
                cellstr(functionals4)
                                                    }';

            matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];

            spm_jobman('run', matlabbatch)

        end
    catch
        %display(['error:' lasterr]);
    end
end

end
