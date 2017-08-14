function job = moh_config_ALI
% Configuration file for the Automatic Lesion Identification (ALI)
%_______________________________________________________________________
% Copyright (C) 2009 Wellcome Trust Centre for Neuroimaging
%
% Mohamed Seghier, 28.05.2009
% =========================


entry = inline(['struct(''type'',''entry'',''name'',name,'...
        '''tag'',tag,''strtype'',strtype,''num'',num)'],...
        'name','tag','strtype','num');

files = inline(['struct(''type'',''files'',''name'',name,'...
        '''tag'',tag,''filter'',fltr,''num'',num)'],...
        'name','tag','fltr','num');

mnu = inline(['struct(''type'',''menu'',''name'',name,'...
        '''tag'',tag,''labels'',{labels},''values'',{values})'],...
        'name','tag','labels','values');

branch = inline(['struct(''type'',''branch'',''name'',name,'...
        '''tag'',tag,''val'',{val})'],...
        'name','tag','val');

repeat = inline(['struct(''type'',''repeat'',''name'',name,''tag'',tag,'...
         '''values'',{values})'],'name','tag','values');
     
choice = inline(['struct(''type'',''choice'',''name'',name,''tag'',tag,'...
         '''values'',{values})'],'name','tag','values');
     
%______________________________________________________________________
%______________________________________________________________________


addpath(fullfile(spm('dir'),'toolbox','ALI'));



% -------------------------------------------------------------------------
% configuation for STEP 1: iterative unified segmentation-normalisation
% -------------------------------------------------------------------------
 
 
step1data.type    = 'files';
step1data.tag     = 'step1data';
step1data.name    = 'Images to segment';
step1data.filter  = 'image';
step1data.ufilter = '.*';
step1data.num     = [0 Inf];
step1data.help    = {[...
'Specify the input images for the unified segmentation. ',...
'This should be your anatomical/structural images (e.g. T1 images)',...
' of all your patients...']};


prior_filename     = fullfile(spm('Dir'), 'toolbox',...
    'ALI', 'Priors_extraClass', 'wc4prior0.img') ; 
step1prior.type    = 'files';
step1prior.tag     = 'step1prior';
step1prior.name    = 'Prior EXTRA class';
step1prior.filter  = 'image';
step1prior.ufilter = '.*';
step1prior.num     = [1 1];
step1prior.val{1}     = {prior_filename};
step1prior.help    = {[...
'Select the prior (1st guess) for the EXTRA class. ',...
'This prior will be combined with (by default) GM, WM, and CSF priors ',...
' for the iterative unified segmentation routine. In the absence of any ',...
' hypothesis, this prior is empirically set to 05*(CSF + WM). In the ',...
' presence of abnormality, this prior will be updated at every iteration ',...
' of the segmentation procedure so it will then approximate the location ',...
' of the lesion for next segmentation runs. However, users can modify the ',...
' definition of the prior of the EXTRA class (used at iteration 1 as a ',...
' first guess) and include more constrained spatial priors. For instance, ',...
' this prior can be limited to left hemisphere only if all lesions are ',...
' located in the LH...etc. ']};
 
 
 
step1niti.type    = 'entry';
step1niti.name    = 'Number of iterations';
step1niti.tag     = 'step1niti';
step1niti.strtype = 'r';
step1niti.num     = [1 1];
step1niti.val     = {2};
step1niti.help    = {[...
'Specify the number of iterations for the new iterative unified ',...
' segmentation-normalisation procedure. This number will define the number',...
' of segmentation runs. The updated EXTRA class of run (n-1) will be used ',...
' as prior for the EXTRA class of run (n).']};



step1thr_prob.type    = 'entry';
step1thr_prob.name    = 'Threshold probability';
step1thr_prob.tag     = 'step1thr_prob';
step1thr_prob.strtype = 'r';
step1thr_prob.num     = [1 1];
step1thr_prob.val     = {1/3};
step1thr_prob.help    = {[...
'Specify the thershold for the probability of the EXTRA class: ', ...
' at each iteration, the EXTRA class will be cleaned up before ',...
' used as a prior for the next segmentation run. This step will ',...
' help to limit the serach for abnormality for only voxels with ',...
' high probability in the EXTRA class (i.e. voxels with high prob ',...
' are those that cannot be fully explained by the expected GM, WM, ',...
' and CSF classes.']};


step1thr_size.type    = 'entry';
step1thr_size.name    = 'Threshold size';
step1thr_size.tag     = 'step1thr_size';
step1thr_size.strtype = 'r';
step1thr_size.num     = [1 1];
step1thr_size.val     = {100};
step1thr_size.help    = {[...
'Specify the thershold for the size (nb voxels) of the EXTRA class: ', ...
' at each iteration, the EXTRA class will be cleaned up. Only abnornal ',...
' regions with a relatively big size (> thershold) will considered for ',...
' the definition of the prior for the EXTRA class.']};


step1coregister.type         = 'menu';
step1coregister.tag     = 'step1coregister';
step1coregister.name    = 'Coregister to MNI space';
step1coregister.labels = {'YES', 'NO'} ;
step1coregister.values = {1 0} ;
step1coregister.val = {1} ;
step1coregister.help    = {['you can coregister your anatomical images ',...
    'to MNI space (e.g. target=T1_template). This would help the ', ...
    'accuracy of the segmentation algorithm (e.g. avoid having input ',...
    ' images with abherant centres/locations).']};


unified_segmentation.type    = 'branch';
unified_segmentation.tag     = 'unified_segmentation';
unified_segmentation.name    = 'Unified segmentation';
unified_segmentation.val     = {step1data step1prior step1niti ...
    step1thr_prob step1thr_size step1coregister};
unified_segmentation.help    = {...
    'STEP 1: segment in 4 classes all structural T1 images.'};
unified_segmentation.prog    = @segment_unified ; 
 
 


% -------------------------------------------------------------------------
% configuation for STEP 2: spatial smoothing of segmented GM/WM classes
% -------------------------------------------------------------------------

 
step2data.type    = 'files';
step2data.tag     = 'step2data';
step2data.name    = 'Images to smooth';
step2data.filter  = 'image';
step2data.ufilter = '.*';
step2data.num     = [0 Inf];
step2data.help    = {[...
'Select your segmented GM and WM images: ',...
' all images will be spatially smoothed. Both patients and controls images',...
' can be selected.']};
 
 
step2fwhm.type    = 'entry';
step2fwhm.name    = 'FWHM';
step2fwhm.tag     = 'step2fwhm';
step2fwhm.strtype = 'e';
step2fwhm.num     = [1 3];
step2fwhm.val     = {[8 8 8]};
step2fwhm.help    = {[...
'Specify the full-width at half maximum (FWHM) of the Gaussian smoothing ',...
'kernel [in mm]: three values denoting the FWHM in the ',...
'x, y and z directions.']};
 
 
spatial_smoothing.type    = 'branch';
spatial_smoothing.tag     = 'spatial_smoothing';
spatial_smoothing.name    = 'Spatial smoothing';
spatial_smoothing.val     = {step2data step2fwhm};
spatial_smoothing.help    = {...
    'STEP 2: spatial smoothing of segmented gray and white matter images.'};
spatial_smoothing.prog    = @smooth_spatial ;
 


% -------------------------------------------------------------------------
% configuation for STEP 3: outliers detection (detection of abnormality)
% -------------------------------------------------------------------------

step3directory.type    = 'files';
step3directory.tag     = 'step3directory';
step3directory.name    = 'Select a directory';
step3directory.help    = {'Select a directory where to save the results.'};
step3directory.filter  = 'dir';
step3directory.num     = 1;


step3patientGM.type    = 'files';
step3patientGM.tag     = 'step3patientGM';
step3patientGM.name    = 'Patients: sGM images';
step3patientGM.filter  = 'image';
step3patientGM.ufilter = '.*';
step3patientGM.num     = [0 Inf];
step3patientGM.help    = {[...
'Specify the smoothed gray matter (GM) images of your patients. ',...
'These images will then be compared, voxel by voxel, to the smoothed ',...
'gray matter (GM) images of all your controls. Any voxel in the patient GM ',...
'that deviates from the normal range will be considered as an outlier, and ',...
'thus included in the lesion. By definition, lesion = set of ',...
'abnornal/outlier voxels.']};


step3patientWM.type    = 'files';
step3patientWM.tag     = 'step3patientWM';
step3patientWM.name    = 'Patients: sWM images';
step3patientWM.filter  = 'image';
step3patientWM.ufilter = '.*';
step3patientWM.num     = [0 Inf];
step3patientWM.help    = {[...
'Specify the smoothed white matter (WM) images of your patients. ',...
'These images will then be compared, voxel by voxel, to the smoothed ',...
'white matter (WM) images of all your controls. Any voxel in the patient WM ',...
'that deviates from the normal range will be considered as an outlier, and ',...
'thus included in the lesion. By definition, lesion = set of ',...
'abnornal/outlier voxels.']};

 
step3controlGM.type    = 'files';
step3controlGM.tag     = 'step3controlGM';
step3controlGM.name    = 'Controls: sGM images';
step3controlGM.filter  = 'image';
step3controlGM.ufilter = '.*';
step3controlGM.num     = [0 Inf];
step3controlGM.help    = {[...
'Specify the smoothed gray matter (GM) images of your controls. ',...
'These images are used to assess the dergee of "normality" at each voxel ',...
'(e.g. what is the "normal" variability of the healthy tissue?)... ']};


step3controlWM.type    = 'files';
step3controlWM.tag     = 'step3controlWM';
step3controlWM.name    = 'Controls: sWM images';
step3controlWM.filter  = 'image';
step3controlWM.ufilter = '.*';
step3controlWM.num     = [0 Inf];
step3controlWM.help    = {[...
'Specify the smoothed white matter (WM) images of your controls. ',...
'These images are used to assess the dergee of "normality" at each voxel ',...
'(e.g. what is the "normal" variability of the healthy tissue?)... ']};


mask_filename     = fullfile(spm('Dir'), 'toolbox',...
    'ALI', 'Mask_image', 'mask_controls.img') ; 
step3mask.type    = 'files';
step3mask.tag     = 'step3mask';
step3mask.name    = 'Mask (regions of interest)';
step3mask.filter  = 'image';
step3mask.ufilter = '.*';
step3mask.num     = [1 1];
step3mask.val{1}     = {mask_filename};
step3mask.help    = {[...
'Select the image mask for your lesion detection analysis: ',...
'the mask can be any image and it is used to limit the lesion detection ',...
'within a the meaningful voxels (e.g. in-brain voxels). By default, ',...
'the mask = whole brain (no assumption about the expected locations).']};


step3mask_thr.type    = 'entry';
step3mask_thr.name    = 'Threshold for the mask';
step3mask_thr.tag     = 'step3mask_thr';
step3mask_thr.strtype = 'r';
step3mask_thr.num     = [1 1];
step3mask_thr.val     = {0};
step3mask_thr.help    = {[...
'Specify the threshold: all voxels of the mask image that have a signal ', ...
'less than the threshold are excluded from the lesion detection.']};



step3Lambda.type    = 'entry';
step3Lambda.name    = 'Lambda parameter';
step3Lambda.tag     = 'step3Lambda';
step3Lambda.strtype = 'r';
step3Lambda.num     = [1 1];
step3Lambda.val     = {-4};
step3Lambda.help    = {[...
'Specify the value of Lambda: equivalent to the fuzziness index "m" in ',... 
'standard FCM algorithm (m=1-2/Lambda). By default, Lambda = -4.']};


step3Alpha.type    = 'entry';
step3Alpha.name    = 'Alpha parameter';
step3Alpha.tag     = 'step3Alpha';
step3Alpha.strtype = 'r';
step3Alpha.num     = [1 1];
step3Alpha.val     = {0.5};
step3Alpha.help    = {[...
'Specify the value of Alpha: this is the factor of sensitivity ',...
'(tunning factor), equal here to 0.5 (half the probability interval). ']};



outliers_detection.type = 'branch';
outliers_detection.tag  = 'outliers_detection';
outliers_detection.name = 'Abnormality detection (FCP)';
outliers_detection.val  = {step3directory step3patientGM step3patientWM ...
    step3controlGM step3controlWM step3mask ...
    step3mask_thr step3Lambda step3Alpha};
outliers_detection.help = {[...
    'STEP 3: outliers detection (lesion = abnormal/outliers voxels) ',...
    'from both GM and WM classes (using FCP algorithm). ']};
outliers_detection.prog = @detect_outliers;
        



% -------------------------------------------------------------------------
% configuation for STEP 4: lesion definition (fuzzy, binary and contour)
% -------------------------------------------------------------------------

step4directory.type    = 'files';
step4directory.tag     = 'step4directory';
step4directory.name    = 'Select a directory';
step4directory.help    = {'Select a directory where to save the results'};
step4directory.filter  = 'dir';
step4directory.num     = 1;


step4fcpGM.type    = 'files';
step4fcpGM.tag     = 'step4fcpGM';
step4fcpGM.name    = 'Negative FCP_GM images';
step4fcpGM.filter  = 'image';
step4fcpGM.ufilter = '.*';
step4fcpGM.num     = [0 Inf];
step4fcpGM.help    = {[...
'Select the FCP_negative of the gray matter images of your patients: ',... 
'these images represent where the GM of a given patient is abnormally ',...
'low compared to GM of the controls. These images are those computed ',...
'in the previous step.']};


step4fcpWM.type    = 'files';
step4fcpWM.tag     = 'step4fcpWM';
step4fcpWM.name    = 'Negative FCP_WM images';
step4fcpWM.filter  = 'image';
step4fcpWM.ufilter = '.*';
step4fcpWM.num     = [0 Inf];
step4fcpWM.help    = {[...
'Select the FCP_negative of the white matter images of your patients. ',...
'SELECTED IN THE SAME ORDER AS THOSE OF THE GM IMAGES...!!!! ',...
'These images represent where the WM of a given patient is abnormally ',...
'low compared to WM of the controls. These images are those computed ',...
'in the previous step.']};

        
        
step4binary_thr.type    = 'entry';
step4binary_thr.name    = 'Binary lesion: threshold U';
step4binary_thr.tag     = 'step4binary_thr';
step4binary_thr.strtype = 'r';
step4binary_thr.num     = [1 1];
step4binary_thr.val     = {0.3};
step4binary_thr.help    = {[...
'Specify the threshold: all voxels with a degree of abonormality (U) ',...
'bigger than the thereshold will be considered as a lesion. Useful for',...
' the generation of the binary/contour definition of the lesion.']};



step4binary_size.type    = 'entry';
step4binary_size.name    = 'Binary lesion: minimum size';
step4binary_size.tag     = 'step4binary_size';
step4binary_size.strtype = 'r';
step4binary_size.num     = [1 1];
step4binary_size.val     = {100};
step4binary_size.help    = {[...
'Specify the minimum size (nb vox): all abnormal clusters with less than the ',...
'threshold size will be excluded (e.g. tiny/small clusters) will be ',...
'removed for the lesion volume.']};


lesion_definition.type    = 'branch';
lesion_definition.tag     = 'lesion_definition';
lesion_definition.name    = 'Lesion definition (grouping)';
lesion_definition.val     = {step4directory step4fcpGM step4fcpWM ... 
    step4binary_thr step4binary_size};
lesion_definition.help    = {[...
    'STEP 4: group abnormal (GM and WM) images as a lesion ',...
    ' (three images generated: fuzzy, binary and contour).']};
lesion_definition.prog = @define_lesion;



% -------------------------------------------------------------------------
% generate lesion overlap maps (LOM): useful for group analysis
% -------------------------------------------------------------------------

step5directory.type    = 'files';
step5directory.tag     = 'step5directory';
step5directory.name    = 'Select a directory';
step5directory.help    = {'Select a directory where to save the results'};
step5directory.filter  = 'dir';
step5directory.num     = 1;


step5LOM.type    = 'files';
step5LOM.tag     = 'step5LOM';
step5LOM.name    = 'Select Binary (lesion) images';
step5LOM.filter  = 'image';
step5LOM.ufilter = '.*';
step5LOM.num     = [0 Inf];
step5LOM.help    = {[...
'Select the binary definition of the lesions of all your patients. ',...
'These binary images are those created in the previous step.']};


lesion_overlap.type    = 'branch';
lesion_overlap.tag     = 'lesion_overlap';
lesion_overlap.name    = 'Lesion Overlap Map (LOM)';
lesion_overlap.val     = {step5directory step5LOM};
lesion_overlap.help    = {...
    'STEP 5: generate lesion overlap maps (LOM): overlap over patients.'};
lesion_overlap.prog = @generate_LOM;
        


% -------------------------------------------------------------------------
% explore the LOM maps: useful for group analysis
% -------------------------------------------------------------------------

step6LOM_file.type    = 'files';
step6LOM_file.tag     = 'step6LOM_file';
step6LOM_file.name    = 'LOM file';
step6LOM_file.filter  = 'mat';
step6LOM_file.ufilter = '.*';
step6LOM_file.num     = [1 1];
step6LOM_file.help    = {[...
'Select the LOM*.mat that contains all the details of the generated ',...
'lesion overalp map (LOM) from the previous step. The LOM images will ',...
'refelct how many patients do have a lesion at a particular location.']};

        
step6thr_nb.type    = 'entry';
step6thr_nb.name    = 'LOM threshold';
step6thr_nb.tag     = 'step6thr_nb';
step6thr_nb.strtype = 'e';
step6thr_nb.num     = [1 1];
step6thr_nb.val     = {1};
step6thr_nb.help    = {...
    'Specify the threshold of the LOM: minimum overlap to be displayed. '};
        
lesion_overlap_explore.type    = 'branch';
lesion_overlap_explore.tag     = 'lesion_overlap_explore';
lesion_overlap_explore.name    = 'Explore the LOM';
lesion_overlap_explore.val     = {step6LOM_file step6thr_nb};
lesion_overlap_explore.help    = {...
    'STEP 6: explore the generated lesion overlap maps (LOM).'};
lesion_overlap_explore.prog = @explore_LOM;



%--------------------------------------------------------------------------
% Define ALI job
%--------------------------------------------------------------------------

job.type = 'choice';
job.name = 'ALI';
job.tag  = 'ali';
job.values = {unified_segmentation,spatial_smoothing,outliers_detection,...
    lesion_definition,lesion_overlap,lesion_overlap_explore};
job.help = {'Automatic Lesion Identification (ALI)'};



%------------------------------------------------------------------------
%------------------------------------------------------------------------
function segment_unified(job)
moh_run_ALI(job);

%------------------------------------------------------------------------
function smooth_spatial(job)
moh_run_ALI(job);

%------------------------------------------------------------------------
function detect_outliers(job)
moh_run_ALI(job);

%------------------------------------------------------------------------
function define_lesion(job)
moh_run_ALI(job);

%------------------------------------------------------------------------
function generate_LOM(job)
moh_run_ALI(job);

%------------------------------------------------------------------------
function explore_LOM(job)
moh_run_ALI(job);

        
