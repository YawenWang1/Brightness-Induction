%% This script requires the functions:
% - spm_select_get_nbframes
% - expand_4d_vols
% which need to be added to the SPM12 folder, functions are dfined here:
% https://en.wikibooks.org/wiki/SPM/Working_with_4D_data

clear; clc; close all;
%% settings
% set parent path
pathIN = '/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/00_fun_se';

%% get files

% get directories within the folder
funcList = ['01';'02';'03';'04';'05';'06','07'];%;'02';'03';'04';'05'];
allfiles = cell(length(funcList),1);
for ind1 = 1:length(funcList)
    % list all *.nii files
    files = dir(fullfile(pathIN,['func_',funcList(ind1, :),'.nii']) );
    files = {files.name}'
    for file = files
        niis = spm_select('expand',...
            fullfile(pathIN,file)); % get the entire list of 3D scans
        allfiles{ind1} = cellstr(niis);
    end
end


%% create batch

% clear old batches
clear matlabbatch
% define content of the batch
matlabbatch{1}.spm.spatial.realign.estwrite.data = allfiles;
% define estimation options
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 0.8;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 1.6;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 7;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = {'H:\P01\S03\Ses01\02_Preprocessing\02_convNii\00_func_ttopup\S03_Ses01_func_01_SCSTBL_LTR_THPGLMF6c_mean_bm.nii'};
% define reslice options
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 7;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
% matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r1';

% save SPM batch file:
fileName = [pathIN, '\MotCor_S03_Ses01_func_1_r1.mat'];
save(fileName, 'matlabbatch');
disp(['SPM batch saved as: ', fileName]);

%% run batch

% initialise job configuration
spm_jobman('initcfg')
% run job
spm_jobman('run', matlabbatch);

disp(['Finished running: ', fileName]);
