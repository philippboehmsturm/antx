function opt = vgtbx_config_Volumes
% Volumes toolbox
%_______________________________________________________________________
%
% This toolbox contains various helper functions to make image 
% manipulation within SPM5 more convenient. Help on each individual item 
% can be obtained by selecting the corresponding entry in the help menu.
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
% @(#) $Id: vgtbx_config_Volumes.m 539 2007-12-06 17:31:12Z glauche $

% This is the main config file for the SPM5 job management system. It
% resides in fullfile(spm('dir'),'toolbox','Volumes').


rev='$Revision: 539 $';

addpath(fullfile(spm('dir'),'toolbox','Volumes'));

% see how we are called - if no output argument, then start spm_jobman UI

if nargout == 0
        spm_jobman('interactive','','jobs.tools.vgtbx_Volumes');
        return;
end;

%-Some input elements common to many functions
%=======================================================================

interp.type = 'menu';
interp.name = 'Interpolation';
interp.tag  = 'interp';
interp.labels = {'Nearest neighbour','Trilinear','2nd Degree b-Spline',...
'3rd Degree b-Spline','4th Degree b-Spline','5th Degree b-Spline',...
'6th Degree b-Spline','7th Degree b-Spline','2nd Degree Sinc',...
'3rd Degree Sinc','4th Degree Sinc','5th Degree Sinc',...
'6th Degree Sinc','7th Degree Sinc'};
interp.values = {0,1,2,3,4,5,6,7,-2,-3,-4,-5,-6,-7};
interp.def  = 'tools.vgtbx_Volumes.interp';

overwrite.type = 'menu';
overwrite.name = 'Overwrite existing Input/Output Files';
overwrite.tag  = 'overwrite';
overwrite.labels = {'Yes', 'No'};
overwrite.values = {1, 0};
overwrite.def    = 'tools.vgtbx_Volumes.overwrite';

graphics.type = 'menu';
graphics.name = 'Graphics output';
graphics.tag  = 'graphics';
graphics.labels = {'Yes', 'No'};
graphics.values = {1, 0};
graphics.def    = 'tools.vgtbx_Volumes.graphics';

%-input and output files
%-----------------------------------------------------------------------

swd.type = 'files';
swd.name = 'Output directory';
swd.tag  = 'swd';
swd.filter = 'dir';
swd.num = [1 1];
swd.help = {['Files produced by this function will be written into this ' ...
             'output directory']};

srcimgs.type = 'files';
srcimgs.name = 'Source Images';
srcimgs.tag  = 'srcimgs';
srcimgs.filter = 'image';
srcimgs.num  = [1 Inf];

srcimg.type = 'files';
srcimg.name = 'Source Image';
srcimg.tag  = 'srcimg';
srcimg.filter = 'image';
srcimg.num  = [1 1];

fname.type = 'entry';
fname.name = 'Output Filename';
fname.tag  = 'fname';
fname.strtype = 's';
fname.num  = [1 Inf];
fname.val  = {'output.img'};
fname.help  = {[...
    'The output image is written to the selected working directory.']};

outimg.type = 'branch';
outimg.name = 'Output File & Directory';
outimg.tag  = 'outimg';
outimg.val  = {swd, fname};
outimg.help  = {[...
    'Specify a output filename and target directory.']};

prefix.type = 'entry';
prefix.name = 'Output Filename Prefix';
prefix.tag  = 'prefix';
prefix.strtype = 's';
prefix.num  = [1 Inf];
prefix.help  = {['The output filename is constructed by prefixing the original filename ' ...
                 'with this prefix.']};

srcspm.type = 'files';
srcspm.name = 'Source SPM.mat';
srcspm.tag  = 'srcspm';
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num  = [1 1];

dtype.type = 'menu';
dtype.name = 'Data Type';
dtype.tag  = 'dtype';
dtype.labels = {'SAME','UINT8  - unsigned char','INT16 - signed short','INT32 - signed int',...
                'FLOAT - single prec. float','DOUBLE - double prec. float'};
dtype.values = {0,spm_type('uint8'),spm_type('int16'),spm_type('int32'),...
                spm_type('float32'),spm_type('float64')};
dtype.val = {0};
dtype.help = {'Data-type of output images.  SAME indicates the same datatype as the original images.'};

%-Stats tools sub-menu
%=======================================================================

addpath(fullfile(spm('dir'),'toolbox','Volumes','Stats_Tools'));

%-tbxvol_changeSPM
%-----------------------------------------------------------------------

oldpath.type = 'menu';
oldpath.name = 'Path Component to be replaced';
oldpath.tag  = 'oldpath';
oldpath.labels = {'Determine and replace', 'Ask before replacing'};
oldpath.values = {'auto','ask'};
oldpath.help = {['The tool tries to guess which parts of the path names ' ...
                'need to be replaced by comparing the path stored in ' ...
                'SPM.swd with the current path to the SPM.mat file. '], ...
                ['This does not always work as expected, confirmation ' ...
                'before replacement is strongly advised.']};

newpath.type = 'menu';
newpath.name = 'Path Component to be inserted';
newpath.tag  = 'newpath';
newpath.labels = {'Determine and insert', 'Ask before inserting'};
newpath.values = {'auto','ask'};
newpath.help = {['The tool tries to quess which parts of the path names ' ...
                'need to be replaced by comparing the path stored in ' ...
                'SPM.swd with the current path to the SPM.mat file. '], ...
                ['This does not always work as expected, confirmation ' ...
                'before replacement is strongly advised.']};

dpaths.type = 'branch';
dpaths.name = 'Data Files';
dpaths.tag  = 'dpaths';
dpaths.val  = {newpath,oldpath};

apaths.type = 'branch';
apaths.name = 'Analysis Files';
apaths.tag  = 'apaths';
apaths.val  = {newpath,oldpath};

bpaths.type = 'branch';
bpaths.name = 'Data&Analysis Files';
bpaths.tag  = 'bpaths';
bpaths.val  = {newpath,oldpath};

npaths.type = 'const';
npaths.name = 'None';
npaths.tag  = 'npaths';
npaths.val  = {0};

chpaths.type = 'choice';
chpaths.name = 'Paths to change';
chpaths.tag  = 'chpaths';
chpaths.values ={dpaths, apaths, bpaths, npaths};

swap.type = 'menu';
swap.name = 'Change Byte Order Information for Mapped Images?';
swap.tag  = 'swap';
swap.labels = {'Yes', 'No'};
swap.values ={1, 0};
swap.help = {['This option may be obsolete for SPM5. With SPM2-style ' ...
             'analyses, byte order of an image was stored at the time ' ...
             'statistics were run. If one later moved the SPM.mat and ' ...
             'analysis files to a machine with different byte order, this ' ...
             'was not realised by SPM.']};

changeSPM.type = 'branch';
changeSPM.name = 'Change SPM.mat Image Information';
changeSPM.tag  = 'tbxvol_changeSPM';
changeSPM.prog = @tbxvol_changeSPM;
changeSPM.val  = {srcspm, chpaths, swap};
changeSPM.help = vgtbx_help2cell('tbxvol_changeSPM');

%-Correct error covariance components
%-----------------------------------------------------------------------

nfactor.type = 'menu';
nfactor.name = '# of Factor with unequal Variance';
nfactor.tag  = 'nfactor';
nfactor.labels = {'Factor 1','Factor 2','Factor 3'};
nfactor.values = {2,3,4};

correct_ec_SPM.type = 'branch';
correct_ec_SPM.name = 'Correct Error Covariance components';
correct_ec_SPM.tag  = 'tbxvol_correct_ec_SPM';
correct_ec_SPM.prog = @tbxvol_correct_ec_SPM;
correct_ec_SPM.val  = {srcspm nfactor};
correct_ec_SPM.help = vgtbx_help2cell('tbxvol_correct_ec_SPM');

%-Transform t maps
%-----------------------------------------------------------------------

option.type = 'menu';
option.name = 'Select output map';
option.tag  = 'option';
option.labels = {'1-p', '-log(1-p)', ...
                 'correlation coefficient cc', 'effect size d'};
option.values = {1,2,3,4};

transform_t2x.type = 'branch';
transform_t2x.name = 'Transform t maps';
transform_t2x.tag  = 'tbxvol_transform_t2x';
transform_t2x.prog = @tbxvol_transform_t2x;
transform_t2x.vfiles = @vfiles_tbxvol_transform_t2x;
transform_t2x.val  = {srcimgs option};
transform_t2x.help = vgtbx_help2cell('tbxvol_transform_t2x');

%-Compute laterality index
%-----------------------------------------------------------------------

prefix.val = {'li_'};

laterality.type = 'branch';
laterality.name = 'Compute Laterality index';
laterality.tag  = 'tbxvol_laterality';
laterality.prog = @tbxvol_laterality;
laterality.vfiles = @vfiles_tbxvol_laterality;
laterality.val  = {srcimgs interp dtype prefix};
laterality.help = vgtbx_help2cell('tbxvol_laterality');

%-Analyse ResMS image and compute SNR for regions with different quality
% of fit
%-----------------------------------------------------------------------

optsrcimg = srcimg;
optsrcimg.num  = [0 1];
optsrcimg.name = 'Brain mask image (optional)';
optsrcimg.tag  = 'maskimg';
optsrcimg.val  = {''};

dist.type = 'entry';
dist.name = 'Distance from mean';
dist.tag  = 'dist';
dist.strtype = 'e';
dist.num  = [1 1];
dist.def  = 'tools.vgtbx_Volumes.analyse_resms.dist';

analyse_resms.type = 'branch';
analyse_resms.name = 'Analyse goodness of fit';
analyse_resms.tag  = 'tbxvol_analyse_resms';
analyse_resms.prog = @tbxvol_analyse_resms;
analyse_resms.vfiles = @vfiles_tbxvol_analyse_resms;
analyse_resms.val  = {srcspm optsrcimg dist graphics};
analyse_resms.help = vgtbx_help2cell('tbxvol_analyse_resms');

% Histogramm summary
%-----------------------------------------------------------------------

maskimgs = srcimgs;
maskimgs.name = 'Mask image(s)';
maskimgs.tag  = 'maskimgs';

subject.type = 'branch';
subject.name = 'Subject';
subject.tag  = 'subjects';
subject.val  = {srcimgs, maskimgs};

subjects.type = 'repeat';
subjects.name = 'Subjects';
subjects.tag  = 'subjects';
subjects.num  = [1 Inf];
subjects.values = {subject};

bins.type = 'entry';
bins.name = 'Edges of histogramm bins';
bins.tag  = 'bins';
bins.strtype = 'e';
bins.num  = [1 Inf];
bins.help = {['Enter the edges of histogramm bins. See ''help histc'' '...
	      'for details.']};

hist_summary.type = 'branch';
hist_summary.name = 'Histogramm summary';
hist_summary.tag  = 'tbxvol_hist_summary';
hist_summary.prog = @tbxvol_hist_summary;
hist_summary.val  = {subjects bins};
hist_summary.help = vgtbx_help2cell('tbxvol_hist_summary');

%-assemble choice for Stats Tools
%-----------------------------------------------------------------------

Stats_Tools.type = 'choice';
Stats_Tools.name = 'Stats Tools';
Stats_Tools.tag  = 'Stats_Tools';
Stats_Tools.values = {changeSPM correct_ec_SPM transform_t2x laterality ...
		    analyse_resms hist_summary};

%-Multiple Volumes sub-menu
%=======================================================================

addpath(fullfile(spm('dir'),'toolbox','Volumes','Multiple_Volumes'));

% Taken from spm_config_norm
%_______________________________________________________________________
 

smosrc.type = 'entry';
smosrc.name = 'Source Image Smoothing';
smosrc.tag  = 'smosrc';
smosrc.strtype = 'e';
smosrc.num  = [1 1];
smosrc.def  = 'normalise.estimate.smosrc';
smosrc.help = {[...
'Smoothing to apply to a copy of the source image. ',...
'The template and source images should have approximately ',...
'the same smoothness. Remember that the templates supplied ',...
'with SPM have been smoothed by 8mm, and that smoothnesses ',...
'combine by Pythagoras'' rule.']};

%------------------------------------------------------------------------

smoref.type = 'entry';
smoref.name = 'Template Image Smoothing';
smoref.tag  = 'smoref';
smoref.strtype = 'e';
smoref.num  = [1 1];
smoref.def  = 'normalise.estimate.smoref';
smoref.help = {[...
'Smoothing to apply to a copy of the template image. ',...
'The template and source images should have approximately ',...
'the same smoothness. Remember that the templates supplied ',...
'with SPM have been smoothed by 8mm, and that smoothnesses ',...
'combine by Pythagoras'' rule.']};

%------------------------------------------------------------------------
 
regtype.type = 'menu';
regtype.name = 'Affine Regularisation';
regtype.tag  = 'regtype';
regtype.labels = {'ICBM space template', 'Average sized template','No regularisation'};
regtype.values = {'mni','subj','none'};
regtype.def  = 'normalise.estimate.regtype';
regtype.help   = {[...
'Affine registration into a standard space can be made more robust by ',...
'regularisation (penalising excessive stretching or shrinking).  The ',...
'best solutions can be obtained by knowing the approximate amount of ',...
'stretching that is needed (e.g. ICBM templates are slightly bigger ',...
'than typical brains, so greater zooms are likely to be needed). ',...
'If registering to an image in ICBM/MNI space, then choose the first ',...
'option.  If registering to a template that is close in size, then ',...
'select the second option.  If you do not want to regularise, then ',...
'choose the third.']};
 
%------------------------------------------------------------------------

sparams.type = 'files';
sparams.name = 'Initial normalisation params';
sparams.tag  = 'sparams';
sparams.filter = 'mat';
sparams.ufilter = '.*sn.mat$';
sparams.num  = [0 Inf];

%------------------------------------------------------------------------

template.type = 'files';
template.name = 'Template Image';
template.tag  = 'template';
template.filter = 'image';
template.num  = [1 Inf];
p1 = [...
'Specify a template image to match the source image with. ',...
'The contrast in the template must be similar to that of the ',...
'source image in order to achieve a good registration.  It is ',...
'also possible to select more than one template, in which case ',...
'the registration algorithm will try to find the best linear ',...
'combination of these images in order to best model the intensities ',...
'in the source image.'];
p2 = ['The template(s) will be used for the first iteration of within-group' ...
      ' normalisation. Further iterations will use an average version of' ...
      ' the normalised images as template.'];
template.help   = {p1, '', p2};
%------------------------------------------------------------------------

weight.type = 'files';
weight.name = 'Template Weighting Image';
weight.tag  = 'weight';
weight.filter = 'image';
weight.num  = [0 1];
weight.def  = 'normalise.estimate.weight';
p1 = [...
'Applies a weighting mask to the template(s) during the parameter ',...
'estimation.  With the default brain mask, weights in and around the ',...
'brain have values of one whereas those clearly outside the brain are ',...
'zero.  This is an attempt to base the normalization purely upon ',...
'the shape of the brain, rather than the shape of the head (since ',...
'low frequency basis functions can not really cope with variations ',...
'in skull thickness).'];
p2 = [...
'The option is now available for a user specified weighting image. ',...
'This should have the same dimensions and mat file as the template ',...
'images, with values in the range of zero to one.'];
weight.help = {p1,'',p2};
 
%------------------------------------------------------------------------

stempl.type = 'branch';
stempl.name = 'Initial normalisation template';
stempl.tag  = 'stempl';
stempl.val  = {template, weight};

%------------------------------------------------------------------------

cutoff.type = 'entry';
cutoff.name = 'Nonlinear Frequency Cutoff';
cutoff.tag  = 'cutoff';
cutoff.strtype = 'e';
cutoff.num  = [1 1];
cutoff.def  = 'normalise.estimate.cutoff';
cutoff.help = {[...
'Cutoff of DCT bases.  Only DCT bases of periods longer than the ',...
'cutoff are used to describe the warps. The number used will ',...
'depend on the cutoff and the field of view of the template image(s).']};

%------------------------------------------------------------------------

nits.type = 'entry';
nits.name = 'Nonlinear Iterations';
nits.tag  = 'nits';
nits.strtype = 'w';
nits.num  = [1 1];
nits.def  = 'normalise.estimate.nits';
nits.help = {'Number of iterations of nonlinear warping performed.'};

%------------------------------------------------------------------------

reg.type = 'entry';
reg.name = 'Nonlinear Regularisation';
reg.tag  = 'reg';
reg.strtype = 'e';
reg.num  = [1 1];
reg.def  = 'normalise.estimate.reg';
reg.help = {[...
'The amount of regularisation for the nonlinear part of the spatial ',...
'normalisation. ',...
'Pick a value around one.  However, if your normalized images appear ',...
'distorted, then it may be an idea to increase the amount of ',...
'regularization (by an order of magnitude) - or even just use an affine ',...
'normalization. ',...
'The regularization influences the smoothness of the deformation ',...
'fields.']};

%------------------------------------------------------------------------

wtsrc.type = 'files';
wtsrc.name = 'Source Weighting Image';
wtsrc.tag  = 'wtsrc';
wtsrc.filter = 'image';
wtsrc.num  = [0 1];
wtsrc.val  = {{}};
wtsrc.help = {[...
'Optional weighting images (consisting of pixel ',...
'values between the range of zero to one) to be used for registering ',...
'abnormal or lesioned brains.  These images should match the dimensions ',...
'of the image from which the parameters are estimated, and should contain ',...
'zeros corresponding to regions of abnormal tissue.']};

%------------------------------------------------------------------------

iteration.type = 'branch';
iteration.name = 'Iteration Options';
iteration.tag  = 'iteration';
iteration.val  = {smosrc,smoref,regtype,cutoff,nits,reg};
iteration.help = {'Various settings for estimating warps.'};

%------------------------------------------------------------------------

iterations.type = 'repeat';
iterations.name = 'Estimation Iterations';
iterations.tag  = 'iterations';
iterations.values = {iteration};
iterations.num  = [1 Inf];

%------------------------------------------------------------------------

starting.type = 'choice';
starting.name = 'Initial Normalisation';
starting.tag  = 'starting';
starting.values = {stempl, sparams};

%------------------------------------------------------------------------

eoptions.type = 'branch';
eoptions.name = 'Estimation Options';
eoptions.tag  = 'eoptions';
eoptions.val  = {starting,iterations};

%------------------------------------------------------------------------

source.type = 'files';
source.name = 'Source Images';
source.tag  = 'source';
source.num  = [1 Inf];
source.filter = 'image';
source.help   = {[...
'The images that are warped to match the template(s).  The result is ',...
'a set of warps, which can be applied to this image, or any other ',...
'image that is in register with it.']};

%------------------------------------------------------------------------

subj.type = 'branch';
subj.name = 'Subjects';
subj.tag  = 'subj';
subj.val  = {source, wtsrc};
subj.help = {'Data for all subjects.  The same parameters are used within subject.'};

%------------------------------------------------------------------------

normalise.type = 'branch';
normalise.name = 'Group Normalise';
normalise.tag  = 'tbxvol_normalise';
normalise.val  = {subj,eoptions};
normalise.prog = @tbxvol_normalise;
normalise.vfiles = @vfiles_tbxvol_normalise;
normalise.modality = {'FMRI','PET','VBM'};
p1 = [...
'This module spatially (stereotactically) normalizes MRI, PET or SPECT ',...
'images into a standard space defined by some ideal model or template ',...
'image[s].  The template images supplied with SPM conform to the space ',...
'defined by the ICBM, NIH P-20 project, and approximate that of the ',...
'the space described in the atlas of Talairach and Tournoux (1988). ',...
'The transformation can also be applied to any other image that has ',...
'been coregistered with these scans.'];
p2 = [...
'Generally, the algorithms work by minimising the sum of squares ',...
'difference between the image which is to be normalised, and a linear ',...
'combination of one or more template images.  For the least squares ',...
'registration to produce an unbiased estimate of the spatial ',...
'transformation, the image contrast in the templates (or linear ',...
'combination of templates) should be similar to that of the image from ',...
'which the spatial normalization is derived.  The registration simply ',...
'searches for an optimum solution.  If the starting estimates are not ',...
'good, then the optimum it finds may not find the global optimum.'];
p3 = [...
'The first step of the normalization is to determine the optimum ',...
'12-parameter affine transformation.  Initially, the registration is ',...
'performed by matching the whole of the head (including the scalp) to ',...
'the template.  Following this, the registration proceeded by only ',...
'matching the brains together, by appropriate weighting of the template ',...
'voxels.  This is a completely automated procedure (that does not ',...
'require ``scalp editing'') that discounts the confounding effects of ',...
'skull and scalp differences.   A Bayesian framework is used, such that ',...
'the registration searches for the solution that maximizes the a ',...
'posteriori probability of it being correct /* \cite{ashburner97b} */.  i.e., it maximizes the ',...
'product of the likelihood function (derived from the residual squared ',...
'difference) and the prior function (which is based on the probability ',...
'of obtaining a particular set of zooms and shears).'];
p4 = [...
'The affine registration is followed by estimating nonlinear deformations, ',...
'whereby the deformations are defined by a linear combination of three ',...
'dimensional discrete cosine transform (DCT) basis functions /* \cite{ashburner99a} */.  The default ',...
'options result in each of the deformation fields being described by 1176',...
'parameters, where these represent the coefficients of the deformations in ',...
'three orthogonal directions.  The matching involved simultaneously ',...
'minimizing the membrane energies of the deformation fields and the ',...
'residual squared difference between the images and template(s).'];
p5 = [...
'The primarily use is for stereotactic normalization to facilitate inter-subject ',...
'averaging and precise characterization of functional anatomy /* \cite{ashburner97bir} */.  It is ',...
'not necessary to spatially normalise the data (this is only a ',...
'pre-requisite  for  intersubject averaging or reporting in the ',...
'Talairach space).  If you wish to circumnavigate this step  (e.g. if ',...
'you have single slice data or do not have an appropriate high ',...
'resolution MRI scan) simply specify where you think the  anterior ',...
'commissure  is  with  the  ORIGIN in the header of the first scan ',...
'(using the ''Display'' facility) and proceed directly  to ''Smoothing''',...
'or ''Statistics''.'];
p6 = [...
'All normalized *.img scans are written to the same subdirectory as ',...
'the original *.img, prefixed with a ''w'' (i.e. w*.img).  The details ',...
'of the transformations are displayed in the results window, and the ',...
'parameters are saved in the "*_sn.mat" file.'];
opts.help = {p1,'',...
p2,'',p3,'',p4,'',...
p5,'',...
p6};
%------------------------------------------------------------------------

%-tbxvol_combine
%-----------------------------------------------------------------------

voxsz.type = 'entry';
voxsz.name = 'Output Image Voxel Size';
voxsz.tag  = 'voxsz';
voxsz.strtype = 'e';
voxsz.num  = [1 3];

prefix.val = {'C'};

combine.type = 'branch';
combine.name = 'Combine Volumes';
combine.tag  = 'tbxvol_combine';
combine.prog = @tbxvol_combine;
combine.val  = {srcimgs, voxsz, interp, dtype, prefix};
combine.help = vgtbx_help2cell('tbxvol_combine');

%-Create/Apply masks
%-----------------------------------------------------------------------

maskand.type = 'const';
maskand.name = 'AND';
maskand.tag  = 'maskpredef';
maskand.val  = {'and'};
maskand.help = {'Mask expression ''(i1~=0) & ... & (iN ~= 0)'''};

maskor.type = 'const';
maskor.name = 'OR';
maskor.tag  = 'maskpredef';
maskor.val  = {'or'};
maskor.help = {'Mask expression ''(i1~=0) | ... | (iN ~= 0)'''};

masknand.type = 'const';
masknand.name = 'NAND';
masknand.tag  = 'maskpredef';
masknand.val  = {'nand'};
masknand.help = {'Mask expression ''~((i1~=0) & ... & (iN ~= 0))'''};

masknor.type = 'const';
masknor.name = 'NOR';
masknor.tag  = 'maskpredef';
masknor.val  = {'nor'};
masknor.help = {'Mask expression ''~((i1~=0) | ... | (iN ~= 0))'''};

maskcustom.type = 'entry';
maskcustom.name = 'Custom Mask Expression';
maskcustom.tag  = 'maskcustom';
maskcustom.strtype = 's';
maskcustom.num  = [1 Inf];
maskcustom.help = {'Enter a valid expression for spm_imcalc.'};

mtype.type = 'choice';
mtype.name = 'Mask Type';
mtype.tag  = 'mtype';
mtype.values = {maskand maskor masknand masknor maskcustom};

msrcimgs = srcimgs;
msrcimgs.name = 'Source Images for New Mask';
msrcimgs.num  = [1 Inf];

moutimg = outimg;
moutimg.name = 'Mask Image Name & Directory';

maskdef.type = 'branch';
maskdef.name = 'Create New Mask';
maskdef.tag  = 'maskdef';
maskdef.val  = {msrcimgs mtype moutimg};

msrcimg = srcimg;
msrcimg.name = 'Mask Image';

maskspec.type = 'choice';
maskspec.name = 'Mask Specification';
maskspec.tag  = 'maskspec';
maskspec.values = {msrcimg maskdef};
maskspec.help = {'Specify an existing mask image or a set of images ' ...
                 'that will be used to create a mask image.'};

scope.type = 'menu';
scope.name = 'Scope of Mask';
scope.tag  = 'scope';
scope.labels = {'Inclusive','Exclusive'};
scope.values = {'i','e'};
scope.help = {['Specify which parts of the images should be kept: parts ' ...
              'where the mask image is different from zero (inclusive) ' ...
              'or parts where the mask image is zero (exclusive).']};


space.type = 'menu';
space.name = 'Space of Masked Images';
space.tag  = 'space';
space.labels = {'Object','Mask'};
space.values = {'object','mask'};
space.help = {['Specify whether the masked images should be written with ' ...
              'orientation and voxel size of the original images or of ' ...
              'the mask image.']};

prefix.val = {'M'};

nanmask.type = 'menu';
nanmask.name = 'Zero/NaN Masking';
nanmask.tag  = 'nanmask';
nanmask.labels = {'No implicit zero mask','Implicit zero mask','NaNs should be zeroed'};
nanmask.values = {0,1,-1};
nanmask.def  = 'imcalc.mask';
%nanmask.val = {0};
nanmask.help = {[...
'For data types without a representation of NaN, implicit zero masking ',...
'assummes that all zero voxels are to be treated as missing, and ',...
'treats them as NaN. NaN''s are written as zero (by spm_write_plane), ',...
'for data types without a representation of NaN.']};

maskthresh.type = 'entry';
maskthresh.name = 'Threshold for masking';
maskthresh.tag  = 'maskthresh';
maskthresh.strtype = 'e';
maskthresh.num  = [1 1];
maskthresh.def  = 'tools.vgtbx_Volumes.create_mask.maskthresh';
maskthresh.help  = {['Sometimes zeroes are represented as non-zero values ' ...
                    'due to rounding errors (especially in binary masks). Specify a small non-zero ' ...
                    'value for zero masking in this case.']};

srcspec.type = 'branch';
srcspec.name = 'Apply Created Mask';
srcspec.tag  = 'srcspec';
srcspec.val  = {srcimgs, scope, space, prefix, interp, nanmask, maskthresh, ...
               overwrite};
srcspec.help = {'Specify images which are to be masked.'};

srcspecs.type = 'repeat';
srcspecs.name = 'Apply Masks';
srcspecs.tag  = 'unused';
srcspecs.values = {srcspec};

create_mask.type = 'branch';
create_mask.name = 'Create and Apply Masks';
create_mask.tag  = 'tbxvol_create_mask';
create_mask.prog = @tbxvol_create_mask;
create_mask.vfiles = @vfiles_tbxvol_create_mask;
create_mask.val  = {maskspec, srcspecs};
create_mask.help = vgtbx_help2cell('tbxvol_create_mask');

%-Split volumes
%-----------------------------------------------------------------------

sliceorder.type = 'menu';
sliceorder.name = 'Slice/Volume Order';
sliceorder.tag  = 'sliceorder';
sliceorder.labels = {'Vol1 Slice1..N,...VolM Slice1..N',...
                    'VolM Slice1..N,...Vol1 Slice1..N',...
                    'Slice1 Vol1..M,...SliceN Vol1..M',...
                    'Slice1 VolM..1,...SliceN VolM..1'};
sliceorder.values = {'volume','volume_vrev','slice','slice_vrev'};

noutput.type = 'entry';
noutput.name = '#Output Images';
noutput.tag  = 'noutput';
noutput.num  = [1 1];
noutput.strtype = 'i';

thickcorr.type = 'menu';
thickcorr.name = 'Correct Slice Thickness';
thickcorr.tag  = 'thickcorr';
thickcorr.labels = {'Yes',...
                    'No' };
thickcorr.values = {1,0};
thickcorr.help = {['If set to ''yes'', the slice thickness is ' ...
                   'multiplied by the #output images.']};

split.type = 'branch';
split.name = 'Split Volumes';
split.tag  = 'tbxvol_split';
split.prog = @tbxvol_split;
split.vfiles=@vfiles_tbxvol_split;
split.val  = {srcimgs sliceorder noutput thickcorr};
split.help = vgtbx_help2cell('tbxvol_split');

%-Spike detection
%-----------------------------------------------------------------------

spikethr.type = 'entry';
spikethr.name = 'Threshold (in standard deviations)';
spikethr.tag  = 'spikethr';
spikethr.num  = [1 1];
spikethr.strtype = 'e';

spike.type = 'branch';
spike.name = 'Detect abnormal slices';
spike.tag  = 'tbxvol_spike';
spike.prog = @tbxvol_spike;
spike.val  = {srcimgs spikethr};
spike.help = vgtbx_help2cell('tbxvol_spike');

%-Extract subvolume
%-----------------------------------------------------------------------

bbox.type = 'entry';
bbox.name = 'Bounding Box for Extracted Image';
bbox.tag  = 'bbox';
bbox.num  = [1 6];
bbox.strtype = 'i';
bbox.help = {'Specify the bounding box in voxel coordinates of ' ...
             'the original image: X1 X2 Y1 Y2 Z1 Z2.'};

prefix.val = {'E'};

extract_subvol.type = 'branch';
extract_subvol.name = 'Extract Subvolume';
extract_subvol.tag  = 'tbxvol_extract_subvol';
extract_subvol.prog = @tbxvol_extract_subvol;
extract_subvol.val  = {srcimgs bbox prefix};
extract_subvol.help = vgtbx_help2cell('tbxvol_extract_subvol');

%-assemble choice for Multiple Volumes
%-----------------------------------------------------------------------

Multiple_Volumes.type = 'choice';
Multiple_Volumes.name = 'Multiple Volumes';
Multiple_Volumes.tag  = 'Multiple_Volumes';
% leave correct_ec_SPM here for historical reasons
Multiple_Volumes.values = {correct_ec_SPM combine create_mask extract_subvol ...
                    normalise split spike};

%-Single Volumes sub-menu
%=======================================================================

addpath(fullfile(spm('dir'),'toolbox','Volumes','Single_Volumes'));

%-Extract data
%-----------------------------------------------------------------------

src.type = 'choice';
src.name = 'Data Source';
src.tag  = 'src';
src.values = {srcspm srcimgs};
src.help = {['Data can be sampled from raw images, or from an SPM analysis. ' ...
            'In case of an SPM analysis, both fitted and raw data will ' ...
            'be sampled.']};

avg.type = 'menu';
avg.name = 'Average';
avg.tag  = 'avg';
avg.labels = {'No averaging',...
              'Average over voxels' };
avg.values = {'none','vox'};
avg.help = {['If set to ''yes'', only averages over the voxel values ' ...
                   'of each image are returned.']};
avg.def  = 'defaults.tools.vgtbx_Volumes.extract.avg';

roistart.type = 'entry';
roistart.name = 'Start Point (in mm)';
roistart.tag  = 'roistart';
roistart.num  = [3 1];
roistart.strtype = 'e';

roiend.type = 'entry';
roiend.name = 'End Point (in mm)';
roiend.tag  = 'roiend';
roiend.num  = [3 1];
roiend.strtype = 'e';

roistep.type = 'entry';
roistep.name = 'Sampling Distance along Line (in mm)';
roistep.tag  = 'roistep';
roistep.num  = [1 1];
roistep.strtype = 'e';

roiline.type = 'branch';
roiline.name = 'Line (Start and End Point)';
roiline.tag  = 'roiline';
roiline.val  = {roistart roiend roistep};
roiline.help = {['Specify a line in 3D space from a start point to an ' ...
                'end point. The image is sampled along this line according ' ...
                'to the specified sampling distance.'], ['Note that the sampling ' ...
                'positions are computed in mm space and then transformed ' ...
                'into the voxel space of the image. This may result in a ' ...
                'sparse sampling of the image, if the voxel size is smaller ' ...
                'than the sampling distance.'] };

roilinep1.type = 'entry';
roilinep1.name = 'First Point (in mm)';
roilinep1.tag  = 'roilinep1';
roilinep1.num  = [3 1];
roilinep1.strtype = 'e';

roilinep2.type = 'entry';
roilinep2.name = 'Second Point (in mm)';
roilinep2.tag  = 'roilinep2';
roilinep2.num  = [3 1];
roilinep2.strtype = 'e';

roilinecoords.type = 'entry';
roilinecoords.name = 'Point List of Line Coordinates';
roilinecoords.tag  = 'roilinecoords';
roilinecoords.num  = [1 Inf];
roilinecoords.strtype = 'e';

roilineparam.type = 'branch';
roilineparam.name = 'Line (2 Points on Line and Parameters in Line Coords)';
roilineparam.tag  = 'roilineparam';
roilineparam.val  = {roilinep1 roilinep2 roilinecoords};
roilineparam.help = {['Specify a line in 3D space  going through 2 points. ' ...
                    'The image is sampled along this line according ' ...
                    'to the specified line coordinates, starting with zero '...
                    'at the first point. Spacing between line coordinates '...
                    'can be variable.'],...
                    ['The convention for line coordinates is that negative ' ...
                    'values run from P1 towards P2, while positive values ' ...
                    'run from P1 away from P2.'],...
                    ['Note that the sampling ' ...
                'positions are computed in mm space and then transformed ' ...
                'into the voxel space of the image. This may result in a ' ...
                'sparse sampling of the image, if the voxel size is smaller ' ...
                'than the sampling distance.'] };

roicent.type = 'entry';
roicent.name = 'Centre Point (in mm)';
roicent.tag  = 'roicent';
roicent.num  = [3 1];
roicent.strtype = 'e';

roirad.type = 'entry';
roirad.name = 'Radius (in mm)';
roirad.tag  = 'roirad';
roirad.num  = [1 1];
roirad.strtype = 'e';

roisphere.type = 'branch';
roisphere.name = 'Sphere';
roisphere.tag  = 'roisphere';
roisphere.val  = {roicent roirad};
roisphere.help = {['Specify a sphere with centre and radius in mm coordinates.' ...
                  'The actual sampling positions are computed in voxel ' ...
                  'space, and therefore a contiguous sampling of the ' ...
                  'specified sphere is guaranteed.']};

roilist.type = 'entry';
roilist.name = 'Point List (in mm)';
roilist.tag  = 'roilist';
roilist.num  = [3 Inf];
roilist.strtype = 'e';
roilist.help = {['Specify a list of mm positions to be sampled. Note, that ' ...
                'this may sample a volume in a non-contiguous way, if the ' ...
                'positions do not correspond 1-to-1 to voxel positions.']};

roispec.type = 'repeat';
roispec.name = 'ROI Specification';
roispec.tag  = 'roispec';
roispec.values  = {srcimg roiline roilineparam roisphere roilist};
roispec.num  = [1 Inf];
roispec.help = {['A region of interest can be specified by an image file or ' ...
                 'a list of (mm)-positions. If an image file is given, data ' ...
                 'is extracted for all non-zero voxels in the region of ' ...
                 'interest.']};
            
extract.type = 'branch';
extract.name = 'Extract Data from ROI';
extract.tag  = 'tbxvol_extract';
extract.prog = @tbxvol_extract;
extract.val  = {src roispec avg interp};
extract.help = vgtbx_help2cell('tbxvol_extract');

%-Flip volumes
%-----------------------------------------------------------------------

flipdir.type = 'menu';
flipdir.name = 'Flip Direction (Voxel Space)';
flipdir.tag  = 'flipdir';
flipdir.labels = {'X', 'Y', 'Z'};
flipdir.values = {1, 2, 3};

prefix.val = {'F'};

flip.type = 'branch';
flip.name = 'Flip Volumes';
flip.tag  = 'tbxvol_flip';
flip.prog = @tbxvol_flip;
flip.val  = {srcimgs flipdir prefix overwrite};
flip.vfiles = @vfiles_tbxvol_flip;
flip.help = vgtbx_help2cell('tbxvol_flip');  

%-Image integrals
%-----------------------------------------------------------------------

get_integrals.type = 'branch';
get_integrals.name = 'Image integrals';
get_integrals.tag  = 'tbxvol_get_integrals';
get_integrals.prog = @tbxvol_get_integrals;
get_integrals.val  = {srcimgs};
get_integrals.help = vgtbx_help2cell('tbxvol_get_integrals');

%-Intensity histogram
%-----------------------------------------------------------------------

prefix.val = {'H'};

histogramm.type = 'branch';
histogramm.name = 'Histogramm Thresholding';
histogramm.tag  = 'tbxvol_histogramm';
histogramm.prog = @tbxvol_histogramm;
histogramm.val  = {srcimg prefix overwrite};
histogramm.help = vgtbx_help2cell('tbxvol_histogramm');

%-(De)interleave volumes
%-----------------------------------------------------------------------

interleaved.type = 'const';
interleaved.name = 'Interleaved';
interleaved.tag  = 'interleaved';
interleaved.val  = {0};

userdef.type = 'entry';
userdef.name = 'User Defined';
userdef.tag  = 'userdef';
userdef.num  = [1 Inf];
userdef.strtype = 'i';

sliceorder = []; % clear previous instance
sliceorder.type = 'choice';
sliceorder.name = 'Slice Order';
sliceorder.tag  = 'sliceorder';
sliceorder.values = {interleaved userdef};

prefix.val = {'I'};

interleave.type = 'branch';
interleave.name = '(De)Interleave Volumes';
interleave.tag  = 'tbxvol_interleave';
interleave.prog = @tbxvol_interleave;
interleave.val  = {srcimgs sliceorder prefix overwrite};
interleave.help = vgtbx_help2cell('tbxvol_interleave');

%-Replace slice
%-----------------------------------------------------------------------

repslice.type = 'entry';
repslice.name = 'Slice to Replace';
repslice.tag  = 'repslice';
repslice.num  = [1 1];
repslice.strtype = 'i';

prefix.val = {'R'};

replace_slice.type = 'branch';
replace_slice.name = 'Replace Slice';
replace_slice.tag  = 'tbxvol_replace_slice';
replace_slice.prog = @tbxvol_replace_slice;
replace_slice.val  = {srcimg repslice prefix overwrite};
replace_slice.help = vgtbx_help2cell('tbxvol_replace_slice');

%-Rescale images
%-----------------------------------------------------------------------

scale.type = 'entry';
scale.name = 'New Scaling Factor';
scale.tag  = 'scale';
scale.num  = [1 1];
scale.strtype = 'e';
scale.help = {['Set the new scaling factor. To determine this value from ' ...
               'your image series, set this field to NaN.']};

offset.type = 'entry';
offset.name = 'New Intensity Offset';
offset.tag  = 'offset';
offset.num  = [1 1];
offset.strtype = 'e';
offset.def  = 'tools.vgtbx_Volumes.tbxvol_rescale.offset';

prefix.val  = {'S'};

rescale.type = 'branch';
rescale.name = 'Rescale Images';
rescale.tag  = 'tbxvol_rescale';
rescale.prog = @tbxvol_rescale;
rescale.val  = {srcimgs scale offset dtype prefix overwrite};
rescale.help = vgtbx_help2cell('tbxvol_rescale');

%-Rescale images
%-----------------------------------------------------------------------

oldscale.type = 'entry';
oldscale.name = 'Old intensity range';
oldscale.tag  = 'oldscale';
oldscale.num  = [1 2];
oldscale.strtype = 'e';
oldscale.help = {['Original data intensity scaling. To derive min/max' ...
		  ' from the data, set the first or second entry to Inf.']};

newscale.type = 'entry';
newscale.name = 'New intensity range';
newscale.tag  = 'newscale';
newscale.num  = [1 2];
newscale.strtype = 'e';
newscale.help = {'Set min/max value for new intensity range.'};

prefix.val  = {'S'};

rescale_min_max.type = 'branch';
rescale_min_max.name = 'Rescale Images to [min max]';
rescale_min_max.tag  = 'tbxvol_rescale_min_max';
rescale_min_max.prog = @tbxvol_rescale_min_max;
rescale_min_max.vfiles = @vfiles_tbxvol_rescale_min_max;
rescale_min_max.val  = {srcimgs oldscale newscale prefix};
rescale_min_max.help = vgtbx_help2cell('tbxvol_rescale_min_max');

%-Unwrap volumes
%-----------------------------------------------------------------------

npix.type = 'entry';
npix.name = '#pixels to Unwrap';
npix.tag  = 'npix';
npix.num  = [1 1];
npix.strtype = 'i';

wrapdir.type = 'menu';
wrapdir.name = 'Wrap Direction (Voxel Space)';
wrapdir.tag  = 'wrapdir';
wrapdir.labels = {'X', 'Y', 'Z'};
wrapdir.values = {1, 2, 3};

cor_orig.type = 'menu';
cor_orig.name = 'Correct Origin of Wrapped Images';
cor_orig.tag  = 'cor_orig';
cor_orig.labels = {'Yes', 'No'};
cor_orig.values = {1, 0};
cor_orig.def  = 'tools.vgtbx_Volumes.tbxvol_unwrap.cor_orig';

prefix.val = {'U'};

unwrap.type = 'branch';
unwrap.name = 'Unwrap Volumes';
unwrap.tag  = 'tbxvol_unwrap';
unwrap.prog = @tbxvol_unwrap;
unwrap.val  = {srcimgs cor_orig npix wrapdir prefix overwrite};
unwrap.help = vgtbx_help2cell('tbxvol_unwrap');

%-assemble choice for Single Volumes
%-----------------------------------------------------------------------

Single_Volumes.type = 'choice';
Single_Volumes.name = 'Single Volumes';
Single_Volumes.tag  = 'Single_Volumes';
Single_Volumes.values = {extract flip get_integrals histogramm interleave replace_slice ...
                   rescale rescale_min_max unwrap};

%-Main menu level
%=======================================================================
opt.type = 'repeat';
opt.name = 'Volume handling utilities';
opt.tag  = 'vgtbx_Volumes';
opt.values = {Single_Volumes Multiple_Volumes Stats_Tools};
opt.num  = [0 Inf];
opt.help = vgtbx_help2cell(mfilename);

%-Add defaults
%=======================================================================
global defaults;
% Overwrite images
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.overwrite = 1;
% Graphics output
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.graphics = 1;
% Nearest Neighbour interpolation
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.interp = 0;
% Distance from ResMS mean
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.analyse_resms.dist = .1;
% Average extracted data
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.extract.avg = 'none';
% Rescale offset
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.tbxvol_rescale.offset = 0;
% Correct origin when unwrapping
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.tbxvol_unwrap.cor_orig = 1;
% Correct origin when unwrapping
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Volumes.create_mask.maskthresh = eps;

function vfiles = vfiles_tbxvol_split(job)
vfiles = {};
for l = 1:numel(job.srcimgs)
        [p n e v] = fileparts(job.srcimgs{l});
        c = findstr(e, ',');
        if ~isempty(c)
                e = e(1:c-1);
        end;
        fs = sprintf('_%%0%dd',ceil(log10(job.noutput)));
        for k = 1:job.noutput
                vfiles{end+1} = fullfile(p,[n sprintf(fs,k) e ',1' v]);
        end;
end;

function vfiles = vfiles_tbxvol_create_mask(job)
vfiles = {};
if isfield(job.maskspec,'maskdef')
        [p n e v] = fileparts(job.maskspec.maskdef.outimg.fname);
        c = findstr(e, ',');
        if ~isempty(c)
                e = e(1:c-1);
        end;
        vfiles{end+1} = fullfile(job.maskspec.maskdef.outimg.swd{1}, [n e ',1' v]);
end;
for l=1:numel(job.srcspec)
        for k=1:numel(job.srcspec(l).srcimgs);
                [p n e v] = fileparts(job.srcspec(l).srcimgs{k});
                c = findstr(e, ',');
                if ~isempty(c)
                        e = e(1:c-1);
                end;
                vfiles{end+1} = fullfile(p,[job.srcspec(l).prefix ...
                                    lower(job.srcspec(l).scope) n e ',1' v]);
        end;
end;

function vfiles = vfiles_tbxvol_transform_t2x(job)
for k = 1:numel(job.srcimgs)
    [pth nm xt vr] = spm_fileparts(job.srcimgs{k});
    switch job.option
    case 1
        nm2 = 'P';
    case 2
        nm2 = 'logP';
    case 3
        nm2 = 'R';
    case 4
        nm2 = 'D';
    end
    
    % name should follow convention spm?_0*.img
    if strcmp(nm(1:3),'spm') & strcmp(nm(4:6),'T_0')	
        num = str2num(nm(length(nm)-2:length(nm)));
        vfiles{k} = fullfile(pth,[nm(1:3) nm2 nm(5:end) xt ',1']);
    else
        vfiles{k} = fullfile(pth,['spm' nm2 '_' nm xt ',1']);
    end
end;

function vfiles = vfiles_tbxvol_laterality(job)
for k = 1:numel(job.srcimgs)
    [pth nm xt vr] = spm_fileparts(job.srcimgs{k});
    vfiles{k} = fullfile(pth, [job.prefix nm xt ',1']);
end;

function vfiles = vfiles_tbxvol_rescale_min_max(job)
for k = 1:numel(job.srcimgs)
    [pth nm xt vr] = spm_fileparts(job.srcimgs{k});
    vfiles{k} = fullfile(pth, [job.prefix nm xt ',1']);
end;

function vfiles = vfiles_tbxvol_flip(job)
vfiles = job.srcimgs;
if ~job.overwrite
    dirs = 'XYZ';
    for k=1:numel(job.srcimgs)
        [p n e v] = fileparts(job.srcimgs{k});
        vfiles{k} = fullfile(p,[job.prefix dirs(job.flipdir) n e v]);
    end;
end;

function vf = vfiles_tbxvol_normalise(varargin)
job = varargin{1};
vf  = cell(numel(job.subj.source));
for i=1:numel(job.subj.source),
    [pth,nam,ext,num] = spm_fileparts(deblank(job.subj.source{i}));
    vf{i} = fullfile(pth,[nam,'_gr_sn.mat']);
end;
