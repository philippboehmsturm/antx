function moh_coregister_job(p)
% Coregister anatomical image to T1_template
% To ensure a reasonable position of the anatomical volume in MNI
% This will help the unified segmentation
%
% Mohamed Seghier 05.06.2007
% =======================================
% 

global defaults ;

jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.cost_fun = ...
    defaults.coreg.estimate.cost_fun ;
jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.sep = ...
    defaults.coreg.estimate.sep ;
jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.tol = ...
    defaults.coreg.estimate.tol ;
jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.fwhm = ...
    defaults.coreg.estimate.fwhm ;
jobs{1}.spatial{1}.coreg{1}.estimate.ref = ...
    {fullfile(spm('Dir'), 'templates', 'T1.nii')} ;
jobs{1}.spatial{1}.coreg{1}.estimate.source = ...
    {deblank(p)} ;
jobs{1}.spatial{1}.coreg{1}.estimate.other = ...
    {''} ;
disp(sprintf('##### Positioning the anatomical image into MNI space.....'))
spm_jobman('run' , jobs) ;

return;
