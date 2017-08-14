function moh_writenormalise_job(p)
% after segmentation, write a normalised anatomical volume
%
% Mohamed Seghier 05.06.2006
% =======================================
% 

global defaults ;

[pth,nam,ext,toto] = spm_fileparts(deblank(p)) ; %#ok<NASGU>

jobs{1}.spatial{1}.normalise{1}.write.roptions.preserve = ...
    0 ;
jobs{1}.spatial{1}.normalise{1}.write.roptions.bb = ...
    defaults.normalise.write.bb ;
jobs{1}.spatial{1}.normalise{1}.write.roptions.vox = ...
    defaults.normalise.write.vox ;
jobs{1}.spatial{1}.normalise{1}.write.roptions.interp = ...
    defaults.normalise.write.interp ;
jobs{1}.spatial{1}.normalise{1}.write.roptions.wrap = ...
    defaults.normalise.write.wrap ;
jobs{1}.spatial{1}.normalise{1}.write.subj(1).matname = ...
    {fullfile(pth,[nam '_seg_sn.mat'])} ;
jobs{1}.spatial{1}.normalise{1}.write.subj(1).resample = ...
    {deblank(p)} ;
spm_jobman('run' , jobs) ;

return;
