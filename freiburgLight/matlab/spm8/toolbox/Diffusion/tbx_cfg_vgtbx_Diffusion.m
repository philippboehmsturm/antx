function vgtbx_Diffusion = tbx_cfg_vgtbx_Diffusion
% Diffusion toolbox
%_______________________________________________________________________
%
% This toolbox contains various functions related to post-processing of 
% diffusion weighted image series in SPM5. Topics include movement 
% correction for image time series, estimation of the diffusion tensor, 
% computation of anisotropy indices and tensor decomposition. Visualisation 
% of diffusion tensor data (quiver & red-green-blue plots of eigenvector 
% data) is not included in this toolbox, but there are separate plugins 
% for spm_orthviews available for download at the same place as the 
% source code of this toolbox.
%
% The algorithms applied in this toolbox are referenced within the PDF help 
% texts of the functions where they are implemented.
%
% This toolbox is free but copyright software, distributed under the 
% terms of the GNU General Public Licence as published by the Free 
% Software Foundation (either version 2, as given in file 
% spm_LICENCE.man, or at your option, any later version). Further details 
% on "copyleft" can be found at http://www.gnu.org/copyleft/.
% The toolbox consists of the files listed in its Contents.m file.
%
% The source code of this toolbox is available at
%
% http://sourceforge.net/projects/spmtools
%
% Please use the SourceForge forum and tracker system for comments, 
% suggestions, bug reports etc. regarding this toolbox.
%_______________________________________________________________________
%
% @(#) $Id: vgtbx_config_Diffusion.m 543 2008-03-12 19:40:40Z glauche $

rev='$Revision: 543 $';

addpath(genpath(fullfile(spm('dir'),'toolbox','Diffusion')));

% see how we are called - if no output argument, then start spm_jobman UI

if nargout == 0
        spm_jobman('interactive');
        return;
end;

% MATLABBATCH Configuration file for toolbox 'Diffusion toolbox'
% This code has been automatically generated.
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {'The source images (one or more).'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% b B values
% ---------------------------------------------------------------------
b         = cfg_entry;
b.tag     = 'b';
b.name    = 'B values';
b.help    = {'A vector of b values (one number per image). The actual b value used in tensor computation will depend on this value, multiplied with the length of the corresponding gradient vector.'};
b.strtype = 'e';
b.num     = [Inf 1];
% ---------------------------------------------------------------------
% g Gradient direction values
% ---------------------------------------------------------------------
g         = cfg_entry;
g.tag     = 'g';
g.name    = 'Gradient direction values';
g.help    = {'A #img-by-3 matrix of gradient directions. The length of each gradient vector will be used as a scaling factor to the b value. Therefore, you should make sure that your gradient vectors are of unit length if your b value already encodes for diffusion weighting strength.'};
g.strtype = 'e';
g.num     = [Inf 3];
% ---------------------------------------------------------------------
% M Reset orientation
% ---------------------------------------------------------------------
M         = cfg_const;
M.tag     = 'M';
M.name    = 'Reset orientation';
M.val{1} = double(1);
M.help    = {''};
% ---------------------------------------------------------------------
% resetall (Re)set Gradient, b value and position
% ---------------------------------------------------------------------
resetall         = cfg_branch;
resetall.tag     = 'resetall';
resetall.name    = '(Re)set Gradient, b value and position';
resetall.val     = {b g M };
resetall.help    = {''};
% ---------------------------------------------------------------------
% b B values
% ---------------------------------------------------------------------
b         = cfg_entry;
b.tag     = 'b';
b.name    = 'B values';
b.help    = {'A vector of b values (one number per image). The actual b value used in tensor computation will depend on this value, multiplied with the length of the corresponding gradient vector.'};
b.strtype = 'e';
b.num     = [Inf 1];
% ---------------------------------------------------------------------
% g Gradient direction values
% ---------------------------------------------------------------------
g         = cfg_entry;
g.tag     = 'g';
g.name    = 'Gradient direction values';
g.help    = {'A #img-by-3 matrix of gradient directions. The length of each gradient vector will be used as a scaling factor to the b value. Therefore, you should make sure that your gradient vectors are of unit length if your b value already encodes for diffusion weighting strength.'};
g.strtype = 'e';
g.num     = [Inf 3];
% ---------------------------------------------------------------------
% resetbg (Re)set Gradient and b value
% ---------------------------------------------------------------------
resetbg         = cfg_branch;
resetbg.tag     = 'resetbg';
resetbg.name    = '(Re)set Gradient and b value';
resetbg.val     = {b g };
resetbg.help    = {''};
% ---------------------------------------------------------------------
% b B values
% ---------------------------------------------------------------------
b         = cfg_entry;
b.tag     = 'b';
b.name    = 'B values';
b.help    = {'A vector of b values (one number per image). The actual b value used in tensor computation will depend on this value, multiplied with the length of the corresponding gradient vector.'};
b.strtype = 'e';
b.num     = [Inf 1];
% ---------------------------------------------------------------------
% resetb (Re)set b value
% ---------------------------------------------------------------------
resetb         = cfg_branch;
resetb.tag     = 'resetb';
resetb.name    = '(Re)set b value';
resetb.val     = {b };
resetb.help    = {''};
% ---------------------------------------------------------------------
% g Gradient direction values
% ---------------------------------------------------------------------
g         = cfg_entry;
g.tag     = 'g';
g.name    = 'Gradient direction values';
g.help    = {'A #img-by-3 matrix of gradient directions. The length of each gradient vector will be used as a scaling factor to the b value. Therefore, you should make sure that your gradient vectors are of unit length if your b value already encodes for diffusion weighting strength.'};
g.strtype = 'e';
g.num     = [Inf 3];
% ---------------------------------------------------------------------
% reset (Re)set Gradient
% ---------------------------------------------------------------------
reset         = cfg_branch;
reset.tag     = 'reset';
reset.name    = '(Re)set Gradient';
reset.val     = {g };
reset.help    = {''};
% ---------------------------------------------------------------------
% M Reset orientation
% ---------------------------------------------------------------------
M         = cfg_const;
M.tag     = 'M';
M.name    = 'Reset orientation';
M.val{1} = double(1);
M.help    = {''};
% ---------------------------------------------------------------------
% resetM (Re)set position
% ---------------------------------------------------------------------
resetM         = cfg_branch;
resetM.tag     = 'resetM';
resetM.name    = '(Re)set position';
resetM.val     = {M };
resetM.help    = {''};
% ---------------------------------------------------------------------
% setM Add M matrix to existing DTI information
% ---------------------------------------------------------------------
setM         = cfg_const;
setM.tag     = 'setM';
setM.name    = 'Add M matrix to existing DTI information';
setM.val{1} = double(1);
setM.help    = {''};
% ---------------------------------------------------------------------
% initopts (Re)Set what?
% ---------------------------------------------------------------------
initopts         = cfg_choice;
initopts.tag     = 'initopts';
initopts.name    = '(Re)Set what?';
initopts.help    = {''};
initopts.values  = {resetall resetbg resetb reset resetM setM };
% ---------------------------------------------------------------------
% init_dtidata (Re)Set DTI information
% ---------------------------------------------------------------------
init_dtidata         = cfg_exbranch;
init_dtidata.tag     = 'dti_init_dtidata';
init_dtidata.name    = '(Re)Set DTI information';
init_dtidata.val     = {srcimgs initopts };
init_dtidata.help    = {
                            'Initialise userdata of diffusion weighted images'
                            ''
                            'This routine allows to (re)set diffusion and orientation information for a series of diffusion weighted images (the orientation part can be used for other image series as well).'
                            'Diffusion information needs to be given for each individual image as a vector of b values and a number-of-images-by-3 matrix of diffusion gradient directions. This toolbox assumes that gradient directions are given in "world space". spm_input will read diffusion information from workspace  variables if you type the variable name in the input field or even load it from a file. So, if you have to set diffusion information for a set of repeated measurements with diffusion information for one measurement stored in ''dti.txt'', you could use the syntax'
                            'repmat(load(''dti.txt''),nrep,1)'
                            'where dti.txt contains gradient information for all images within a repetition (one row with 3 columns per direction).'
                            'This routine is useful to initialise diffusion weighted images that have no diffusion information available in its DICOM header or to re-initialise images that have already been processed (e.g. to redo realignment).'
                            ''
                            'Batch processing:'
                            'FORMAT dti_init_dtidata(bch)'
                            '======'
                            'Input argument:'
                            'bch struct with fields'
                            '/*\begin{description}*/'
                            '/*\item[*/       .srcimgs/*]*/ cell array of file names'
                            '/*\item[*/       .b/*]*/       numel(files)-by-1 vector of b values'
                            '/*\item[*/       .g/*]*/       numel(files)-by-3 matrix of diffusion weighting directions'
                            '/*\item[*/       .M/*]*/       4x4 transformation matrix. If not set, and position should be reset, then the space will be reset to the saved information from DTI userdata. If this information is not available, the space of the first image is taken as reference.'
                            '/*\end{description}*/'
                            'To add .M to DTI userdata, no additional input is necessary. In this case, the current .mat information (obtained from spm_get_space) will be saved if DTI userdata exists.'
                            'Note that re-setting .b or .g does not re-set the saved reference .mat. However, if no diffusion information was present before, also .mat will be created with the current space information. This occurs after a .M has been processed, so that redoing reorientation and setting diffusion information can be done in one step per image.'
                            ''
                            'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                            'spm_help vgtbx_config_Diffusion'
                            'in the matlab command window after the toolbox has been launched.'
                            '_______________________________________________________________________'
                            ''
                            '@(#) $Id$'
}';
init_dtidata.prog = @dti_init_dtidata;
init_dtidata.vout = @vout_dti_init_dtidata;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [2 Inf];
% ---------------------------------------------------------------------
% infix Output Filename Infix
% ---------------------------------------------------------------------
infix         = cfg_entry;
infix.tag     = 'infix';
infix.name    = 'Output Filename Infix';
infix.val = {''};
infix.help    = {['The output filename is constructed by prefixing ''m/s'' and this infix to ' ...
                  'the original filename.']};
infix.strtype = 's';
infix.num     = [0 Inf];
% ---------------------------------------------------------------------
% dw_wmean_variance Weighted Means and Variances
% ---------------------------------------------------------------------
dw_wmean_variance         = cfg_exbranch;
dw_wmean_variance.tag     = 'dw_wmean_variance';
dw_wmean_variance.name    = 'Weighted Means and Variances';
dw_wmean_variance.val     = {srcimgs infix};
dw_wmean_variance.help    = {'This tool calculates the weighted means and variances for a set of diffusion weighted images.'};
dw_wmean_variance.prog = @(job)dti_dw_wmean_variance('run',job);
dw_wmean_variance.vout = @(job)dti_dw_wmean_variance('vout',job);
% ---------------------------------------------------------------------                                                                                                                 
% osrcimgs - Source Images                                                                                                                                                                 
% ---------------------------------------------------------------------                                                                                                                 
osrcimgs         = cfg_files;                                                                                                                                                            
osrcimgs.tag     = 'osrcimgs';                                                                                                                                                            
osrcimgs.name    = 'Source Images';                                                                                                                                                      
osrcimgs.help    = {'A list of images to be analysed. The computed selection indices will refer to this list of images.'};                                                               
osrcimgs.filter = 'image';                                                                                                                                                               
osrcimgs.ufilter = '.*';                                                                                                                                                                 
osrcimgs.num     = [1 Inf];                                                                                                                                                              
% ---------------------------------------------------------------------                                                                                                                 
% msrcimgs - Source Images                                                                                                                                                                 
% ---------------------------------------------------------------------                                                                                                                 
msrcimgs         = cfg_files;                                                                                                                                                            
msrcimgs.tag     = 'msrcimgs';                                                                                                                                                            
msrcimgs.name    = '(Weighted) Mean Images';                                                                                                                                                      
msrcimgs.help    = {'A list of (weighted) mean images or a single mean image.'};                                                               
msrcimgs.filter = 'image';                                                                                                                                                               
msrcimgs.ufilter = '.*';                                                                                                                                                                 
msrcimgs.num     = [1 Inf];                                                                                                                                                              
% ---------------------------------------------------------------------                                                                                                                 
% ssrcimgs - Source Images                                                                                                                                                                 
% ---------------------------------------------------------------------                                                                                                                 
ssrcimgs         = cfg_files;                                                                                                                                                            
ssrcimgs.tag     = 'ssrcimgs';                                                                                                                                                            
ssrcimgs.name    = '(Weighted) Standard Deviation Images';                                                                                                                                                      
ssrcimgs.help    = {'A list of (weighted) standard deviation images or a single standard deviation image.'};                                                               
ssrcimgs.filter = 'image';                                                                                                                                                               
ssrcimgs.ufilter = '.*';                                                                                                                                                                 
ssrcimgs.num     = [1 Inf];                                                                                                                                                              
% ---------------------------------------------------------------------                                                                                                                 
% maskimg - Mask Image (optional)                                                                                                                                                 
% ---------------------------------------------------------------------                                                                                                                 
maskimg         = cfg_files;                                                                                                                                                            
maskimg.tag     = 'maskimg';                                                                                                                                                            
maskimg.name    = 'Mask Image (optional)';                                                                                                                                                      
maskimg.help    = {'If supplied, each source image will be weighted by this mask image before clustering.'
    'The mask image should have values between 0 (voxel does not belong to ROI) and 1 (voxel does belong to ROI). Fractional values are allowed.'};                                                               
maskimg.filter = 'image';                                                                                                                                                               
maskimg.ufilter = '.*';                                                                                                                                                                 
maskimg.num     = [0 1];                                                                                                                                                              
% ---------------------------------------------------------------------                                                                                                                 
% th Intensity Threshold                                                                                                                                                                
% ---------------------------------------------------------------------                                                                                                                 
th         = cfg_entry;                                                                                                                                                                 
th.tag     = 'th';                                                                                                                                                                      
th.name    = 'Intensity Threshold';                                                                                                                                                     
th.help    = {'The source images will be thresholded at this intensity. Those voxels which have a higher intensity than this threshold will be counted and clustered.'};                
th.strtype = 'r';                                                                                                                                                                       
th.num     = [1  1];                                                                                                                                                                    
% ---------------------------------------------------------------------                                                                                                                 
% csize Minimum Cluster Size                                                                                                                                                            
% ---------------------------------------------------------------------                                                                                                                 
csize         = cfg_entry;                                                                                                                                                              
csize.tag     = 'csize';                                                                                                                                                                
csize.name    = 'Minimum Cluster Size';                                                                                                                                                 
csize.help    = {'An image will be excluded from the selection list if at least one cluster at the specified intensity threshold exceed the minimum cluster size defined here.'};       
csize.strtype = 'w';                                                                                                                                                                    
csize.num     = [1  1];                                                                                                                                                                 
% ---------------------------------------------------------------------                                                                                                                 
% thresh Threshold Specification                                                                                                                                                        
% ---------------------------------------------------------------------                                                                                                                 
thresh         = cfg_branch;                                                                                                                                                            
thresh.tag     = 'thresh';                                                                                                                                                              
thresh.name    = 'Threshold Specification';                                                                                                                                             
thresh.val     = {th csize };                                                                                                                                                           
% ---------------------------------------------------------------------                                                                                                                 
% threshs Threshold Specifications                                                                                                                                                      
% ---------------------------------------------------------------------                                                                                                                 
threshs         = cfg_repeat;                                                                                                                                                           
threshs.tag     = 'threshs';                                                                                                                                                            
threshs.name    = 'Threshold Specifications';                                                                                                                                           
threshs.help    = {'One or more threshold specifications can be given. An image will be excluded from the final selection if it is excluded by one or more of the threshold criteria.'};
threshs.values  = {thresh };                                                                                                                                                            
threshs.num     = [1 Inf];                                                                                                                                                              
% ---------------------------------------------------------------------                                                                                                                 
% dw_cluster_std_differences Cluster and Select Images                                                                                                                                  
% ---------------------------------------------------------------------                                                                                                                 
dw_cluster_std_differences         = cfg_exbranch;                                                                                                                                      
dw_cluster_std_differences.tag     = 'dw_cluster_std_differences';                                                                                                                      
dw_cluster_std_differences.name    = 'Cluster and Select Images';                                                                                                                       
dw_cluster_std_differences.val     = {osrcimgs msrcimgs ssrcimgs maskimg threshs };                                                                                                                                
dw_cluster_std_differences.prog = @(job)dti_dw_cluster_std_differences('run',job);                                                                                                      
dw_cluster_std_differences.vout = @(job)dti_dw_cluster_std_differences('vout',job);                                                                                                     
dw_cluster_std_differences.check = @(job)dti_dw_cluster_std_differences('check','srcimgs',job);                                                                                                     
% ---------------------------------------------------------------------
% osrcimgs Original Images
% ---------------------------------------------------------------------
osrcimgs         = cfg_files;
osrcimgs.tag     = 'osrcimgs';
osrcimgs.name    = 'Original Images';
osrcimgs.filter = 'image';
osrcimgs.ufilter = '.*';
osrcimgs.num     = [2 Inf];
% ---------------------------------------------------------------------
% msrcimgs Weighted Mean Images
% ---------------------------------------------------------------------
msrcimgs         = cfg_files;
msrcimgs.tag     = 'msrcimgs';
msrcimgs.name    = 'Weighted Mean Images';
msrcimgs.filter = 'image';
msrcimgs.ufilter = '.*';
msrcimgs.num     = [2 Inf];
% ---------------------------------------------------------------------
% ssrcimgs Weighted Mean Images
% ---------------------------------------------------------------------
ssrcimgs         = cfg_files;
ssrcimgs.tag     = 'ssrcimgs';
ssrcimgs.name    = 'Weighted Standard Deviation Images';
ssrcimgs.filter = 'image';
ssrcimgs.ufilter = '.*';
ssrcimgs.num     = [2 Inf];
% ---------------------------------------------------------------------
% summary Difference Summary
% ---------------------------------------------------------------------
summary        = cfg_menu;
summary.tag    = 'summary';
summary.name   = 'Difference Summary';
summary.labels = {
    'Sum standard Differences'
    '#vox > Standard Difference Threshold';
    'Sum squared Differences'
    'Sum percent Differences'
    '#vox > Percent Difference Threshold';
    };
summary.values = {5; 4; 3; 2; 1};
summary.def    = @(val)dti_dw_wmean_review('defaults','summaryopts.summary',val{:});
% ---------------------------------------------------------------------
% mapping Intensity Mapping
% ---------------------------------------------------------------------
mapping        = cfg_menu;
mapping.tag    = 'mapping';
mapping.name   = 'Intensity Mapping';
mapping.labels = {
    'Linear'
    'Log'
    };
mapping.values = {2; 1};
mapping.def    = @(val)dti_dw_wmean_review('defaults','summaryopts.mapping',val{:});
% ---------------------------------------------------------------------
% grouping Image Grouping
% ---------------------------------------------------------------------
grouping        = cfg_menu;
grouping.tag    = 'grouping';
grouping.name   = 'Image Grouping';
grouping.labels = {
    'All Data'
    'Per b-Value'
    'Per Image'
    };
grouping.values = {3; 2; 1};
grouping.def    = @(val)dti_dw_wmean_review('defaults','summaryopts.grouping',val{:});
% ---------------------------------------------------------------------
% summaryopts Summary Display Options
% ---------------------------------------------------------------------
summaryopts      = cfg_branch;
summaryopts.tag  = 'summaryopts';
summaryopts.name = 'Summary Display Options';
summaryopts.val  = {summary mapping grouping};
% ---------------------------------------------------------------------
% pthresh Percent Difference Threshold
% ---------------------------------------------------------------------
pthresh         = cfg_entry;
pthresh.tag     = 'pthresh';
pthresh.name    = 'Percent Difference Threshold';
pthresh.strtype = 'r';
pthresh.num     = [1 1];
pthresh.def     = @(val)dti_dw_wmean_review('defaults','threshopts.pthresh',val{:});
% ---------------------------------------------------------------------
% sdthresh Standard Difference Threshold
% ---------------------------------------------------------------------
sdthresh         = cfg_entry;
sdthresh.tag     = 'sdthresh';
sdthresh.name    = 'Standard Difference Threshold';
sdthresh.strtype = 'r';
sdthresh.num     = [1 1];
sdthresh.def     = @(val)dti_dw_wmean_review('defaults','threshopts.sdthresh',val{:});
% ---------------------------------------------------------------------
% threshopts Threshold Options
% ---------------------------------------------------------------------
threshopts      = cfg_branch;
threshopts.tag  = 'threshopts';
threshopts.name = 'Threshold Options';
threshopts.val  = {pthresh sdthresh};
% ---------------------------------------------------------------------
% dw_wmean_review Review Weighted Means and Variances
% ---------------------------------------------------------------------
dw_wmean_review         = cfg_exbranch;
dw_wmean_review.tag     = 'dw_wmean_review';
dw_wmean_review.name    = 'Review Weighted Means and Variances';
dw_wmean_review.val     = {osrcimgs msrcimgs ssrcimgs summaryopts threshopts};
dw_wmean_review.help    = {'Review Weighted Means and Variances.'};
dw_wmean_review.prog = @(job)dti_dw_wmean_review('run',job);
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {'The source images (one or more).'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% b0corr Motion correction on b0 images
% ---------------------------------------------------------------------
b0corr         = cfg_menu;
b0corr.tag     = 'b0corr';
b0corr.name    = 'Motion correction on b0 images';
b0corr.help    = {''};
b0corr.labels = {
                 'None'
                 'Stepwise'
                 'Linear interpolation (last stepwise)'
                 'Linear interpolation (last linear)'
}';
b0corr.values = {0 1 2 3};
% ---------------------------------------------------------------------
% b1corr Motion correction on all (b0+DW) images
% ---------------------------------------------------------------------
b1corr         = cfg_menu;
b1corr.tag     = 'b1corr';
b1corr.name    = 'Motion correction on all (b0+DW) images';
b1corr.help    = {''};
b1corr.labels = {
                 'None'
                 'Realign xy'
                 'Realign per dw separately'
                 'Realign xy & Coregister to mean'
                 'Full Realign & Coregister (rigid body) to mean'
                 'Full Realign & Coregister (full affine) to mean'
                 'Realign (rigid body) to weighted means'
                 'Realign (full affine) to weighted means'
}';
b1corr.values = {0 1 2 3 4 5 6 7};
% ---------------------------------------------------------------------
% dti_realign Realign DW image time series
% ---------------------------------------------------------------------
realign         = cfg_exbranch;
realign.tag     = 'dti_realign';
realign.name    = 'Realign DW image time series';
realign.val     = {srcimgs b0corr b1corr };
realign.help    = {
                       'Determine realignment parameters for diffusion weighted images'
                       ''
                       'Motion correction of diffusion weighted images can not be done by simply using SPMs realignment procedure, because images with different diffusion weighting show different contrast and signal/noise ratio. This would violate the assumptions on which the realignment code is based.'
                       'In a repeated measurement scenario, the solution could be separate realignment of images with different diffusion weighting. However, this does not work well for high b values, and it does not work at all without repeated measurements. Without repeated measurements, it is recommended to insert additional b0 scans into your acquisition every 6-10 diffusion weighting directions.'
                       'Motion correction can then be performed on the b0 images and the parameters applied to the corresponding diffusion weighted images. Three different options for motion correction based on b0 images are available:'
                       '/*\begin{description}*/'
                       '/*\item[*/ Stepwise correction/*]*/'
                       'Movement parameters for a b0 image will be applied unchanged to all following diffusion weighted images up to the next b0 image.'
                       '/*\item[*/ Linear correction/*]*/'
                       'For all but the diffusion weighting images following the last b0 image, motion parameters will be determined by linear interpolation between the two sets of motion parameters of b0 images. There are two possibilities for images in the last series:'
                       '/*\begin{description}*/'
                       '/*\item[*/         last stepwise/*]*/ Do a stepwise correction for the last images'
                       '/*\item[*/         last linear/*]*/ Extrapolate motion parameters from difference between last b0 images. This option might be useful if there is a linear scanner drift that is larger than voluntary head movement.'
                       '/*\end{description}*//*\end{description}*/'
                       'In addition (or alternatively, if no time series of b0 images exists), motion correction can be performed on diffusion weighted images:'
                       '/*\begin{description}*/'
                       '/*\item[*/ Realign xy/*]*/'
                       'The b1 images are realigned within xy plane.'
                       '/*\item[*/ Coregister to mean/*]*/'
                       'From the realigned diffusion images a mean image is created. The b1 images are then coregistered to this mean image.'
                       '/*\end{description}*/'
                       'The images itself are not resliced during this step, only position information in NIFTI headers is updated. If necessary, images can be resliced to the space of the 1st image by choosing "Realign->Reslice only" from standard SPM and selecting all images of all series together in the correct order. This step can be skipped, if images will be normalised before tensor estimation. Gradient directions need to be adjusted prior to running tensor estimation using dti_reorient_gradients.'
                       ''
                       'Batch processing:'
                       'FORMAT dti_realign(bch)'
                       '======   Input argument:'
                       'bch struct with fields'
                       '/*\begin{description}*/'
                       '/*\item[*/       .files/*]*/  cell array of image filenames. Images are classified as b0 or b1 by inspection of the diffusion information in userdata using dti_extract_dirs. /*\item[*/       .b0corr/*]*/ Motion correction on b0 images'
                       '/*\item[*/       .b1corr/*]*/ Motion correction on b1 images'
                       '/*\end{description}*/'
                       'This function is part of the diffusion toolbox for SPM5. For general  help about this toolbox, bug reports, licensing etc. type'
                       'spm_help vgtbx_config_Diffusion'
                       'in the matlab command window after the toolbox has been launched.'
                       '_______________________________________________________________________'
                       ''
                       '@(#) $Id$'
}';
realign.prog = @dti_realign;
realign.vout = @vout_dti_realign;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {'Diffusion information will be read from these images.'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% tgtimgs Target images
% ---------------------------------------------------------------------
tgtimgs         = cfg_files;
tgtimgs.tag     = 'tgtimgs';
tgtimgs.name    = 'Target images';
tgtimgs.help    = {'Diffusion information will be copied to this images, applying motion correction and (optional) normalisation information to gradient directions.'};
tgtimgs.filter = 'image';
tgtimgs.ufilter = '.*';
tgtimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% snparams Normalisation parameters (optional)
% ---------------------------------------------------------------------
snparams         = cfg_files;
snparams.tag     = 'snparams';
snparams.name    = 'Normalisation parameters (optional)';
snparams.val = {''};
snparams.help    = {'A file containing spatial normalisation parameters. Spatial transformations from normalisation will be read from this file.'};
snparams.filter = 'mat';
snparams.ufilter = '.*sn.*';
snparams.num     = [0 1];
% ---------------------------------------------------------------------
% rot Rotation
% ---------------------------------------------------------------------
rot         = cfg_menu;
rot.tag     = 'rot';
rot.name    = 'Rotation';
rot.help    = {''};
rot.labels = {
              'Yes'
              'No'
}';
rot.values{1} = double(1);
rot.values{2} = double(0);
% ---------------------------------------------------------------------
% zoom Zoom
% ---------------------------------------------------------------------
zoom         = cfg_menu;
zoom.tag     = 'zoom';
zoom.name    = 'Zoom';
zoom.help    = {''};
zoom.labels = {
               'Sign of zooms'
               'Sign and magnitude'
               'No'
}';
zoom.values{1} = double(1);
zoom.values{2} = double(2);
zoom.values{3} = double(0);
% ---------------------------------------------------------------------
% shear Shear
% ---------------------------------------------------------------------
shear         = cfg_menu;
shear.tag     = 'shear';
shear.name    = 'Shear';
shear.help    = {''};
shear.labels = {
                'Yes'
                'No'
}';
shear.values{1} = double(1);
shear.values{2} = double(0);
% ---------------------------------------------------------------------
% useaff Affine Components for Reorientation
% ---------------------------------------------------------------------
useaff         = cfg_branch;
useaff.tag     = 'useaff';
useaff.name    = 'Affine Components for Reorientation';
useaff.val     = {rot zoom shear };
useaff.help    = {'Select which parts of an affine transformation to consider for reorientation.'};
% ---------------------------------------------------------------------
% dti_reorient_gradient Copy and Reorient diffusion information
% ---------------------------------------------------------------------
reorient_gradient         = cfg_exbranch;
reorient_gradient.tag     = 'dti_reorient_gradient';
reorient_gradient.name    = 'Copy and Reorient diffusion information';
reorient_gradient.val     = {srcimgs tgtimgs snparams useaff };
reorient_gradient.help    = {
                                 'Apply image reorientation information to diffusion gradients'
                                 ''
                                 'This function needs to be called once after all image realignment, coregistration or normalisation steps have been performed, i.e. after the images have been resliced or written normalised. Without calling this function immediately after reslicing or normalisation, all diffusion information is lost. /*\textbf{*/This is a major change to the functionality of the toolbox compared to SPM2!/*}*/'
                                 'It applies the rotations performed during realignment, coregistration and affine normalisation to the gradient direction vectors. This is done by comparing the original orientation information (saved in the images userdata by dti_init_dtidata) with the current image orientation.'
                                 'After applying this correction a reset of DTI information will not be able to recover the initial gradient or orientation values, since the original orientation matrix will be lost.'
                                 ''
                                 'Batch processing:'
                                 'FORMAT dti_reorient_gradient(bch)'
                                 '======'
                                 'Input argument'
                                 'bch struct with fields:'
                                 '/*\begin{description}*/'
                                 '/*\item[*/      .srcimgs/*]*/  cell array of file names (usually the un-resliced, un-normalised images)'
                                 '/*\item[*/       .tgtimgs/*]*/  target images (can be the same files as srcimgs, but usually the resliced or normalised images).'
                                 '/*\item[*/       .snparams/*]*/ optional normalisation parameters file used to write the images normalised.'
                                 '/*\end{description}*/'
                                 'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                                 'spm_help vgtbx_config_Diffusion'
                                 'in the matlab command window after the toolbox has been launched.'
                                 '_______________________________________________________________________'
                                 ''
                                 '@(#) $Id: dti_reorient_gradient.m 464 2006-10-04 14:00:44Z volkmar $'
}';
reorient_gradient.prog = @dti_reorient_gradient;
reorient_gradient.vout = @vout_dti_reorient_gradient;
reorient_gradient.check = @check_dti_reorient_gradient;

% ---------------------------------------------------------------------
% file0 B0 image
% ---------------------------------------------------------------------
file0         = cfg_files;
file0.tag     = 'file0';
file0.name    = 'B0 image';
file0.help    = {'Select the b0 image for ADC computation.'};
file0.filter = 'image';
file0.ufilter = '.*';
file0.num     = [1 1];
% ---------------------------------------------------------------------
% files1 DW image(s)
% ---------------------------------------------------------------------
files1         = cfg_files;
files1.tag     = 'files1';
files1.name    = 'DW image(s)';
files1.help    = {'Diffusion weighted images - one ADC image per DW image will be produced.'};
files1.filter = 'image';
files1.ufilter = '.*';
files1.num     = [1 Inf];
% ---------------------------------------------------------------------
% minS Minimum Signal Threshold
% ---------------------------------------------------------------------
minS         = cfg_entry;
minS.tag     = 'minS';
minS.name    = 'Minimum Signal Threshold';
minS.val{1} = double(1);
minS.help    = {'Logarithm of values below 1 will produce negative ADC results. Very low intensities are probably due to noise and should be masked out.'};
minS.strtype = 'e';
minS.num     = [1 1];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'adc_'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {''};
interp.labels = {
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree b-Spline'
                 '3rd Degree b-Spline'
                 '4th Degree b-Spline'
                 '5th Degree b-Spline'
                 '6th Degree b-Spline'
                 '7th Degree b-Spline'
                 '2nd Degree Sinc'
                 '3rd Degree Sinc'
                 '4th Degree Sinc'
                 '5th Degree Sinc'
                 '6th Degree Sinc'
                 '7th Degree Sinc'
}';
interp.values{1} = double(0);
interp.values{2} = double(1);
interp.values{3} = double(2);
interp.values{4} = double(3);
interp.values{5} = double(4);
interp.values{6} = double(5);
interp.values{7} = double(6);
interp.values{8} = double(7);
interp.values{9} = double(-2);
interp.values{10} = double(-3);
interp.values{11} = double(-4);
interp.values{12} = double(-5);
interp.values{13} = double(-6);
interp.values{14} = double(-7);
% ---------------------------------------------------------------------
% dti_adc Compute ADC Images
% ---------------------------------------------------------------------
adc         = cfg_exbranch;
adc.tag     = 'dti_adc';
adc.name    = 'Compute ADC Images';
adc.val     = {file0 files1 minS prefix interp };
adc.help    = {
                   'ADC computation'
                   ''
                   'Computes ADC maps from 2 b values (lower b value is assumed to be zero). More than one image can be entered for the high b value, in this case it is necessary to specify one b value per image. If available, this b value will be read from the userdata field of the image handle.'
                   ''
                   'Output images are saved as adc_<FILENAME_OF_B1_IMAGE>.img .'
                   ''
                   'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                   'spm_help vgtbx_config_Diffusion'
                   'in the matlab command window after the toolbox has been launched.'
                   '_______________________________________________________________________'
                   ''
                   '@(#) $Id$'
}';
adc.prog = @dti_adc;
adc.vout = @vout_dti_adc;
% ---------------------------------------------------------------------
% files ADC images
% ---------------------------------------------------------------------
files         = cfg_files;
files.tag     = 'files';
files.name    = 'ADC images';
files.help    = {'The source images (one or more).'};
files.filter = 'image';
files.ufilter = '.*';
files.num     = [6 6];
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {''};
interp.labels = {
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree b-Spline'
                 '3rd Degree b-Spline'
                 '4th Degree b-Spline'
                 '5th Degree b-Spline'
                 '6th Degree b-Spline'
                 '7th Degree b-Spline'
                 '2nd Degree Sinc'
                 '3rd Degree Sinc'
                 '4th Degree Sinc'
                 '5th Degree Sinc'
                 '6th Degree Sinc'
                 '7th Degree Sinc'
}';
interp.values{1} = double(0);
interp.values{2} = double(1);
interp.values{3} = double(2);
interp.values{4} = double(3);
interp.values{5} = double(4);
interp.values{6} = double(5);
interp.values{7} = double(6);
interp.values{8} = double(7);
interp.values{9} = double(-2);
interp.values{10} = double(-3);
interp.values{11} = double(-4);
interp.values{12} = double(-5);
interp.values{13} = double(-6);
interp.values{14} = double(-7);
% ---------------------------------------------------------------------
% dti_dt_adc Compute Tensor from 6 ADC Images
% ---------------------------------------------------------------------
dt_adc         = cfg_exbranch;
dt_adc.tag     = 'dti_dt_adc';
dt_adc.name    = 'Compute Tensor from 6 ADC Images';
dt_adc.val     = {files interp };
dt_adc.help    = {
                      'Compute diffusion tensor from 6 ADC images'
                      ''
                      'This function computes diffusion tensors of order 2 from exactly 6 ADC images that have been acquired with different diffusion weightings. If your dataset consists of more diffusion weightings or repeated measurements with 6 diffusion weightings, use the regression method to compute the tensors from the original diffusion weighted images.'
                      ''
                      'This routine tries to figure out gradient direction from userdata field of the ADC images. This may fail if'
                      '/*\begin{itemize}*/'
                      '/*\item*/ there is no userdata: in this case, the following direction scheme is assumed:'
                      '/*\begin{tabular}{c|ccccccc}*/'
                      '/*&*/    b0 /*&*/ im1 /*&*/ im2 /*&*/ im3 /*&*/ im4 /*&*/ im5 /*&*/ im6 /*\\*/'
                      '/*\hline*/'
                      'x /*&*/   0 /*&*/  0 /*&*/   0 /*&*/   1 /*&*/   1 /*&*/   1 /*&*/   1 /*\\*/'
                      'y /*&*/   0 /*&*/  1 /*&*/   1 /*&*/   0 /*&*/   0 /*&*/   1 /*&*/  -1 /*\\*/'
                      'z /*&*/   0 /*&*/  1 /*&*/  -1 /*&*/   1 /*&*/  -1 /*&*/   0 /*&*/   0'
                      '/*\end{tabular}*/'
                      '/*\item*/ there are some identical directions in userdata: This happens with some SIEMENS standard sequences on Symphony/Sonata/Trio systems. In that case, a warning is issued and SIEMENS standard values are used.'
                      '/*\end{itemize}*/'
                      '/* The algorithm used in this routine is based on \cite{basser98}, */ /* although the direction scheme actually used depends on the applied */ /* diffusion imaging sequence.*/'
                      ''
                      'This function is part of the diffusion toolbox for SPM5. For general help  about this toolbox, bug reports, licensing etc. type'
                      'spm_help vgtbx_config_Diffusion'
                      'in the matlab command window after the toolbox has been launched.'
                      '_______________________________________________________________________'
                      ''
                      '@(#) $Id$'
}';
dt_adc.prog = @dti_dt_adc;
dt_adc.vfiles = @vfiles_dti_dt_adc;
% ---------------------------------------------------------------------
% srcimgs DW images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'DW images';
srcimgs.help    = {'Enter all diffusion weighted images (all replicated measurements, all diffusion weightings) and b0 images at once.'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [8 Inf];
% ---------------------------------------------------------------------
% srcscaling Data scaling
% ---------------------------------------------------------------------
srcscaling        = cfg_menu;
srcscaling.tag    = 'srcscaling';
srcscaling.name   = 'Data scaling';
srcscaling.labels = {'Raw DW data';'Ln(DW data)'};
srcscaling.values = {'raw';'log'};
srcscaling.val    = {'raw'};
srcscaling.help   = {'Specify whether input data are raw or log scaled.'};
% ---------------------------------------------------------------------
% erriid Equal errors, equal variance
% ---------------------------------------------------------------------
erriid         = cfg_const;
erriid.tag     = 'erriid';
erriid.name    = 'Equal errors, equal variance';
erriid.val{1} = double(1);
erriid.help    = {''};
% ---------------------------------------------------------------------
% ltol B value tolerance
% ---------------------------------------------------------------------
ltol         = cfg_entry;
ltol.tag     = 'ltol';
ltol.name    = 'B value tolerance';
ltol.help    = {'B values will be divided by this tolerance value and then rounded. Any b values that are still different after rounding, will be treated as different.'};
ltol.strtype = 'e';
ltol.num     = [1 1];
% ---------------------------------------------------------------------
% dtol Gradient direction tolerance
% ---------------------------------------------------------------------
dtol         = cfg_entry;
dtol.tag     = 'dtol';
dtol.name    = 'Gradient direction tolerance';
dtol.help    = {
                'Determines which gradient vectors describe similar directions. Colinearity will be computed as the scalar product between two unit-length gradient vectors.'
                ''
                'Two gradient vectors are treated as similar, if their scalar product is larger than the tolerance value. This means a tolerance value of -1 will treat all directions as similar, whereas a positive value between 0 and 1 will distinguish between different directions.'
}';
dtol.strtype = 'e';
dtol.num     = [1 1];
% ---------------------------------------------------------------------
% sep Distinguish antiparallel gradient directions
% ---------------------------------------------------------------------
sep         = cfg_menu;
sep.tag     = 'sep';
sep.name    = 'Distinguish antiparallel gradient directions';
sep.help    = {
               'In theory, antiparallel gradient directions should be equivalent when measuring diffusion. However, due to possible scanner effects this might be not true.'
               ''
               'If this entry is set to ''Yes'' then antiparallel gradient directions will be treated as different from each other.'
}';
sep.labels = {
              'Yes'
              'No'
}';
sep.values{1} = double(1);
sep.values{2} = double(0);
% ---------------------------------------------------------------------
% errauto Auto-determined by b-values
% ---------------------------------------------------------------------
errauto         = cfg_branch;
errauto.tag     = 'errauto';
errauto.name    = 'Auto-determined by b-values';
errauto.val     = {ltol dtol sep };
errauto.help    = {
                   'Automatic determination of error variance components from diffusion weighting information. This is the recommended method.'
                   ''
                   'To discriminate between b values, but not directions, set direction tolerance to 0 and do not distinguish between antiparallel directions.'
}';
% ---------------------------------------------------------------------
% inorder Input Order
% ---------------------------------------------------------------------
inorder         = cfg_menu;
inorder.tag     = 'inorder';
inorder.name    = 'Input Order';
inorder.help    = {'The input order determines the way in which error covariance components are specified: the assumption is that error covariances are equal over similar diffusion weightings. If images are given replication by replication, the ordering of diffusion weighting should be the same for each replication.'};
inorder.labels = {
                  'repl1 all b | repl2 all b ... replX all b'
                  'b1 all repl | b2 all repl ... bX all repl'
}';
inorder.values = {
                  'repl'
                  'bval'
}';
% ---------------------------------------------------------------------
% ndw # of different diffusion weightings
% ---------------------------------------------------------------------
ndw         = cfg_entry;
ndw.tag     = 'ndw';
ndw.name    = '# of different diffusion weightings';
ndw.help    = {'Give the number of different diffusion weightings. The product of #dw and #rep must match the number of your images.'};
ndw.strtype = 'n';
ndw.num     = [1 1];
% ---------------------------------------------------------------------
% nrep # of repetitions
% ---------------------------------------------------------------------
nrep         = cfg_entry;
nrep.tag     = 'nrep';
nrep.name    = '# of repetitions';
nrep.help    = {'Give the number of repeated measurements. The product of #dw and #rep must match the number of your images.'};
nrep.strtype = 'n';
nrep.num     = [1 1];
% ---------------------------------------------------------------------
% errspec User specified
% ---------------------------------------------------------------------
errspec         = cfg_branch;
errspec.tag     = 'errspec';
errspec.name    = 'User specified';
errspec.val     = {inorder ndw nrep };
errspec.help    = {'Specify error variance components for repeated measurements with similar diffusion weighting in each repetition.'};
% ---------------------------------------------------------------------
% errorvar Error variance options
% ---------------------------------------------------------------------
errorvar         = cfg_choice;
errorvar.tag     = 'errorvar';
errorvar.name    = 'Error variance options';
errorvar.help    = {'Diffusion weighted images may have different error variances depending on diffusion gradient strength and directions. To correct for this, one can model error variances based on diffusion information or measurement order.'};
errorvar.values  = {erriid errauto errspec };
% ---------------------------------------------------------------------
% dtorder Tensor order
% ---------------------------------------------------------------------
dtorder         = cfg_entry;
dtorder.tag     = 'dtorder';
dtorder.name    = 'Tensor order';
dtorder.help    = {'Enter an even number (default 2). This determines the order of your diffusion tensors. Higher order tensors can be estimated only from data with many different diffusion weighting directions. See the referenced literature/*\cite{Orszalan2003}*/ for details.'};
dtorder.strtype = 'n';
dtorder.num     = [1 1];
% ---------------------------------------------------------------------
% maskimg Mask Image (optional)
% ---------------------------------------------------------------------
maskimg         = cfg_files;
maskimg.tag     = 'maskimg';
maskimg.name    = 'Mask Image (optional)';
maskimg.val = {{''}};
maskimg.help    = {
                   'Specify an image for masking your data. Only voxels where this image has non-zero intensity will be processed.'
                   ''
                   'This image is optional. If not specified, the whole volume will be analysed.'
                   ''
                   'For a proper estimation of error covariances, non-brain voxels should be excluded by an explicit mask. This could be an mask based on an intensity threshold of your b0 images or a mask based on grey and white matter segments from SPM segmentation. Only voxels, with non-zero mask values will be included into analysis.'
}';
maskimg.filter = 'image';
maskimg.ufilter = '.*';
maskimg.num     = [0 1];
% ---------------------------------------------------------------------
% swd Output directory
% ---------------------------------------------------------------------
swd         = cfg_files;
swd.tag     = 'swd';
swd.name    = 'Output directory';
swd.help    = {'Files produced by this function will be written into this output directory'};
swd.filter = 'dir';
swd.ufilter = '.*';
swd.num     = [1 1];
% ---------------------------------------------------------------------
% spatsm Estimate spatial smoothness
% ---------------------------------------------------------------------
spatsm         = cfg_menu;
spatsm.tag     = 'spatsm';
spatsm.name    = 'Estimate spatial smoothness';
spatsm.help    = {'Spatial smoothness estimates are not needed if one is only interested in the tensor values itself. Estimation can be speeded up by forcing SPM not to compute it.'};
spatsm.labels = {
                 'Yes'
                 'No'
}';
spatsm.values{1} = double(1);
spatsm.values{2} = double(0);
% ---------------------------------------------------------------------
% dti_dt_regress Compute Tensor (Multiple Regression)
% ---------------------------------------------------------------------
dt_regress         = cfg_exbranch;
dt_regress.tag     = 'dti_dt_regress';
dt_regress.name    = 'Compute Tensor (Multiple Regression)';
dt_regress.val     = {srcimgs srcscaling errorvar dtorder maskimg swd spatsm };
dt_regress.help    = {
                          'Tensor(regression)'
                          ''
                          'Compute diffusion tensor components from at least 6 diffusion weighted images + 1 b0 image. Gradient directions and strength are read from the corresponding .mat files. The resulting B matrix is then given to spm_spm as design matrix for a multiple regression analysis.'
                          ''
                          'If there are repeated measurements or one measurement, but different b value levels, then options for non-sphericity correction will be offered. The rationale behind this is the different amount of error variance contained in images with different diffusion weighting. If you want to take advantage of non-spericity correction, you should use an explicit mask to exclude any non-brain voxels from analysis, because the high noise level in non-brain-areas of diffusion weighted images will render the estimation of variance components invalid.'
                          ''
                          'If there are more than 6 diffusion weighting directions in the data set, tensors of higher order can be estimated. This allows to model diffusivity  profiles in voxels with e.g. fibre crossings more accurately than with order-2 tensors.'
                          ''
                          'Output images are saved as D*_basename.img, where basename is derived from the original filenames. Directionality components are encoded by ''x'', ''y'', ''z'' letters in the filename.'
                          ''
                          '/* The algorithm used to determine the design matrix for SPM stats in this */ /* routine is based on \cite{basser94}  and is developed for the general */ /* order-n tensors in \cite{Orszalan2003}, although the direction scheme */ /* actually used depends on the applied diffusion imaging sequence. */'
                          ''
                          'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                          'spm_help vgtbx_config_Diffusion'
                          'in the matlab command window after the toolbox has been launched.'
                          '_______________________________________________________________________'
                          ''
                          '@(#) $Id$'
}';
dt_regress.prog = @dti_dt_regress;
dt_regress.vout = @vout_dti_dt_regress;
% ---------------------------------------------------------------------
% dtimg Diffusion Tensor Images
% ---------------------------------------------------------------------
dtimg         = cfg_files;
dtimg.tag     = 'dtimg';
dtimg.name    = 'Diffusion Tensor Images';
dtimg.help    = {'Select images containing diffusion tensor data. If they are not computed using this toolbox, they need to be named according to the naming conventions of the toolbox or have at least an similar alphabetical order.'};
dtimg.filter = 'image';
dtimg.ufilter = '^D([x-z][x-z])*_.*';
dtimg.num     = [6 Inf];
% ---------------------------------------------------------------------
% snparams Normalisation parameters
% ---------------------------------------------------------------------
snparams         = cfg_files;
snparams.tag     = 'snparams';
snparams.name    = 'Normalisation parameters';
snparams.help    = {'A file containing spatial normalisation parameters. Spatial transformations from normalisation will be read from this file.'};
snparams.filter = 'mat';
snparams.ufilter = '.*sn.*';
snparams.num     = [1 1];
% ---------------------------------------------------------------------
% dti_warp_tensors Warp tensors
% ---------------------------------------------------------------------
warp_tensors         = cfg_exbranch;
warp_tensors.tag     = 'dti_warp_tensors';
warp_tensors.name    = 'Warp tensors';
warp_tensors.val     = {dtimg snparams };
warp_tensors.help    = {
                            'Apply image reorientation information to diffusion gradients'
                            ''
                            'Batch processing:'
                            'FORMAT dti_warp_tensors(bch)'
                            '======'
                            'Input argument'
                            'bch struct with fields:'
                            '/*\begin{description}*/'
                            '/*\item[*/      .srcimgs/*]*/  cell array of file names (tensor images'
                            'computed from normalised images)'
                            '/*\item[*/       .snparams/*]*/ optional normalisation parameters file used to write the images normalised.'
                            '/*\end{description}*/'
                            'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                            'spm_help vgtbx_config_Diffusion'
                            'in the matlab command window after the toolbox has been launched.'
                            '_______________________________________________________________________'
                            ''
                            '@(#) $Id: dti_warp_tensors.m 464 2006-10-04 14:00:44Z volkmar $'
}';
warp_tensors.prog = @dti_warp_tensors;
% ---------------------------------------------------------------------
% dtimg Diffusion Tensor Images
% ---------------------------------------------------------------------
dtimg         = cfg_files;
dtimg.tag     = 'dtimg';
dtimg.name    = 'Diffusion Tensor Images';
dtimg.help    = {'Select images containing diffusion tensor data. If they are not computed using this toolbox, they need to be named according to the naming conventions of the toolbox or have at least an similar alphabetical order.'};
dtimg.filter = 'image';
dtimg.ufilter = '^D([x-z][x-z])*_.*';
dtimg.num     = [6 Inf];
% ---------------------------------------------------------------------
% dteigopts Decomposition output
% ---------------------------------------------------------------------
dteigopts         = cfg_menu;
dteigopts.tag     = 'dteigopts';
dteigopts.name    = 'Decomposition output';
dteigopts.help    = {''};
dteigopts.labels = {
                    'Eigenvectors and Eigenvalues'
                    'Euler angles and Eigenvalues'
                    'Eigenvalues only'
                    'Euler angles only'
                    'All'
}';
dteigopts.values = {
                    'vl'
                    'al'
                    'l'
                    'a'
                    'alv'
}';
% ---------------------------------------------------------------------
% dti_eig Tensor decomposition
% ---------------------------------------------------------------------
dtieig         = cfg_exbranch;
dtieig.tag     = 'dti_eig';
dtieig.name    = 'Tensor decomposition';
dtieig.val     = {dtimg dteigopts };
dtieig.help    = {
                   'Tensor decomposition'
                   ''
                   'Computes eigenvector components, eigenvalues and euler angles (pitch, roll, yaw convention) from diffusion tensor data.'
                   'Output image naming convention'
                   '/*\begin{itemize}*/'
                   '/*\item*/  evec1[x,y,z]*IMAGE - components of 1st eigenvector'
                   '/*\item*/  evec2[x,y,z]*IMAGE - components of 2nd eigenvector'
                   '/*\item*/  evec3[x,y,z]*IMAGE - components of 3rd eigenvector'
                   '/*\item*/  eval[1,2,3]*IMAGE  - eigenvalues'
                   '/*\item*/  euler[1,2,3]*IMAGE - euler angles'
                   '/*\end{itemize}*/'
                   'Batch processing'
                   'FORMAT res = dti_eig(bch)'
                   '======'
                   '/*\begin{itemize}*/'
                   '/*\item*/ Input argument:'
                   'bch struct with fields'
                   '/*\begin{description}*/'
                   '/*\item[*/       .dtimg/*]*/     cell array of filenames of tensor images /*\item[*/       .data/*]*/      real 6-by-Xdim-by-Ydim-by-Zdim-array of tensor elements'
                   '/*\item[*/       .dteigopts/*]*/ results wanted, a string array containing a combination of /*\begin{description}*/'
                   '/*\item[*/                   v/*]*/ (eigenvectors)'
                   '/*\item[*/                   l/*]*/ (eigenvalues)'
                   '/*\item[*/                   a/*]*/ (euler angles)/*\end{description}*/'
                   '/*\end{description}*/'
                   'Only one of ''dtimg'' or ''data'' need to be specified. If ''data'' is provided, no files will be read and outputs will be given as arrays in the returned ''res'' structure. Input order for the tensor elements is alphabetical.'
                   '/*\item*/ Output argument (only defined if bch has a ''data'' field):'
                   'res struct with fields'
                   '/*\begin{description}*/'
                   '/*\item[*/       .evec/*]*/  eigenvectors'
                   '/*\item[*/       .eval/*]*/  eigenvalues'
                   '/*\item[*/       .euler/*]*/ euler angles'
                   '/*\end{description}*/'
                   'The presence of each field depends on the option specified in the batch.'
                   '/*\end{itemize}*/'
                   ''
                   'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                   'spm_help vgtbx_config_Diffusion'
                   'in the matlab command window after the toolbox has been launched.'
                   '_______________________________________________________________________'
                   ''
                   '@(#) $Id$'
}';
dtieig.prog = @dti_eig;
dtieig.vout = @vout_dti_eig;
% ---------------------------------------------------------------------
% dtimg Diffusion Tensor Images
% ---------------------------------------------------------------------
dtimg         = cfg_files;
dtimg.tag     = 'dtimg';
dtimg.name    = 'Diffusion Tensor Images';
dtimg.help    = {'Select images containing diffusion tensor data. If they are not computed using this toolbox, they need to be named according to the naming conventions of the toolbox or have at least an similar alphabetical order.'};
dtimg.filter = 'image';
dtimg.ufilter = '^D([x-z][x-z])*_.*';
dtimg.num     = [6 Inf];
% ---------------------------------------------------------------------
% option Compute indices
% ---------------------------------------------------------------------
option         = cfg_menu;
option.tag     = 'option';
option.name    = 'Compute indices';
option.help    = {''};
option.labels = {
                 'Fractional Anisotropy'
                 'Variance Anisotropy'
                 'Average Diffusivity'
                 'Fractional+Variance Anisotropy'
                 'All'
}';
option.values = {
                 'f'
                 'v'
                 'd'
                 'fv'
                 'fvd'
}';
% ---------------------------------------------------------------------
% dti_indices Tensor Indices
% ---------------------------------------------------------------------
indices         = cfg_exbranch;
indices.tag     = 'dti_indices';
indices.name    = 'Tensor Indices';
indices.val     = {dtimg option };
indices.help    = {
                       'Compute various invariants of diffusion tensor'
                       ''
                       'Batch processing'
                       'FORMAT res = dti_indices(bch)'
                       '======'
                       '/*\begin{itemize}*/'
                       '/*\item*/ Input argument:'
                       'bch struct containing fields'
                       '/*\begin{description}*/'
                       '/*\item[*/       .dtimg/*]*/  cell array of filenames of DT images'
                       '/*\item[*/       .data/*]*/   Xdim-by-Ydim-by-Zdim-by-6 array of tensors'
                       'Only one of .files and .data need to be given.'
                       '/*\item[*/       .option/*]*/ character array with a combination of'
                       '/*\begin{description}*/'
                       '/*\item[*/               f/*]*/ Fractional Anisotropy'
                       '/*\item[*/               v/*]*/ Variance Anisotropy. In the literature, this is sometimes referred to as relative anisotropy, multiplication by a scaling factor of 1/sqrt(2) yields variance anisotropy.'
                       '/*\item[*/               d/*]*/ Average Diffusivity'
                       '/*\end{description}\end{description}*/'
                       '/*\item*/ Output argument:'
                       'res struct containing fields (if requested)'
                       '/*\begin{description}*/'
                       '/*\item[*/       .fa/*]*/ FA output'
                       '/*\item[*/       .va/*]*/ VA output'
                       '/*\item[*/       .ad/*]*/ AD output'
                       '/*\end{description}*/'
                       'where output is a filename if input is in files and a'
                       'Xdim-by-Ydim-by-Zdim array if input is a data array.'
                       '/*\end{itemize}*/'
                       '/* The algorithms used in this routine are based on \cite{basserNMR95}.*/'
                       ''
                       'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                       'spm_help vgtbx_config_Diffusion'
                       'in the matlab command window after the toolbox has been launched.'
                       '_______________________________________________________________________'
                       ''
                       '@(#) $Id$'
}';
indices.prog = @dti_indices;
indices.vout = @vout_dti_indices;
% ---------------------------------------------------------------------
% limg Eigenvalue Images
% ---------------------------------------------------------------------
limg         = cfg_files;
limg.tag     = 'limg';
limg.name    = 'Eigenvalue Images';
limg.help    = {''};
limg.filter = 'image';
limg.ufilter = '^(eva)?l[1-3].*';
limg.num     = [3 3];
% ---------------------------------------------------------------------
% dti_saliencies Salient Features
% ---------------------------------------------------------------------
saliencies         = cfg_exbranch;
saliencies.tag     = 'dti_saliencies';
saliencies.name    = 'Salient Features';
saliencies.val     = {limg };
saliencies.help    = {
                          'Salient features'
                          ''
                          'Computes salient features (curve-ness, plane-ness and sphere-ness) from eigenvalue data:'
                          '/*\begin{itemize}*/'
                          '/*\item*/    sc*IMAGE curve-ness (l1-l2)/l1'
                          '/*\item*/    sp*IMAGE plane-ness (l2-l3)/l1'
                          '/*\item*/    ss*IMAGE sphere-ness l3/l1'
                          '/*\end{itemize}*/'
                          'These salient features are described in computer vision literature/*\cite{medioni00}*/.'
                          ''
                          'Batch processing'
                          'FORMAT res = dti_saliencies(bch)'
                          '======'
                          '/*\begin{itemize}*/'
                          '/*\item*/ Input argument:'
                          'bch struct containing fields'
                          '/*\begin{description}*/'
                          '/*\item[*/       .limg/*]*/ cell array of image filenames of eigenvalue images'
                          '/*\item[*/       .data/*]*/ alternatively, data as 3-by-xdim-by-ydim-by-zdim array.'
                          '/*\end{description}*/'
                          '/*\item*/ Output arguments:'
                          'res struct with fields .sc, .sp, .ss. These fields contain filenames, if input is from files, otherwise they contain the computed saliency maps.'
                          '/*\end{itemize}*/'
                          'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                          'spm_help vgtbx_config_Diffusion'
                          'in the matlab command window after the toolbox has been launched.'
                          '_______________________________________________________________________'
                          ''
                          '@(#) $Id: dti_saliencies.m 435 2006-03-02 16:35:11Z glauche $'
}';
saliencies.prog = @dti_saliencies;
saliencies.vout = @vout_dti_saliencies;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {'The source images (one or more).'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% option Information to display
% ---------------------------------------------------------------------
option         = cfg_menu;
option.tag     = 'option';
option.name    = 'Information to display';
option.help    = {''};
option.labels = {
                 'Gradient vectors'
                 'Direction distribution'
                 'Both'
}';
option.values = {
                 'v'
                 'd'
                 'vd'
}';
% ---------------------------------------------------------------------
% axbgcol Axis background colour
% ---------------------------------------------------------------------
axbgcol         = cfg_entry;
axbgcol.tag     = 'axbgcol';
axbgcol.name    = 'Axis background colour';
axbgcol.help    = {''};
axbgcol.strtype = 'e';
axbgcol.num     = [1 3];
% ---------------------------------------------------------------------
% fgbgcol Figure background colour
% ---------------------------------------------------------------------
fgbgcol         = cfg_entry;
fgbgcol.tag     = 'fgbgcol';
fgbgcol.name    = 'Figure background colour';
fgbgcol.help    = {''};
fgbgcol.strtype = 'e';
fgbgcol.num     = [1 3];
% ---------------------------------------------------------------------
% res Sphere resolution
% ---------------------------------------------------------------------
res         = cfg_entry;
res.tag     = 'res';
res.name    = 'Sphere resolution';
res.help    = {'Resolution of the unit grid on which the sphere will be created. This grid will have the resolution [-1:res:1] in x,y,z directions.'};
res.strtype = 'e';
res.num     = [1 1];
% ---------------------------------------------------------------------
% dti_disp_grad Display gradient directions
% ---------------------------------------------------------------------
disp_grad         = cfg_exbranch;
disp_grad.tag     = 'dti_disp_grad';
disp_grad.name    = 'Display gradient directions';
disp_grad.val     = {srcimgs option axbgcol fgbgcol res };
disp_grad.help    = {
                         'Visualise gradient direction vectors'
                         ''
                         'Visualise a set of gradient direction vectors. This is useful to compare gradient directions between measurements which may differ due to changes in measurement protocols, motion correction etc.'
                         ''
                         'Batch processing:'
                         'FORMAT res=dti_disp_grad(bch)'
                         '======'
                         '/*\begin{itemize}*/'
                         '/*\item*/ Input argument:'
                         'bch struct with fields'
                         '/*\begin{description}*/'
                         '/*\item[*/       .srcimgs/*]*/ cell array of file names to get diffusion information'
                         '/*\item[*/       .option/*]*/  one or both of /*\begin{description}*/'
                         '/*\item[*/                v/*]*/ displays a vector for each direction, b value is encoded as vector length'
                         '/*\item[*/                d/*]*/ displays direction density colour coded on a unit sphere'
                         '/*\end{description}*/'
                         '/*\item[*/       .axbgcol, .fgbgcol/*]*/ axis and figure background colours'
                         '/*\item[*/       .res/*]*/     sphere resolution'
                         '/*\end{description}*/'
                         '/*\item*/ Output argument:'
                         'res struct with fields'
                         '/*\begin{description}*/'
                         '/*\item[*/       .vf/*]*/  figure handle for vector plot'
                         '/*\item[*/       .vax/*]*/ axis handle for vector plot'
                         '/*\item[*/       .l/*]*/   line handles'
                         '/*\item[*/       .df/*]*/  figure handle for direction plot'
                         '/*\item[*/       .dax/*]*/ axis handle for direction plot'
                         '/*\item[*/       .s/*]*/   surface handle for sphere'
                         '/*\item[*/       .cb/*]*/  handle for colorbar'
                         '/*\end{description}\end{itemize}*/'
                         'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                         'spm_help vgtbx_config_Diffusion'
                         'in the matlab command window after the toolbox has been launched.'
                         '_______________________________________________________________________'
                         ''
                         '@(#) $Id: dti_disp_grad.m 435 2006-03-02 16:35:11Z glauche $'
}';
disp_grad.prog = @dti_disp_grad;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {'The source images (one or more).'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% refimage Image
% ---------------------------------------------------------------------
refimage         = cfg_const;
refimage.tag     = 'refimage';
refimage.name    = 'Image';
refimage.val{1} = double(1);
refimage.help    = {''};
% ---------------------------------------------------------------------
% refscanner Scanner
% ---------------------------------------------------------------------
refscanner         = cfg_const;
refscanner.tag     = 'refscanner';
refscanner.name    = 'Scanner';
refscanner.val{1} = double(1);
refscanner.help    = {''};
% ---------------------------------------------------------------------
% snparams Normalised
% ---------------------------------------------------------------------
snparams         = cfg_files;
snparams.tag     = 'snparams';
snparams.name    = 'Normalised';
snparams.val = {''};
snparams.help    = {'A file containing spatial normalisation parameters. Spatial transformations from normalisation will be read from this file.'};
snparams.filter = 'mat';
snparams.ufilter = '.*sn.*';
snparams.num     = [1 1];
% ---------------------------------------------------------------------
% ref Reference coordinate system
% ---------------------------------------------------------------------
ref         = cfg_choice;
ref.tag     = 'ref';
ref.name    = 'Reference coordinate system';
ref.help    = {''};
ref.values  = {refimage refscanner snparams };
% ---------------------------------------------------------------------
% saveinf Save gradient information to .txt file
% ---------------------------------------------------------------------
saveinf         = cfg_menu;
saveinf.tag     = 'saveinf';
saveinf.name    = 'Save gradient information to .txt file';
saveinf.help    = {''};
saveinf.labels = {
                  'Yes'
                  'No'
}';
saveinf.values{1} = double(1);
saveinf.values{2} = double(0);
% ---------------------------------------------------------------------
% sep Distinguish antiparallel gradient directions
% ---------------------------------------------------------------------
sep         = cfg_menu;
sep.tag     = 'sep';
sep.name    = 'Distinguish antiparallel gradient directions';
sep.help    = {
               'In theory, antiparallel gradient directions should be equivalent when measuring diffusion. However, due to possible scanner effects this might be not true.'
               ''
               'If this entry is set to ''Yes'' then antiparallel gradient directions will be treated as different from each other.'
}';
sep.labels = {
              'Yes'
              'No'
}';
sep.values{1} = double(1);
sep.values{2} = double(0);
% ---------------------------------------------------------------------
% ltol B value tolerance
% ---------------------------------------------------------------------
ltol         = cfg_entry;
ltol.tag     = 'ltol';
ltol.name    = 'B value tolerance';
ltol.help    = {'B values will be divided by this tolerance value and then rounded. Any b values that are still different after rounding, will be treated as different.'};
ltol.strtype = 'e';
ltol.num     = [1 1];
% ---------------------------------------------------------------------
% dtol Gradient direction tolerance
% ---------------------------------------------------------------------
dtol         = cfg_entry;
dtol.tag     = 'dtol';
dtol.name    = 'Gradient direction tolerance';
dtol.help    = {
                'Determines which gradient vectors describe similar directions. Colinearity will be computed as the scalar product between two unit-length gradient vectors.'
                ''
                'Two gradient vectors are treated as similar, if their scalar product is larger than the tolerance value. This means a tolerance value of -1 will treat all directions as similar, whereas a positive value between 0 and 1 will distinguish between different directions.'
}';
dtol.strtype = 'e';
dtol.num     = [1 1];
% ---------------------------------------------------------------------
% dti_extract_dirs Extract DW information (gradients & dirs)
% ---------------------------------------------------------------------
extract_dirs         = cfg_exbranch;
extract_dirs.tag     = 'dti_extract_dirs';
extract_dirs.name    = 'Extract DW information (gradients & dirs)';
extract_dirs.val     = {srcimgs ref saveinf sep ltol dtol };
extract_dirs.help    = {
                            'Batch processing:'
                            'FORMAT res=dti_extract_dirs(bch)'
                            '======'
                            '/*\begin{itemize}*/'
                            '/*\item*/ Input argument:'
                            'bch struct with fields'
                            '/*\begin{description}*/'
                            '/*\item[*/       .srcimgs/*]*/ cell array of file names'
                            '/*\item[*/       .ref/*]*/     A struct with one field of ''image'', ''scanner'' or ''snparams''. Determines the reference system for extracted gradient information. The routine assumes that all images have the same orientation and applies the inverse rotation, zoom and shearing part of the affine transformation of the first image or the normalisation parameters to the gradient directions. If ''snparams'' is given, this needs to be a cellstring containing the name of the sn.mat file.'
                            '/*\item[*/       .saveinf/*]*/ Save extracted b- and g-values to text files? (0 no, 1 yes)'
                            '/*\item[*/       .sep/*]*/     separate antiparallel directions (0 no, 1 yes)'
                            '/*\item[*/       .ltol/*]*/    b value tolerance to treat as identical - set this to the b value rounding error'
                            '/*\item[*/       .dtol/*]*/    cosine between gradient vectors to treat directions as identical'
                            '/*\end{description}*/'
                            '/*\item*/ Output arguments:'
                            'res struct with fields'
                            '/*\begin{description}*/'
                            '/*\item[*/       .dirsel/*]*/ ndir-by-nscan logical array of flags that mark images with similar diffusion weighting - deprecated. One should use the result of unique([res.ubj, res.ugj],''rows'') instead.'
                            '/*\item[*/       .b/*]*/      ndir-by-1 vector of distinct b values for bval/dir combinations /*\item[*/       .g/*]*/      ndir-by-3 array of distinct directions for bval/dir combinations'
                            '/*\item[*/       .ub/*]*/     nb-by-1 vector of distinct b values over all directions'
                            '/*\item[*/       .ug/*]*/     ndir-by-3 array of distinct directions over all bvals'
                            '/*\item[*/       .allb/*]*/   nimg-by-1 vector of all b values'
                            '/*\item[*/       .allg/*]*/   nimg-by-3 array of all directions'
                            '/*\item[*/       .bfile/*]*/  name of text file with b-values'
                            '/*\item[*/       .gfile/*]*/  name of text file with g-values'
                            '/*\end{description}\end{itemize}*/'
                            'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                            'spm_help vgtbx_config_Diffusion'
                            'in the matlab command window after the toolbox has been launched.'
                            '_______________________________________________________________________'
                            ''
                            '@(#) $Id: dti_extract_dirs.m 437 2006-03-06 16:58:32Z glauche $'
}';
extract_dirs.prog = @dti_extract_dirs;
extract_dirs.vout = @vout_dti_extract_dirs;
% ---------------------------------------------------------------------
% dtimg Diffusion Tensor Images
% ---------------------------------------------------------------------
dtimg         = cfg_files;
dtimg.tag     = 'dtimg';
dtimg.name    = 'Diffusion Tensor Images';
dtimg.help    = {'Select images containing diffusion tensor data. If they are not computed using this toolbox, they need to be named according to the naming conventions of the toolbox or have at least an similar alphabetical order.'};
dtimg.filter = 'image';
dtimg.ufilter = '^D([x-z][x-z])*_.*';
dtimg.num     = [6 Inf];
% ---------------------------------------------------------------------
% dtorder Tensor order
% ---------------------------------------------------------------------
dtorder         = cfg_entry;
dtorder.tag     = 'dtorder';
dtorder.name    = 'Tensor order';
dtorder.help    = {'Enter an even number (default 2). This determines the order of your diffusion tensors. Higher order tensors can be estimated only from data with many different diffusion weighting directions. See the referenced literature/*\cite{Orszalan2003}*/ for details.'};
dtorder.strtype = 'n';
dtorder.num     = [1 1];
% ---------------------------------------------------------------------
% dti_hosvd Higher Order SVD
% ---------------------------------------------------------------------
dtihosvd         = cfg_exbranch;
dtihosvd.tag     = 'dti_hosvd';
dtihosvd.name    = 'Higher Order SVD';
dtihosvd.val     = {dtimg dtorder };
dtihosvd.help    = {
                     'Compute SVD for higher order tensors'
                     ''
                     'Batch processing'
                     'FORMAT res = dti_hosvd(bch)'
                     '======'
                     '/*\begin{itemize}*/'
                     '/*\item*/ Input argument:'
                     'bch struct with fields'
                     '/*\begin{description}*/'
                     '/*\item[*/       .data/*]*/    tensor elements in alphabetical index order (if data is given, then no files will be read or written)'
                     '/*\item[*/       .dtimg/*]*/   cell array with file names of images'
                     '/*\item[*/       .dtorder/*]*/ tensor order'
                     '/*\end{description}*/'
                     '/*\item*/ Output argument:'
                     'res  struct with fields'
                     '/*\begin{description}*/'
                     '/*\item[*/        .S/*]*/ singular tensor (elements in alphabetical index order)'
                     '/*\item[*/        .U/*]*/ cell array of singular matrices'
                     '/*\end{description}\end{itemize}*/'
                     'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                     'spm_help vgtbx_config_Diffusion'
                     'in the matlab command window after the toolbox has been launched.'
                     '_______________________________________________________________________'
                     ''
                     '@(#) $Id: dti_hosvd.m 435 2006-03-02 16:35:11Z glauche $'
}';
dtihosvd.prog = @dti_hosvd;
dtihosvd.vout = @vout_dti_hosvd;
% ---------------------------------------------------------------------
% srcspm Source SPM.mat
% ---------------------------------------------------------------------
srcspm         = cfg_files;
srcspm.tag     = 'srcspm';
srcspm.name    = 'Source SPM.mat';
srcspm.help    = {'Select SPM.mat from a previous analysis step.'};
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num     = [1 1];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% dti_recalc Compute filtered/adjusted DW Images from Regression Model
% ---------------------------------------------------------------------
recalc         = cfg_exbranch;
recalc.tag     = 'dti_recalc';
recalc.name    = 'Compute filtered/adjusted DW Images from Regression Model';
recalc.val     = {srcspm prefix };
recalc.help    = {
                      'recalculate DTI input Data from given tensor and b-matrix data (i.e. adjusted data).'
                      ''
                      'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                      'spm_help vgtbx_config_Diffusion'
                      'in the matlab command window after the toolbox has been launched.'
                      '_______________________________________________________________________'
                      ''
                      '@(#) $Id$'
}';
recalc.prog = @dti_recalc;
% ---------------------------------------------------------------------
% data Coordinate points
% ---------------------------------------------------------------------
data         = cfg_entry;
data.tag     = 'data';
data.name    = 'Coordinate points';
data.help    = {'A #lines-by-size(t,2) array of data points.'};
data.strtype = 'e';
data.num     = [Inf Inf];
% ---------------------------------------------------------------------
% a Line slope
% ---------------------------------------------------------------------
a         = cfg_entry;
a.tag     = 'a';
a.name    = 'Line slope';
a.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
a.strtype = 'e';
a.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% linear Linear: f(t) = a*t + off
% ---------------------------------------------------------------------
linear         = cfg_branch;
linear.tag     = 'linear';
linear.name    = 'Linear: f(t) = a*t + off';
linear.val     = {a off };
linear.help    = {''};
% ---------------------------------------------------------------------
% r Amplitude
% ---------------------------------------------------------------------
r         = cfg_entry;
r.tag     = 'r';
r.name    = 'Amplitude';
r.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
r.strtype = 'e';
r.num     = [Inf Inf];
% ---------------------------------------------------------------------
% f Frequency
% ---------------------------------------------------------------------
f         = cfg_entry;
f.tag     = 'f';
f.name    = 'Frequency';
f.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
f.strtype = 'e';
f.num     = [Inf Inf];
% ---------------------------------------------------------------------
% ph Phase
% ---------------------------------------------------------------------
ph         = cfg_entry;
ph.tag     = 'ph';
ph.name    = 'Phase';
ph.help    = {
              'The interpretation of this parameter varies with its size. It can be'
              '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
              'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
ph.strtype = 'e';
ph.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% tanhp Tanh: f(t) = tanh(f*t + ph) + off
% ---------------------------------------------------------------------
tanhp         = cfg_branch;
tanhp.tag     = 'tanhp';
tanhp.name    = 'Tanh: f(t) = tanh(f*t + ph) + off';
tanhp.val     = {r f ph off };
tanhp.help    = {''};
% ---------------------------------------------------------------------
% r Amplitude
% ---------------------------------------------------------------------
r         = cfg_entry;
r.tag     = 'r';
r.name    = 'Amplitude';
r.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
r.strtype = 'e';
r.num     = [Inf Inf];
% ---------------------------------------------------------------------
% f Frequency
% ---------------------------------------------------------------------
f         = cfg_entry;
f.tag     = 'f';
f.name    = 'Frequency';
f.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
f.strtype = 'e';
f.num     = [Inf Inf];
% ---------------------------------------------------------------------
% ph Phase
% ---------------------------------------------------------------------
ph         = cfg_entry;
ph.tag     = 'ph';
ph.name    = 'Phase';
ph.help    = {
              'The interpretation of this parameter varies with its size. It can be'
              '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
              'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
ph.strtype = 'e';
ph.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% sinp Sin: f(t) = sin(f*t + ph) + off
% ---------------------------------------------------------------------
sinp         = cfg_branch;
sinp.tag     = 'sinp';
sinp.name    = 'Sin: f(t) = sin(f*t + ph) + off';
sinp.val     = {r f ph off };
sinp.help    = {''};
% ---------------------------------------------------------------------
% fxfun Line function (X)
% ---------------------------------------------------------------------
fxfun         = cfg_choice;
fxfun.tag     = 'fxfun';
fxfun.name    = 'Line function (X)';
fxfun.help    = {'Specification of fibers. Each fiber is parameterised by three functions x(t), y(t) and z(t). All combinations of x-, y- and z-line functions are computed.'};
fxfun.values  = {data linear tanhp sinp };
% ---------------------------------------------------------------------
% data Coordinate points
% ---------------------------------------------------------------------
data         = cfg_entry;
data.tag     = 'data';
data.name    = 'Coordinate points';
data.help    = {'A #lines-by-size(t,2) array of data points.'};
data.strtype = 'e';
data.num     = [Inf Inf];
% ---------------------------------------------------------------------
% a Line slope
% ---------------------------------------------------------------------
a         = cfg_entry;
a.tag     = 'a';
a.name    = 'Line slope';
a.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
a.strtype = 'e';
a.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% linear Linear: f(t) = a*t + off
% ---------------------------------------------------------------------
linear         = cfg_branch;
linear.tag     = 'linear';
linear.name    = 'Linear: f(t) = a*t + off';
linear.val     = {a off };
linear.help    = {''};
% ---------------------------------------------------------------------
% r Amplitude
% ---------------------------------------------------------------------
r         = cfg_entry;
r.tag     = 'r';
r.name    = 'Amplitude';
r.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
r.strtype = 'e';
r.num     = [Inf Inf];
% ---------------------------------------------------------------------
% f Frequency
% ---------------------------------------------------------------------
f         = cfg_entry;
f.tag     = 'f';
f.name    = 'Frequency';
f.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
f.strtype = 'e';
f.num     = [Inf Inf];
% ---------------------------------------------------------------------
% ph Phase
% ---------------------------------------------------------------------
ph         = cfg_entry;
ph.tag     = 'ph';
ph.name    = 'Phase';
ph.help    = {
              'The interpretation of this parameter varies with its size. It can be'
              '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
              'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
ph.strtype = 'e';
ph.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% tanhp Tanh: f(t) = tanh(f*t + ph) + off
% ---------------------------------------------------------------------
tanhp         = cfg_branch;
tanhp.tag     = 'tanhp';
tanhp.name    = 'Tanh: f(t) = tanh(f*t + ph) + off';
tanhp.val     = {r f ph off };
tanhp.help    = {''};
% ---------------------------------------------------------------------
% r Amplitude
% ---------------------------------------------------------------------
r         = cfg_entry;
r.tag     = 'r';
r.name    = 'Amplitude';
r.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
r.strtype = 'e';
r.num     = [Inf Inf];
% ---------------------------------------------------------------------
% f Frequency
% ---------------------------------------------------------------------
f         = cfg_entry;
f.tag     = 'f';
f.name    = 'Frequency';
f.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
f.strtype = 'e';
f.num     = [Inf Inf];
% ---------------------------------------------------------------------
% ph Phase
% ---------------------------------------------------------------------
ph         = cfg_entry;
ph.tag     = 'ph';
ph.name    = 'Phase';
ph.help    = {
              'The interpretation of this parameter varies with its size. It can be'
              '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
              'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
ph.strtype = 'e';
ph.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% sinp Sin: f(t) = sin(f*t + ph) + off
% ---------------------------------------------------------------------
sinp         = cfg_branch;
sinp.tag     = 'sinp';
sinp.name    = 'Sin: f(t) = sin(f*t + ph) + off';
sinp.val     = {r f ph off };
sinp.help    = {''};
% ---------------------------------------------------------------------
% fyfun Line function (Y)
% ---------------------------------------------------------------------
fyfun         = cfg_choice;
fyfun.tag     = 'fyfun';
fyfun.name    = 'Line function (Y)';
fyfun.help    = {'Specification of fibers. Each fiber is parameterised by three functions x(t), y(t) and z(t). All combinations of x-, y- and z-line functions are computed.'};
fyfun.values  = {data linear tanhp sinp };
% ---------------------------------------------------------------------
% data Coordinate points
% ---------------------------------------------------------------------
data         = cfg_entry;
data.tag     = 'data';
data.name    = 'Coordinate points';
data.help    = {'A #lines-by-size(t,2) array of data points.'};
data.strtype = 'e';
data.num     = [Inf Inf];
% ---------------------------------------------------------------------
% a Line slope
% ---------------------------------------------------------------------
a         = cfg_entry;
a.tag     = 'a';
a.name    = 'Line slope';
a.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
a.strtype = 'e';
a.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% linear Linear: f(t) = a*t + off
% ---------------------------------------------------------------------
linear         = cfg_branch;
linear.tag     = 'linear';
linear.name    = 'Linear: f(t) = a*t + off';
linear.val     = {a off };
linear.help    = {''};
% ---------------------------------------------------------------------
% r Amplitude
% ---------------------------------------------------------------------
r         = cfg_entry;
r.tag     = 'r';
r.name    = 'Amplitude';
r.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
r.strtype = 'e';
r.num     = [Inf Inf];
% ---------------------------------------------------------------------
% f Frequency
% ---------------------------------------------------------------------
f         = cfg_entry;
f.tag     = 'f';
f.name    = 'Frequency';
f.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
f.strtype = 'e';
f.num     = [Inf Inf];
% ---------------------------------------------------------------------
% ph Phase
% ---------------------------------------------------------------------
ph         = cfg_entry;
ph.tag     = 'ph';
ph.name    = 'Phase';
ph.help    = {
              'The interpretation of this parameter varies with its size. It can be'
              '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
              'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
ph.strtype = 'e';
ph.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% tanhp Tanh: f(t) = tanh(f*t + ph) + off
% ---------------------------------------------------------------------
tanhp         = cfg_branch;
tanhp.tag     = 'tanhp';
tanhp.name    = 'Tanh: f(t) = tanh(f*t + ph) + off';
tanhp.val     = {r f ph off };
tanhp.help    = {''};
% ---------------------------------------------------------------------
% r Amplitude
% ---------------------------------------------------------------------
r         = cfg_entry;
r.tag     = 'r';
r.name    = 'Amplitude';
r.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
r.strtype = 'e';
r.num     = [Inf Inf];
% ---------------------------------------------------------------------
% f Frequency
% ---------------------------------------------------------------------
f         = cfg_entry;
f.tag     = 'f';
f.name    = 'Frequency';
f.help    = {
             'The interpretation of this parameter varies with its size. It can be'
             '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
             'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
f.strtype = 'e';
f.num     = [Inf Inf];
% ---------------------------------------------------------------------
% ph Phase
% ---------------------------------------------------------------------
ph         = cfg_entry;
ph.tag     = 'ph';
ph.name    = 'Phase';
ph.help    = {
              'The interpretation of this parameter varies with its size. It can be'
              '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
              'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
ph.strtype = 'e';
ph.num     = [Inf Inf];
% ---------------------------------------------------------------------
% off Offset
% ---------------------------------------------------------------------
off         = cfg_entry;
off.tag     = 'off';
off.name    = 'Offset';
off.help    = {
               'The interpretation of this parameter varies with its size. It can be'
               '1-by-1, 1-by-size(t,2): one line, with possibly changing parameter value over the line.'
               'M-by-1, M-by-size(t,2): multiple lines with different settings of this parameter. All combinations of all parameters of the line function will be computed.'
}';
off.strtype = 'e';
off.num     = [Inf Inf];
% ---------------------------------------------------------------------
% sinp Sin: f(t) = sin(f*t + ph) + off
% ---------------------------------------------------------------------
sinp         = cfg_branch;
sinp.tag     = 'sinp';
sinp.name    = 'Sin: f(t) = sin(f*t + ph) + off';
sinp.val     = {r f ph off };
sinp.help    = {''};
% ---------------------------------------------------------------------
% fzfun Line function (Z)
% ---------------------------------------------------------------------
fzfun         = cfg_choice;
fzfun.tag     = 'fzfun';
fzfun.name    = 'Line function (Z)';
fzfun.help    = {'Specification of fibers. Each fiber is parameterised by three functions x(t), y(t) and z(t). All combinations of x-, y- and z-line functions are computed.'};
fzfun.values  = {data linear tanhp sinp };
% ---------------------------------------------------------------------
% t Parametrisation points for line
% ---------------------------------------------------------------------
t         = cfg_entry;
t.tag     = 't';
t.name    = 'Parametrisation points for line';
t.help    = {''};
t.strtype = 'e';
t.num     = [1 Inf];
% ---------------------------------------------------------------------
% iso Ratio of isotropic diffusion
% ---------------------------------------------------------------------
iso         = cfg_entry;
iso.tag     = 'iso';
iso.name    = 'Ratio of isotropic diffusion';
iso.help    = {''};
iso.strtype = 'e';
iso.num     = [1 1];
% ---------------------------------------------------------------------
% fwhm Exponential decay of non-isotropic diffusion
% ---------------------------------------------------------------------
fwhm         = cfg_entry;
fwhm.tag     = 'fwhm';
fwhm.name    = 'Exponential decay of non-isotropic diffusion';
fwhm.help    = {''};
fwhm.strtype = 'e';
fwhm.num     = [1 1];
% ---------------------------------------------------------------------
% D Diffusion coefficient
% ---------------------------------------------------------------------
D         = cfg_entry;
D.tag     = 'D';
D.name    = 'Diffusion coefficient';
D.help    = {''};
D.strtype = 'e';
D.num     = [1 1];
% ---------------------------------------------------------------------
% lines Line specification
% ---------------------------------------------------------------------
lines         = cfg_branch;
lines.tag     = 'lines';
lines.name    = 'Line specification';
lines.val     = {fxfun fyfun fzfun t iso fwhm D };
lines.help    = {''};
% ---------------------------------------------------------------------
% alllines Line specifications
% ---------------------------------------------------------------------
alllines         = cfg_repeat;
alllines.tag     = 'alllines';
alllines.name    = 'Line specifications';
alllines.help    = {''};
alllines.values  = {lines };
alllines.num     = [1 Inf];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% swd Output directory
% ---------------------------------------------------------------------
swd         = cfg_files;
swd.tag     = 'swd';
swd.name    = 'Output directory';
swd.help    = {'Files produced by this function will be written into this output directory'};
swd.filter = 'dir';
swd.ufilter = '.*';
swd.num     = [1 1];
% ---------------------------------------------------------------------
% dim Output image dimensions
% ---------------------------------------------------------------------
dim         = cfg_entry;
dim.tag     = 'dim';
dim.name    = 'Output image dimensions';
dim.help    = {''};
dim.strtype = 'r';
dim.num     = [2 3];
% ---------------------------------------------------------------------
% res Sphere resolution
% ---------------------------------------------------------------------
res         = cfg_entry;
res.tag     = 'res';
res.name    = 'Sphere resolution';
res.help    = {'Resolution of the unit grid on which the sphere will be created. This grid will have the resolution [-1:res:1] in x,y,z directions.'};
res.strtype = 'e';
res.num     = [1 1];
% ---------------------------------------------------------------------
% movprms Movement parameters
% ---------------------------------------------------------------------
movprms         = cfg_entry;
movprms.tag     = 'movprms';
movprms.name    = 'Movement parameters';
movprms.help    = {'Enter a 1-by-6 or #directions-by-6 array of movement parameters to simulate phantom movement. Images will be simulated in transversal orientation, but the phantom may move in and out the initial bounding box.'};
movprms.strtype = 'e';
movprms.num     = [Inf 6];
% ---------------------------------------------------------------------
% b B value
% ---------------------------------------------------------------------
b         = cfg_entry;
b.tag     = 'b';
b.name    = 'B value';
b.help    = {'A vector of b values (one number per image). The actual b value used in tensor computation will depend on this value, multiplied with the length of the corresponding gradient vector.'};
b.strtype = 'e';
b.num     = [1 1];
% ---------------------------------------------------------------------
% i0 B0 intensity
% ---------------------------------------------------------------------
i0         = cfg_entry;
i0.tag     = 'i0';
i0.name    = 'B0 intensity';
i0.help    = {''};
i0.strtype = 'e';
i0.num     = [1 1];
% ---------------------------------------------------------------------
% nr B0 noise ratio
% ---------------------------------------------------------------------
nr         = cfg_entry;
nr.tag     = 'nr';
nr.name    = 'B0 noise ratio';
nr.help    = {''};
nr.strtype = 'e';
nr.num     = [1 1];
% ---------------------------------------------------------------------
% dti_dw_generate Generate diffusion weighted images
% ---------------------------------------------------------------------
dw_generate         = cfg_exbranch;
dw_generate.tag     = 'dti_dw_generate';
dw_generate.name    = 'Generate diffusion weighted images';
dw_generate.val     = {alllines prefix swd dim res movprms b i0 nr };
dw_generate.help    = {
                           'generate simulated diffusion weighted data'
                           ''
                           'Batch processing:'
                           'FORMAT function dti_dw_generate(bch)'
                           '======'
                           'Input argument:'
                           'bch struct with fields'
                           '/*\begin{description}*/'
                           '/*\item[*/     .dim/*]*/    [Inf Inf Inf] or [xdim ydim zdim] dimension of output images'
                           '/*\item[*/     .res/*]*/    sphere resolution (determines number of evaluated diffusion directions)'
                           '/*\item[*/     .b/*]*/      b Value'
                           '/*\item[*/     .i0/*]*/     Intensity of b0 image'
                           '/*\item[*/     .lines/*]*/  lines substructures'
                           '/*\item[*/     .prefix/*]*/ filename stub'
                           '/*\item[*/     .swd/*]*/    working directory'
                           '/*\end{description}*/'
                           'lines substructure'
                           '/*\begin{description}*/'
                           '/*\item[*/       .t/*]*/    1xN evaluation points for line functions, defaults to [1:10]'
                           '/*\item[*/       .fxfun, .fyfun, .fzfun/*]*/ function specifications'
                           '/*\item[*/       .iso/*]*/  ratio of isotropic diffusion (0 no isotropic diffusion, 1 no directional dependence)'
                           '/*\item[*/       .fwhm/*]*/ exponential weight for non-isotropic diffusion (0 no weighting, +Inf only signal along line)'
                           '/*\end{description}*/'
                           'This function generates fibres according to the specifications given in its input argument. Each specification describes a line in 3-D space, parameterised by lines.t.'
                           ''
                           'fxfun, fyfun and fzfun can be the following functions that take as input a parameter t and an struct array with additional parameters:'
                           '''linear'''
                           'ret=a*t + off;'
                           '''tanhp'''
                           'ret=r*tanh(f*t+ph) + off;'
                           '''sinp'''
                           'ret=r*sin(f*t+ph) + off;'
                           '''cosp'''
                           'ret=r*cos(f*t+ph) + off;'
                           ''
                           'fxfun, fyfun, fzfun can alternatively be specified directly as arrays fxfun(t), fyfun(t), fzfun(t) of size nlines-by-numel(t). In that case, no evaluation of fxprm, fyprm, fzprm takes place. It is checked, that the length of each array line matches the length of lines.t.'
                           'All parameters can be specified as 1x1, Mx1, 1xN, or MxN, where N must'
                           'match the number of evaluation points in t. A line will be derived for'
                           'each combination of parameters.'
                           'At each grid point (rounded x(t),y(t),z(t)) the 1st derivative of the line function (i.e. line direction) is computed. The diffusion gradient directions are assumed to lie on a sphere produced by Matlab''s isosurface command. The sphere is evaluated on a grid [-1:bch.res:1].'
                           'The diffusivity profile of each line is assumed to depend only on the angle between line direction and current diffusion gradient direction. When multiple lines are running through the same voxel, diffusivities will be averaged.'
                           'A set of diffusion weighted images will be written to disk consisting of a b0 image and one image for each diffusion gradient direction. These images can then be used as input to the tensor estimation routines. If finite dimensions for the images are given, lines will be clipped to fit into the image. Otherwise, the maximum dimensions are determined by the maximum line coordinates.'
                           ''
                           'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                           'spm_help vgtbx_config_Diffusion'
                           'in the matlab command window after the toolbox has been launched.'
                           '_______________________________________________________________________'
                           ''
                           '@(#) $Id: dti_dw_generate.m 541 2007-12-31 06:58:36Z glauche $'
}';
dw_generate.prog = @dti_dw_generate;
dw_generate.vout = @vout_dti_dw_generate;
% ---------------------------------------------------------------------
% dtimg Diffusion Tensor Images
% ---------------------------------------------------------------------
dtimg         = cfg_files;
dtimg.tag     = 'dtimg';
dtimg.name    = 'Diffusion Tensor Images';
dtimg.help    = {'Select images containing diffusion tensor data. If they are not computed using this toolbox, they need to be named according to the naming conventions of the toolbox or have at least an similar alphabetical order.'};
dtimg.filter = 'image';
dtimg.ufilter = '^D([x-z][x-z])*_.*';
dtimg.num     = [6 Inf];
% ---------------------------------------------------------------------
% dtorder Tensor order
% ---------------------------------------------------------------------
dtorder         = cfg_entry;
dtorder.tag     = 'dtorder';
dtorder.name    = 'Tensor order';
dtorder.help    = {'Enter an even number (default 2). This determines the order of your diffusion tensors. Higher order tensors can be estimated only from data with many different diffusion weighting directions. See the referenced literature/*\cite{Orszalan2003}*/ for details.'};
dtorder.strtype = 'n';
dtorder.num     = [1 1];
% ---------------------------------------------------------------------
% maskimg Mask Image
% ---------------------------------------------------------------------
maskimg         = cfg_files;
maskimg.tag     = 'maskimg';
maskimg.name    = 'Mask Image';
maskimg.help    = {'Specify an image for masking your data. Only voxels where this image has non-zero intensity will be processed.'};
maskimg.filter = 'image';
maskimg.ufilter = '.*';
maskimg.num     = [1 1];
% ---------------------------------------------------------------------
% sroi Starting ROI
% ---------------------------------------------------------------------
sroi         = cfg_files;
sroi.tag     = 'sroi';
sroi.name    = 'Starting ROI';
sroi.help    = {'Specify starting region.'};
sroi.filter = 'image';
sroi.ufilter = '.*';
sroi.num     = [1 1];
% ---------------------------------------------------------------------
% eroi Target ROI (optional)
% ---------------------------------------------------------------------
eroi         = cfg_files;
eroi.tag     = 'eroi';
eroi.name    = 'Target ROI (optional)';
eroi.help    = {'Specify target region (optional). Tracking will stop when all voxels within a target region have been reached or the specified fraction of all voxels has been visited.'};
eroi.filter = 'image';
eroi.ufilter = '.*';
eroi.num     = [0 1];
% ---------------------------------------------------------------------
% resfile Results filename generation
% ---------------------------------------------------------------------
resfile         = cfg_menu;
resfile.tag     = 'resfile';
resfile.name    = 'Results filename generation';
resfile.help    = {''};
resfile.labels = {
                  'From Tensor'
                  'From Start ROI'
                  'From End ROI'
}';
resfile.values = {
                  't'
                  's'
                  'e'
}';
% ---------------------------------------------------------------------
% swd Output directory
% ---------------------------------------------------------------------
swd         = cfg_files;
swd.tag     = 'swd';
swd.name    = 'Output directory';
swd.help    = {'Files produced by this function will be written into this output directory'};
swd.filter = 'dir';
swd.ufilter = '.*';
swd.num     = [1 1];
% ---------------------------------------------------------------------
% frac Fraction of voxels to be visited
% ---------------------------------------------------------------------
frac         = cfg_entry;
frac.tag     = 'frac';
frac.name    = 'Fraction of voxels to be visited';
frac.help    = {'Fraction of voxels to be visited before stopping.'};
frac.strtype = 'e';
frac.num     = [1 1];
% ---------------------------------------------------------------------
% nb Neighbourhood
% ---------------------------------------------------------------------
nb         = cfg_menu;
nb.tag     = 'nb';
nb.name    = 'Neighbourhood';
nb.help    = {''};
nb.labels = {
             '6 Neighbours'
             '18 Neighbours'
             '26 Neighbours'
}';
nb.values{1} = double(6);
nb.values{2} = double(18);
nb.values{3} = double(26);
% ---------------------------------------------------------------------
% exp Exponential for tensor
% ---------------------------------------------------------------------
exp         = cfg_entry;
exp.tag     = 'exp';
exp.name    = 'Exponential for tensor';
exp.help    = {''};
exp.strtype = 'n';
exp.num     = [1 1];
% ---------------------------------------------------------------------
% dti_dt_time3 Tracking - Computation of Arrival time
% ---------------------------------------------------------------------
dt_time3         = cfg_exbranch;
dt_time3.tag     = 'dti_dt_time3';
dt_time3.name    = 'Tracking - Computation of Arrival time';
dt_time3.val     = {dtimg dtorder maskimg sroi eroi resfile swd frac nb exp };
dt_time3.help    = {
                        'Compute time of arrival map for diffusion data'
                        ''
                        'A level set algorithm is used to compute time of arrival maps. Starting with a start region, diffusion is simulated by evaluating the diffusivity profile at each voxel of a propagating front. The profile is computed efficiently from arbitrary order tensors.'
                        ''
                        'References:'
                        '[Set96]      Sethian, James A. A Fast Marching Level Set Method for Monotonically Advancing Fronts. Proceedings of the National Academy of Sciences, USA, 93(4):1591 -- 1595, 1996.'
                        '[?M03]       ?rszalan, Evren and Thomas H Mareci. Generalized Diffusion Tensor Imaging and Analytical Relationships Between Diffusion Tensor Imaging and High Angular Resolution Diffusion Imaging. Magnetic Resonance in Medicine, 50:955--965, 2003.'
                        ''
                        'Batch processing:'
                        'FORMAT dti_dt_time3(bch)'
                        '======'
                        'Input argument:'
                        'bch - struct with batch descriptions, containing the following fields:'
                        '.order  - tensor order'
                        '.files - cell array of tensor image filenames'
                        '.mask  - image mask'
                        '.sroi  - starting ROI'
                        '.eroi  - end ROI (optional)'
                        '.frac  - maximum fraction of voxels that should be visited (range 0-1)'
                        '.resfile - results filename stub'
                        '.nb    - neighbourhood (one of 6, 18, 26)'
                        '.exp   - Exponential for tensor elements (should be an odd integer)'
                        ''
                        'This function is part of the diffusion toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                        'spm_help vgtbx_config_Diffusion'
                        'in the matlab command window after the toolbox has been launched.'
                        '_______________________________________________________________________'
                        ''
                        '@(#) $Id: dti_dt_time3.m 543 2008-03-12 19:40:40Z glauche $'
}';
dt_time3.prog = @dti_dt_time3;
dt_time3.vout = @vout_dti_dt_time3;
% ---------------------------------------------------------------------
% sroi Starting ROI
% ---------------------------------------------------------------------
sroi         = cfg_files;
sroi.tag     = 'sroi';
sroi.name    = 'Starting ROI';
sroi.help    = {'Specify starting region.'};
sroi.filter = 'image';
sroi.ufilter = '.*';
sroi.num     = [1 1];
% ---------------------------------------------------------------------
% trace Trace Image
% ---------------------------------------------------------------------
trace         = cfg_files;
trace.tag     = 'trace';
trace.name    = 'Trace Image';
trace.help    = {'Specify trace image.'};
trace.filter = 'image';
trace.ufilter = '.*';
trace.num     = [1 1];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'p'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% dti_tracepath Tracking - Backtracing Paths
% ---------------------------------------------------------------------
tracepath         = cfg_exbranch;
tracepath.tag     = 'dti_tracepath';
tracepath.name    = 'Tracking - Backtracing Paths';
tracepath.val     = {sroi trace prefix };
tracepath.help    = {
                         'Backtrace path to starting ROI'
                         ''
                         'This routine computes a path from a region of interest back to the'
                         'source of tracking from dti_dt_time3. The region of interest may'
                         'contain multiple voxels, which need not be connected.'
                         ''
                         'FORMAT [res bchdone]=dti_tracepath(bch)'
                         '======'
                         'Input argument:'
                         'bch - struct array with batch descriptions, containing the following'
                         'fields:'
                         '.sroi    - starting ROI (image filename or 3D array)'
                         '.trace   - trace (image filename or 3D array)'
                         '.prefix  - output image prefix'
                         'Output arguments:'
                         'res     - results structure'
                         'bchdone - filled batch structure'
                         'Output filename will be constructed by prefixing trace filename with a'
                         'customisable prefix. If trace is a 3D array, then sroi filename will be'
                         'tried instead. The filename will be returned in res.path. If both sroi'
                         'and trace are 3D arrays or bch.prefix is empty, res.path will be a 3D'
                         'array containing the traced paths.'
                         ''
                         'This function is part of the diffusion toolbox for SPM5. For general help'
                         'about this toolbox, bug reports, licensing etc. type'
                         'spm_help vgtbx_config_Diffusion'
                         'in the matlab command window after the toolbox has been launched.'
}';
tracepath.prog = @dti_tracepath;
%tracepath.vout = @vout_dti_tracepath;
% ---------------------------------------------------------------------
% vgtbx_Diffusion Diffusion toolbox
% ---------------------------------------------------------------------
vgtbx_Diffusion         = cfg_choice;
vgtbx_Diffusion.tag     = 'vgtbx_Diffusion';
vgtbx_Diffusion.name    = 'Diffusion toolbox';
vgtbx_Diffusion.help    = {
                           'Diffusion toolbox'
                           '_______________________________________________________________________'
                           ''
                           'This toolbox contains various functions related to post-processing of diffusion weighted image series in SPM. Topics include movement correction for image time series, estimation of the diffusion tensor, computation of anisotropy indices and tensor decomposition. Visualisation of diffusion tensor data (quiver & red-green-blue plots of eigenvector data) is not included in this toolbox, but there are separate plugins for spm_orthviews available for download at the same place as the source code of this toolbox.'
                           ''
                           'The algorithms applied in this toolbox are referenced within the PDF help texts of the functions where they are implemented.'
                           ''
                           'This toolbox is free but copyright software, distributed under the terms of the GNU General Public Licence as published by the Free Software Foundation (either version 2, as given in file spm_LICENCE.man, or at your option, any later version). Further details on "copyleft" can be found at http://www.gnu.org/copyleft/.'
                           'The toolbox consists of the files listed in its Contents.m file.'
                           ''
                           'The source code of this toolbox is available at'
                           ''
                           'http://sourceforge.net/projects/spmtools'
                           ''
                           'Please use the SourceForge forum and tracker system for comments, suggestions, bug reports etc. regarding this toolbox.'
                           '_______________________________________________________________________'
                           ''
                           '@(#) $Id: vgtbx_config_Diffusion.m 543 2008-03-12 19:40:40Z glauche $'
}';
vgtbx_Diffusion.values  = {init_dtidata dw_wmean_variance dw_cluster_std_differences dw_wmean_review ...
                    realign reorient_gradient adc dt_adc dt_regress warp_tensors dtieig indices saliencies disp_grad extract_dirs dtihosvd recalc dw_generate dt_time3 tracepath tbxdti_cfg_favbs_norm};

% vfiles functions
%=======================================================================

% Note: if isfield(bch,'data') switches are currently not functional -
% this would e.g. require a cfg_choice bch.input to work.

function dep = vout_dti_init_dtidata(job)
dep = cfg_dep;
dep.sname = '(Re)Initialised DW Images';
dep.src_output = substruct('.','files');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function dep = vout_dti_adc(job)
dep = cfg_dep;
dep.sname = 'ADC Images';
dep.src_output = substruct('.','adc');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function dep = vfiles_dti_dt_adc(job)
dep = cfg_dep;
dep.sname = 'Tensor Images';
dep.src_output = substruct('.','dt');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function dep = vout_dti_realign(job)
dep = cfg_dep;
dep.sname = 'Realigned DW Images';
dep.src_output = substruct('.','files');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function dep = vout_dti_reorient_gradient(job)
dep = cfg_dep;
dep.sname = 'Images with Reoriented Gradients';
dep.src_output = substruct('.','tgtimgs');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function dep = vout_dti_dt_regress(job)
dep(1) = cfg_dep;
dep(1).sname = 'Tensor Images';
dep(1).src_output = substruct('.','dt');
dep(1).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep(2) = cfg_dep;
dep(2).sname = 'Ln(A0) Image';
dep(2).src_output = substruct('.','ln');
dep(2).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep(3) = cfg_dep;
dep(3).sname = 'SPM.mat (Tensor estimation)';
dep(3).src_output = substruct('.','spmmat');
dep(3).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});

function dep = vout_dti_eig(job)
if ~ischar(job.dteigopts) || strcmpi(job.dteigopts,'<undefined>')
    dep = cfg_dep;
    dep = dep(false);
else
    if isfield(job, 'data')
        tgt_spec = cfg_findspec({{'strtype','r'}});
    else
        tgt_spec = cfg_findspec({{'filter','image','strtype','e'}});
    end;
    vdep = [];
    ldep = [];
    adep = [];
    if any (job.dteigopts=='v')
        vdep = cfg_dep;
        vdep.sname = 'Eigenvectors';
        vdep.src_output = substruct('.','evec');
        vdep.tgt_spec = tgt_spec;
    end;
    if any(job.dteigopts=='l')
        ldep = cfg_dep;
        ldep.sname = 'Eigenvalues';
        ldep.src_output = substruct('.','eval');
        ldep.tgt_spec = tgt_spec;
    end;
    if any(job.dteigopts=='a')
        adep = cfg_dep;
        adep.sname = 'Euler Angles';
        adep.src_output = substruct('.','euler');
        adep.tgt_spec = tgt_spec;
    end;
    dep = [vdep ldep adep];
end;

function dep = vout_dti_indices(job)
if ~ischar(job.option) || strcmpi(job.option,'<undefined>')
    dep = cfg_dep;
    dep = dep(false);
else
    if isfield(job, 'data')
        tgt_spec = cfg_findspec({{'strtype','r'}});
    else
        tgt_spec = cfg_findspec({{'filter','image','strtype','e'}});
    end;
    fdep = [];
    vdep = [];
    ddep = [];
    if any (job.option=='f')
        fdep = cfg_dep;
        fdep.sname = 'FA Data';
        fdep.src_output = substruct('.','fa');
        fdep.tgt_spec   = tgt_spec;
    end;
    if any (job.option=='v')
        vdep = cfg_dep;
        vdep.sname = 'VA Data';
        vdep.src_output = substruct('.','va');
        vdep.tgt_spec   = tgt_spec;
    end;
    if any (job.option=='d')
        ddep = cfg_dep;
        ddep.sname = 'AD Data';
        ddep.src_output = substruct('.','ad');
        ddep.tgt_spec   = tgt_spec;
    end;
    dep = [fdep vdep ddep];
end;

function dep = vout_dti_saliencies(job)
if isfield(job, 'data')
    tgt_spec = cfg_findspec({{'strtype','r'}});
else
    tgt_spec = cfg_findspec({{'filter','image','strtype','e'}});
end;
dep(1) = cfg_dep;
dep(1).sname = 'Curve-ness';
dep(1).src_output = substruct('.','sc');
dep(1).tgt_spec   = tgt_spec;
dep(2) = cfg_dep;
dep(2).sname = 'Plane-ness';
dep(2).src_output = substruct('.','sp');
dep(2).tgt_spec   = tgt_spec;
dep(3) = cfg_dep;
dep(3).sname = 'Sphere-ness';
dep(3).src_output = substruct('.','ss');
dep(3).tgt_spec   = tgt_spec;

function dep = vout_dti_hosvd(job)
if isfield(job, 'data')
    dep = cfg_dep;
    dep.sname = 'SVD result';
    dep.src_output = substruct('.','S');
    dep.tgt_spec   = cfg_findspec({{'strtype','r'}});
else
    dep(1) = cfg_dep;
    dep(1).sname = 'SVD(S) Images';
    dep(1).src_output = substruct('.','S');
    dep(1).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    dep(2) = cfg_dep;
    dep(2).sname = 'SVD(U) Images';
    dep(2).src_output = substruct('.','U');
    dep(2).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
end;

function dep = vout_dti_dt_time3(job)
dep(1) = cfg_dep;
dep(1).sname = 'Time of Arrival';
dep(1).src_output = substruct('.','ta');
dep(1).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep(2) = cfg_dep;
dep(2).sname = 'Time of Arrival (Band)';
dep(2).src_output = substruct('.','tb');
dep(2).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep(3) = cfg_dep;
dep(3).sname = 'Time of Arrival (Loc min)';
dep(3).src_output = substruct('.','tl');
dep(3).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep(4) = cfg_dep;
dep(4).sname = 'Distance';
dep(4).src_output = substruct('.','dst');
dep(4).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep(5) = cfg_dep;
dep(5).sname = 'Trace';
dep(5).src_output = substruct('.','trc');
dep(5).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep(6) = cfg_dep;
dep(6).sname = 'Velocity';
dep(6).src_output = substruct('.','vel');
dep(6).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});


function str = check_dti_reorient_gradient(job)
if numel(job.srcimgs) ~= numel(job.tgtimgs)
    str = '# source images must match # target images.';
else
    str = '';
end;
return;

function dep = vout_dti_dw_generate(job)
dep = cfg_dep;
dep.sname = 'DWI Simulation: Generated Volumes';
dep.src_output = substruct('.','files');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function dep = vout_dti_extract_dirs(job)
dep = cfg_dep;
dep.sname = 'Extracted direction information';
dep.src_output = substruct('()',{1});
dep.tgt_spec = cfg_findspec({{'strtype','e'}});