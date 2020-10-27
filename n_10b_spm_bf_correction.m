%--------------------------------------------------------------------------
% SPM bias field correction of MP2RAGE images.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Define parameters
clear;
% Get environmental variables (for input & output path):
anat_data_path = '/media/h/P04/Data/BIDS/sub-03/ses-002/anat';
% Path of the default SPM batch:
strPthDflt = strcat(anat_data_path, '/spm_default_bf_correction_batch.mat');
% Directory with images to be corrected:
%--------------------------------------------------------------------------
%% Prepare input cell array
% The cell array with the file name of the images to be bias field
% corrected:
cllPthIn = spm_select('ExtList', ...
    anat_data_path, ...
    '.nii', ...
    Inf);
cllPthIn = cellstr(cllPthIn);
for idxIn = 1:length(cllPthIn)
    cllPthIn{idxIn} = strcat(anat_data_path, cllPthIn{idxIn});
end
%--------------------------------------------------------------------------
%% Prepare SPM batch
clear matlabbatch;
matlabbatch{1}.spm.spatial.preproc.channel.vols = cllPthIn;
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [1, 1];
%--------------------------------------------------------------------------
%% Save SPM batch file
strOut = strcat(anat_data_path, '/spm_bf_correction_batch');
save(strOut, 'matlabbatch');
%--------------------------------------------------------------------------
%% Bias field correction
% Initialise 'job configuration':
spm_jobman('initcfg');
% Run 'job':
spm_jobman('run', matlabbatch);
%--------------------------------------------------------------------------
%% Exit matlab
% Because this matlab scrit gets called from command line, we have to
% include an exit statement:
exit
%--------------------------------------------------------------------------
