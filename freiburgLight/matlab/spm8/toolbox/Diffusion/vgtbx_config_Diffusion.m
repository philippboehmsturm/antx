function varargout = vgtbx_config_Diffusion(varargin)
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

% This is the main config file for the SPM5 job management system. It
% resides in fullfile(spm('dir'),'toolbox','Diffusion').

rev='$Revision: 543 $';

addpath(genpath(fullfile(spm('dir'),'toolbox','Diffusion')));

% see how we are called - if no output argument, then start spm_jobman UI

if nargout == 0
        spm_jobman('interactive','','jobs.tools.vgtbx_Diffusion');
        return;
end;

% Some common input elements
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
interp.def  = 'tools.vgtbx_Diffusion.interp';

hold = interp;
hold.tag = 'hold';

dtorder.type = 'entry';
dtorder.name = 'Tensor order';
dtorder.tag  = 'dtorder';
dtorder.strtype = 'n';
dtorder.num = [1 1];
dtorder.help = {['Enter an even number (default 2). This determines the order of your ' ...
                 'diffusion tensors. Higher order tensors can be estimated ' ...
                 'only from data with many different diffusion weighting ' ...
                 'directions. See the referenced literature/*\cite{Orszalan2003}*/ for details.']};

res.type = 'entry';
res.strtype = 'e';
res.name = 'Sphere resolution';
res.tag  = 'res';
res.num  = [1 1];
res.help = {['Resolution of the unit grid on which the sphere will be ' ...
             'created. This grid will have the resolution [-1:res:1] in ' ...
             'x,y,z directions.']};

prefix.type = 'entry';
prefix.name = 'Output Filename Prefix';
prefix.tag  = 'prefix';
prefix.strtype = 's';
prefix.num  = [1 Inf];
prefix.help  = {['The output filename is constructed by prefixing the original filename ' ...
                 'with this prefix.']};

sep.type = 'menu';
sep.name = 'Distinguish antiparallel gradient directions';
sep.tag  = 'sep';
sep.labels = {'Yes','No'};
sep.values = {1,0};
sep.def  = 'tools.vgtbx_Diffusion.extract_dirs.sep';
sep.help = {['In theory, antiparallel gradient directions should be ' ...
             'equivalent when measuring diffusion. However, due to possible ' ...
             'scanner effects this might be not true.'],'',...
            ['If this entry is set to ''Yes'' then antiparallel gradient ' ...
             'directions will be treated as different from each other.']};
            
dtol.type = 'entry';
dtol.name = 'Gradient direction tolerance';
dtol.tag  = 'dtol';
dtol.strtype = 'e';
dtol.num  = [1 1];
dtol.def  = 'tools.vgtbx_Diffusion.extract_dirs.dtol';
dtol.help = {['Determines which gradient vectors describe similar directions. ' ...
              'Colinearity will be computed as the scalar product between ' ...
              'two unit-length gradient vectors.'],'',...
              ['Two gradient vectors are treated as similar, if their ' ...
               'scalar product is larger than the tolerance value. This ' ...
               'means a tolerance value of -1 will treat all directions ' ...
               'as similar, whereas a positive value between 0 and 1 ' ...
               'will distinguish between different directions.']};

ltol.type = 'entry';
ltol.name = 'B value tolerance';
ltol.tag  = 'ltol';
ltol.strtype = 'e';
ltol.num  = [1 1];
ltol.def  = 'tools.vgtbx_Diffusion.extract_dirs.ltol';
ltol.help = {['B values will be divided by this tolerance value and then ' ...
              'rounded. Any b values that are still different after ' ...
              'rounding, will be treated as different.']};

%-input and output files
%-----------------------------------------------------------------------

srcimgs.type = 'files';
srcimgs.name = 'Source Images';
srcimgs.tag  = 'srcimgs';
srcimgs.filter = 'image';
srcimgs.num  = [1 Inf];
srcimgs.help = {'The source images (one or more).'};

srcimg.type = 'files';
srcimg.name = 'Source Image';
srcimg.tag  = 'srcimg';
srcimg.filter = 'image';
srcimg.num  = [1 1];
srcimg.help = {'One source image.'};

snparams = srcimg;
snparams.tag = 'snparams';
snparams.name = 'Normalisation parameters (optional)';
snparams.filter = 'mat';
snparams.ufilter = '.*sn.*';
snparams.num = [0 1];
snparams.val = {''};
snparams.help = {['A file containing spatial normalisation parameters. ' ...
                  'Spatial transformations from normalisation will be read from this file.']};

maskimg.type = 'files';
maskimg.name = 'Mask Image';
maskimg.tag  = 'maskimg';
maskimg.filter = 'image';
maskimg.num  = [1 1];
maskimg.help = {['Specify an image for masking your data. Only voxels where ' ...
                 'this image has non-zero intensity will be ' ...
                 'processed.']};
                
optmaskimg = maskimg;
optmaskimg.name = 'Mask Image (optional)';
optmaskimg.num  = [0 1];
optmaskimg.val  = {''};
optmaskimg.help = {optmaskimg.help{:},'',['This image is optional. If not ' ...
                    'specified, the whole volume will be analysed.']};

dtimg.type = 'files';
dtimg.name = 'Diffusion Tensor Images';
dtimg.tag  = 'dtimg';
dtimg.filter = 'image';
dtimg.ufilter = '^D([x-z][x-z])*_.*';
dtimg.num  = [6 Inf];
dtimg.help = {['Select images containing diffusion tensor data. If they are ' ...
             'not computed using this toolbox, they need to be named ' ...
             'according to the naming conventions of the toolbox or have ' ...
             'at least an similar alphabetical order.']};

faimg.type = 'files';
faimg.name = 'Fractional Anisotropy Image';
faimg.tag  = 'faimg';
faimg.filter = 'image';
faimg.ufilter = '^fa.*';
faimg.num  = [1 1];

e1img.type = 'files';
e1img.name = '1st Eigenvector Images';
e1img.tag  = 'e1img';
e1img.filter = 'image';
e1img.ufilter = '^e(vec)?1.*';
e1img.num  = [3 3];

e2img.type = 'files';
e2img.name = '2nd Eigenvector Images';
e2img.tag  = 'e2img';
e2img.filter = 'image';
e2img.ufilter = '^e(vec)?2.*';
e2img.num  = [3 3];

e3img.type = 'files';
e3img.name = '3rd Eigenvector Images';
e3img.tag  = 'e3img';
e3img.filter = 'image';
e3img.ufilter = '^e(vec)?3.*';
e3img.num  = [3 3];

limg.type = 'files';
limg.name = 'Eigenvalue Images';
limg.tag  = 'limg';
limg.filter = 'image';
limg.ufilter = '^(eva)?l[1-3].*';
limg.num  = [3 3];

swd.type = 'files';
swd.name = 'Output directory';
swd.tag  = 'swd';
swd.filter = 'dir';
swd.num = [1 1];
swd.help = {['Files produced by this function will be written into this ' ...
             'output directory']};

srcspm.type = 'files';
srcspm.name = 'Source SPM.mat';
srcspm.tag  = 'srcspm';
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num  = [1 1];
srcspm.help = {'Select SPM.mat from a previous analysis step.'};

% Comparisons
%=======================================================================

% Classify tensors
%-----------------------------------------------------------------------

fathresh.type = 'entry';
fathresh.name = 'FA threshold';
fathresh.tag  = 'fathresh';
fathresh.strtype = 'e';
fathresh.num  = [1 1];
fathresh.help  = {['FA threshold - Voxels above will be treated as ' ...
                   'anisotropic, voxels below as isotropic.']};

clprefix = prefix;
clprefix.val = {'cl'};

classify.type = 'branch';
classify.name = 'Classify Neighbouring Tensors';
classify.tag  = 'dti_classify';
classify.val  = {e1img faimg fathresh maskimg clprefix};
classify.prog = @dti_classify;
classify.vfiles = @vfiles_dti_classify;
classify.help = vgtbx_help2cell('dti_classify');

% Compare tensors
%-----------------------------------------------------------------------

refdtimg = dtimg;
refdtimg.tag  = 'refdtimg';
refdtimg.name = 'Reference Tensor';

cpprefix = prefix;
cpprefix.val = {'cp'};

compare.type = 'branch';
compare.name = 'Voxel-by-Voxel Comparison of Tensors';
compare.tag  = 'dti_compare';
compare.val  = {dtimg, refdtimg, maskimg cpprefix};
compare.prog = @dti_compare;
compare.vfiles = @vfiles_dti_compare;
compare.help = vgtbx_help2cell('dti_compare');

% Rotate tensors
%-----------------------------------------------------------------------

refe1img = e1img;
refe1img.tag = 'refe1img';
refe1img.name = 'Reference Eigenvector';

roprefix = prefix;
roprefix.val = {'ro'};

evec_rot.type = 'branch';
evec_rot.name = 'Voxel-by-Voxel Rotation of Eigenvectors';
evec_rot.tag  = 'dti_evec_rot';
evec_rot.val  = {e1img, refe1img, maskimg roprefix};
evec_rot.prog = @dti_evec_rot;
evec_rot.vfiles = @vfiles_dti_evec_rot;
evec_rot.help = vgtbx_help2cell('dti_evec_rot');

% Tensor estimation
%=======================================================================

% ADC
%-----------------------------------------------------------------------

file0 = srcimg;
file0.tag = 'file0';
file0.name = 'B0 image';
file0.help = {'Select the b0 image for ADC computation.'};

files1 = srcimgs;
files1.tag = 'files1';
files1.name = 'DW image(s)';
files1.help = {['Diffusion weighted images - one ADC image per DW image ' ...
                'will be produced.']};

minS.type = 'entry';
minS.name = 'Minimum Signal Threshold';
minS.tag  = 'minS';
minS.strtype = 'e';
minS.num  = [1 1];
minS.val = {1};
minS.help = {['Logarithm of values below 1 will produce negative ADC ' ...
              'results. Very low intensities are probably due to noise ' ...
              'and should be masked out.']};

adcprefix = prefix;
adcprefix.val = {'adc_'};

adc.type = 'branch';
adc.name = 'Compute ADC Images';
adc.tag  = 'dti_adc';
adc.val  = {file0 files1 minS adcprefix interp};
adc.prog = @dti_adc;
adc.vfiles = @vfiles_dti_adc;
adc.help = vgtbx_help2cell('dti_adc');

% Tensor from 6 ADC images
%-----------------------------------------------------------------------

files = srcimgs;
files.tag = 'files';
files.name = 'ADC images';
files.num = [6 6];

dt_adc.type = 'branch';
dt_adc.name = 'Compute Tensor from 6 ADC Images';
dt_adc.tag  = 'dti_dt_adc';
dt_adc.val  = {files, interp};
dt_adc.prog = @dti_dt_adc;
dt_adc.vfiles = @vfiles_dti_dt_adc;
dt_adc.help = vgtbx_help2cell('dti_dt_adc');

% Tensor from multiple directions/multiple measurements
%-----------------------------------------------------------------------

dwsrcimgs = srcimgs;
dwsrcimgs.tag = 'srcimgs';
dwsrcimgs.name = 'DW images';
dwsrcimgs.num = [8 Inf];
dwsrcimgs.help = {['Enter all diffusion weighted images (all replicated ' ...
                   'measurements, all diffusion weightings) and b0 images ' ...
                   'at once.']}; 

inorder.type = 'menu';
inorder.name = 'Input Order';
inorder.tag  = 'inorder';
inorder.labels = {'repl1 all b | repl2 all b ... replX all b', ...
	    'b1 all repl | b2 all repl ... bX all repl'};
inorder.values ={'repl','bval'};
inorder.help = {['The input order determines the way in which error ' ...
                 'covariance components are specified: the assumption is ' ...
                 'that error covariances are equal over similar diffusion '...
                 'weightings. If images are given replication by replication, '...
                 'the ordering of diffusion weighting should be the same ' ...
                 'for each replication.']};

ndw.type = 'entry';
ndw.name = '# of different diffusion weightings';
ndw.tag  = 'ndw';
ndw.strtype = 'n';
ndw.num  = [1 1];
ndw.help = {['Give the number of different diffusion weightings. The product ' ...
             'of #dw and #rep must match the number of your images.']};

nrep.type = 'entry';
nrep.name = '# of repetitions';
nrep.tag  = 'nrep';
nrep.strtype = 'n';
nrep.num  = [1 1];
nrep.help = {['Give the number of repeated measurements. The product ' ...
             'of #dw and #rep must match the number of your images.']};

erriid.type = 'const';
erriid.tag  = 'erriid';
erriid.name = 'Equal errors, equal variance';
erriid.val  = {1};

regltol = ltol;
regdtol.def = 'tools.vgtbx_Diffusion.dti_dt_regress.ltol';

regdtol = dtol;
regdtol.def = 'tools.vgtbx_Diffusion.dti_dt_regress.dtol';

regsep = sep;
regsep.def = 'tools.vgtbx_Diffusion.dti_dt_regress.sep';

errauto.type = 'branch';
errauto.tag  = 'errauto';
errauto.name = 'Auto-determined by b-values';
errauto.val  = {regltol regdtol regsep};
errauto.help = {['Automatic determination of error variance components ' ...
                 'from diffusion weighting information. This is the ' ...
                 'recommended method.'],'',...
                ['To discriminate between b values, but not directions, ' ...
                 'set direction tolerance to 0 and do not distinguish ' ...
                 'between antiparallel directions.']};

errspec.type = 'branch';
errspec.tag  = 'errspec';
errspec.name = 'User specified';
errspec.val  = {inorder, ndw, nrep};
errspec.help = {['Specify error variance components for repeated measurements ' ...
                 'with similar diffusion weighting in each ' ...
                 'repetition.']};
                
errorvar.type = 'choice';
errorvar.name = 'Error variance options';
errorvar.tag  = 'errorvar';
errorvar.values  = {erriid, errauto, errspec};
errorvar.help = {['Diffusion weighted images may have different error ' ...
                  'variances depending on diffusion gradient strength and ' ...
                  'directions. To correct for this, one can model error ' ...
                  'variances based on diffusion information or measurement ' ...
                   'order.']};

dtoptmaskimg = optmaskimg;
dtoptmaskimg.help = {dtoptmaskimg.help{:},'',...
                    ['For a proper estimation of error covariances, non-brain ' ...
                    'voxels should be excluded by an explicit mask. This ' ...
                    'could be an mask based on an intensity threshold of ' ...
                    'your b0 images or a mask based on grey and white ' ...
                    'matter segments from SPM segmentation. Only voxels, ' ...
                    'with non-zero mask values will be included into analysis.']};

spatsm.type = 'menu';
spatsm.name = 'Estimate spatial smoothness';
spatsm.tag  = 'spatsm';
spatsm.labels = {'Yes', 'No'};
spatsm.values = {1 0};
spatsm.help = {['Spatial smoothness estimates are not needed if one is ' ...
                'only interested in the tensor values itself. Estimation ' ...
                'can be speeded up by forcing SPM not to compute it.']};
spatsm.def  = 'tools.vgtbx_Diffusion.dti_dt_regress.spatsm';

dt_regress.type = 'branch';
dt_regress.name = 'Compute Tensor (Multiple Regression)';
dt_regress.tag  = 'dti_dt_regress';
dt_regress.val  = {dwsrcimgs, errorvar,dtorder,dtoptmaskimg,swd,spatsm};
dt_regress.prog = @dti_dt_regress;
dt_regress.vfiles = @vfiles_dti_dt_regress;
dt_regress.help = vgtbx_help2cell('dti_dt_regress');

% Recover DW images from tensor fit
%-----------------------------------------------------------------------

recalc.type = 'branch';
recalc.name = 'Compute filtered/adjusted DW Images from Regression Model';
recalc.tag  = 'dti_recalc';
recalc.val  = {srcspm,prefix};
recalc.prog = @dti_recalc;
recalc.vfiles = @vfiles_dti_recalc;
recalc.help = vgtbx_help2cell('dti_recalc');

%-Tensor decomposition
%=======================================================================

% Eigenvectors/values/angles
%-----------------------------------------------------------------------

dteigopts.type = 'menu';
dteigopts.name = 'Decomposition output';
dteigopts.tag  = 'dteigopts';
dteigopts.labels = {'Eigenvectors and Eigenvalues',...
                    'Euler angles and Eigenvalues',...
                    'Eigenvalues only',...
                    'Euler angles only',...
                    'All'}; 
dteigopts.values = {'vl','al','l','a','alv'};

dt_eig.type = 'branch';
dt_eig.name = 'Tensor decomposition';
dt_eig.tag  = 'dti_eig';
dt_eig.val  = {dtimg, dteigopts};
dt_eig.prog = @dti_eig;
dt_eig.vfiles = @vfiles_dti_eig;
dt_eig.help = vgtbx_help2cell('dti_eig');

% Tensor indices
%-----------------------------------------------------------------------

option.type = 'menu';
option.name = 'Compute indices';
option.tag  = 'option';
option.labels = {'Fractional Anisotropy',...
                 'Variance Anisotropy',...
                 'Average Diffusivity',...
                 'Fractional+Variance Anisotropy',...
                 'All'}; 
option.values = {'f','v','d','fv','fvd'};

indices.type = 'branch';
indices.name = 'Tensor Indices';
indices.tag  = 'dti_indices';
indices.val  = {dtimg, option};
indices.prog = @dti_indices;
indices.vfiles = @vfiles_dti_indices;
indices.help = vgtbx_help2cell('dti_indices');

% Salient features
%-----------------------------------------------------------------------

saliencies.type = 'branch';
saliencies.name = 'Salient Features';
saliencies.tag  = 'dti_saliencies';
saliencies.val  = {limg};
saliencies.prog = @dti_saliencies;
saliencies.vfiles = @vfiles_dti_saliencies;
saliencies.help = vgtbx_help2cell('dti_saliencies');

%-Time of Arrival Tracking
%=======================================================================

% Full tensor tracking
%-----------------------------------------------------------------------

sroi = srcimg;
sroi.name = 'Starting ROI';
sroi.tag  = 'sroi';
sroi.help = {'Specify starting region.'};

eroi = srcimg;
eroi.name = 'Target ROI (optional)';
eroi.tag  = 'eroi';
eroi.num  = [0 1];
eroi.help = {['Specify target region (optional). Tracking will stop when ' ...
              'all voxels within a target region have been reached or the ' ...
              'specified fraction of all voxels has been visited.']};

frac.type = 'entry';
frac.strtype = 'e';
frac.name = 'Fraction of voxels to be visited';
frac.tag  = 'frac';
frac.num  = [1 1];
frac.help = {['Fraction of voxels to be visited before stopping.']};

exp.type = 'entry';
exp.strtype = 'n';
exp.name = 'Exponential for tensor';
exp.tag  = 'exp';
exp.num  = [1 1];

resfile.type = 'menu';
resfile.name = 'Results filename generation';
resfile.tag  = 'resfile';
resfile.labels = {'From Tensor','From Start ROI', 'From End ROI'};
resfile.values = {'t','s','e'};

nb.type = 'menu';
nb.name = 'Neighbourhood';
nb.tag  = 'nb';
nb.labels = {'6 Neighbours','18 Neighbours', '26 Neighbours'};
nb.values = {6,18,26};

dt_time3.type = 'branch';
dt_time3.name = 'Tracking - Computation of Arrival time';
dt_time3.tag  = 'dti_dt_time3';
dt_time3.val  = {dtimg dtorder maskimg sroi eroi resfile swd frac nb exp};
dt_time3.prog = @dti_dt_time3;
dt_time3.vfiles = @vfiles_dti_dt_time3;
dt_time3.help = vgtbx_help2cell('dti_dt_time3');

% Backtracing paths
%-----------------------------------------------------------------------

trace = srcimg;
trace.name = 'Trace Image';
trace.tag  = 'trace';
trace.help = {'Specify trace image.'};

pathprefix = prefix;
pathprefix.val = {'p'};

dt_tracepath.type = 'branch';
dt_tracepath.name = 'Tracking - Backtracing Paths';
dt_tracepath.tag  = 'dti_tracepath';
dt_tracepath.val  = {sroi trace pathprefix};
dt_tracepath.prog = @dti_tracepath;
dt_tracepath.help = vgtbx_help2cell('dti_tracepath');

%-Higher Order Tensors
%=======================================================================

% Higher Order SVD
%-----------------------------------------------------------------------

hosvd.type = 'branch';
hosvd.name = 'Higher Order SVD';
hosvd.tag  = 'dti_hosvd';
hosvd.val  = {dtimg dtorder};
hosvd.prog = @dti_hosvd;
hosvd.vfiles = @vfiles_dti_hosvd;
hosvd.help = vgtbx_help2cell('dti_hosvd');

%-Preprocessing
%=======================================================================

% Init DTI data
%-----------------------------------------------------------------------

b.type = 'entry';
b.name = 'B values';
b.tag  = 'b';
b.strtype = 'e';
b.num = [Inf 1];
b.help = {['A vector of b values (one number per image). The actual b value ' ...
           'used in tensor computation will depend on this value, multiplied ' ...
           'with the length of the corresponding gradient vector.']};

g.type = 'entry';
g.name = 'Gradient direction values';
g.tag  = 'g';
g.strtype = 'e';
g.num = [Inf 3];
g.help = {['A #img-by-3 matrix of gradient directions. The length of each ' ...
           'gradient vector will be used as a scaling factor to the b ' ...
           'value. Therefore, you should make sure that your gradient ' ...
           'vectors are of unit length if your b value already encodes ' ...
           'for diffusion weighting strength.']};

M.type = 'const';
M.name = 'Reset orientation';
M.tag  = 'M';
M.val  = {1};
M.hidden = 1;

resetall.type = 'branch';
resetall.name = '(Re)set Gradient, b value and position';
resetall.tag  = 'resetall';
resetall.val  = {b g M};

resetbg.type = 'branch';
resetbg.name = '(Re)set Gradient and b value';
resetbg.tag  = 'resetbg';
resetbg.val  = {b g};

resetb.type = 'branch';
resetb.name = '(Re)set b value';
resetb.tag  = 'resetb';
resetb.val  = {b};

resetg.type = 'branch';
resetg.name = '(Re)set Gradient';
resetg.tag  = 'reset';
resetg.val  = {g};

resetM.type = 'branch';
resetM.name = '(Re)set position';
resetM.tag  = 'resetM';
resetM.val  = {M};

setM.type = 'const';
setM.name = 'Add M matrix to existing DTI information';
setM.tag  = 'setM';
setM.val = {1};

initopts.type = 'choice';
initopts.name = '(Re)Set what?';
initopts.tag  = 'initopts';
initopts.values = {resetall, resetbg, resetb, resetg, resetM, setM};

init_dti_data.type = 'branch';
init_dti_data.name = '(Re)Set DTI information';
init_dti_data.tag  = 'dti_init_dtidata';
init_dti_data.val  = {srcimgs, initopts};
init_dti_data.prog = @dti_init_dtidata;
init_dti_data.help = vgtbx_help2cell('dti_init_dtidata');

% Realign
%-----------------------------------------------------------------------

b0corr.type = 'menu';
b0corr.name = 'Motion correction on b0 images';
b0corr.tag  = 'b0corr';
b0corr.labels = {'None', 'Stepwise', ...
                 'Linear interpolation (last stepwise)',...
                 'Linear interpolation (last linear)'};
b0corr.values = {0,1,2,3};

b1corr.type = 'menu';
b1corr.name = 'Motion correction on all (b0+DW) images';
b1corr.tag  = 'b1corr';
b1corr.labels = {'None', 'Realign xy',...
                 'Realign per dw separately',...
                 'Realign xy & Coregister to mean',...
                 'Full Realign & Coregister (rigid body) to mean',...
                 'Full Realign & Coregister (full affine) to mean'};
b1corr.values = {0,1,2,3,4,5};

realign.type = 'branch';
realign.name = 'Realign DW image time series';
realign.tag  = 'dti_realign';
realign.val  = {srcimgs, b0corr, b1corr};
realign.prog = @dti_realign;
realign.help = vgtbx_help2cell('dti_realign');

% Reorient gradients
%-----------------------------------------------------------------------
rsrcimgs = srcimgs;
rsrcimgs.help = {['Diffusion information will be read from these ' ...
                  'images.']};

tgtimgs = srcimgs;
tgtimgs.name = 'Target images';
tgtimgs.tag  = 'tgtimgs';
tgtimgs.help = {['Diffusion information will be copied to this images, ' ...
                 'applying motion correction and (optional) normalisation ' ...
                 'information to gradient directions.']};

rot.type = 'menu';
rot.name = 'Rotation';
rot.tag  = 'rot';
rot.labels = {'Yes', 'No'};
rot.values = {1, 0};
rot.def = 'tools.vgtbx_Diffusion.dti_reorient_gradient.useaff.rot';

zoom.type = 'menu';
zoom.name = 'Zoom';
zoom.tag  = 'zoom';
zoom.labels = {'Sign of zooms', 'Sign and magnitude', 'No'};
zoom.values = {1, 2, 0};
zoom.def = 'tools.vgtbx_Diffusion.dti_reorient_gradient.useaff.zoom';

shear.type = 'menu';
shear.name = 'Shear';
shear.tag  = 'shear';
shear.labels = {'Yes', 'No'};
shear.values = {1, 0};
shear.def = 'tools.vgtbx_Diffusion.dti_reorient_gradient.useaff.shear';

useaff.type = 'branch';
useaff.name = 'Affine Components for Reorientation';
useaff.tag  = 'useaff';
useaff.val  = {rot, zoom, shear};
useaff.help = {['Select which parts of an affine transformation to consider ' ...
                'for reorientation.']};

reorient_gradient.type = 'branch';
reorient_gradient.name = 'Copy and Reorient diffusion information';
reorient_gradient.tag  = 'dti_reorient_gradient';
reorient_gradient.val  = {rsrcimgs tgtimgs snparams useaff};
reorient_gradient.prog = @dti_reorient_gradient;
reorient_gradient.vfiles = @vfiles_dti_reorient_gradient;
%reorient_gradient.check = @check_dti_reorient_gradient;
reorient_gradient.help = vgtbx_help2cell('dti_reorient_gradient');

% Warp tensors
%-----------------------------------------------------------------------
rsnparams = rmfield(snparams,'val');
rsnparams.name = 'Normalisation parameters';

rsnparams.num = [1 1];

warp_tensors.type = 'branch';
warp_tensors.name = 'Warp tensors';
warp_tensors.tag  = 'dti_warp_tensors';
warp_tensors.val  = {dtimg rsnparams};
warp_tensors.prog = @dti_warp_tensors;
warp_tensors.help = vgtbx_help2cell('dti_warp_tensors');

%-Visualisation
%=======================================================================

% Visualise gradient directions
%-----------------------------------------------------------------------
axbgcol.type = 'entry';
axbgcol.strtype = 'e';
axbgcol.name = 'Axis background colour';
axbgcol.tag  = 'axbgcol';
axbgcol.num  = [1 3];
axbgcol.def  = 'tools.vgtbx_Diffusion.dti_disp_grad.axbgcol';

fgbgcol.type = 'entry';
fgbgcol.strtype = 'e';
fgbgcol.name = 'Figure background colour';
fgbgcol.tag  = 'fgbgcol';
fgbgcol.num  = [1 3];
fgbgcol.def  = 'tools.vgtbx_Diffusion.dti_disp_grad.fgbgcol';

res.def  = 'tools.vgtbx_Diffusion.dti_disp_grad.res';

option.type = 'menu';
option.name = 'Information to display';
option.tag  = 'option';
option.labels = {'Gradient vectors',...
                 'Direction distribution',...
                 'Both'};
option.values = {'v','d','vd'};

disp_grad.type = 'branch';
disp_grad.name = 'Display gradient directions';
disp_grad.tag  = 'dti_disp_grad';
disp_grad.val  = {srcimgs option axbgcol fgbgcol res};
disp_grad.prog = @dti_disp_grad;
disp_grad.help = vgtbx_help2cell('dti_disp_grad');


%-Helpers
%=======================================================================
refimage.type = 'const';
refimage.name = 'Image';
refimage.tag  = 'refimage';
refimage.val  = {1};

refscanner.type = 'const';
refscanner.name = 'Scanner';
refscanner.tag  = 'refscanner';
refscanner.val  = {1};

refsnparams = snparams;
refsnparams.name = 'Normalised';
refsnparams.num = [1 1];

ref.type = 'choice';
ref.name = 'Reference coordinate system';
ref.tag  = 'ref';
ref.values = {refimage, refscanner, refsnparams};

saveinf.type = 'menu';
saveinf.name = 'Save gradient information to .txt file';
saveinf.tag  = 'saveinf';
saveinf.labels = {'Yes','No'};
saveinf.values = {1,0};
saveinf.def  = 'tools.vgtbx_Diffusion.extract_dirs.saveinf';

extract_dirs.type = 'branch';
extract_dirs.name = 'Extract DW information (gradients & dirs)';
extract_dirs.tag  = 'dti_extract_dirs';
extract_dirs.val  = {srcimgs ref saveinf sep ltol dtol};
extract_dirs.prog = @dti_extract_dirs;
extract_dirs.help = vgtbx_help2cell('dti_extract_dirs');

%-Simulations
%=======================================================================

% Simulate tensors
%-----------------------------------------------------------------------

lina.type    = 'entry';
lina.name    = 'Line slope';
lina.tag     = 'a';
lina.strtype = 'e';
lina.num     = [Inf Inf];
lina.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.a';
lina.help    = {['The interpretation of this parameter varies with its ' ...
                 'size. It can be'], ...
                ['1-by-1, 1-by-size(t,2): one line, with possibly changing ' ...
                 'parameter value over the line.'], ...
                ['M-by-1, M-by-size(t,2): multiple lines with different ' ...
                 'settings of this parameter. All combinations of all ' ...
                  'parameters of the line function will be computed.']};

amp.type    = 'entry';
amp.name    = 'Amplitude';
amp.tag     = 'r';
amp.strtype = 'e';
amp.num     = [Inf Inf];
amp.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.r';
amp.help    = {['The interpretation of this parameter varies with its ' ...
                 'size. It can be'], ...
                ['1-by-1, 1-by-size(t,2): one line, with possibly changing ' ...
                 'parameter value over the line.'], ...
                ['M-by-1, M-by-size(t,2): multiple lines with different ' ...
                 'settings of this parameter. All combinations of all ' ...
                  'parameters of the line function will be computed.']};

freq.type    = 'entry';
freq.name    = 'Frequency';
freq.tag     = 'f';
freq.strtype = 'e';
freq.num     = [Inf Inf];
freq.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.f';
freq.help    = {['The interpretation of this parameter varies with its ' ...
                 'size. It can be'], ...
                ['1-by-1, 1-by-size(t,2): one line, with possibly changing ' ...
                 'parameter value over the line.'], ...
                ['M-by-1, M-by-size(t,2): multiple lines with different ' ...
                 'settings of this parameter. All combinations of all ' ...
                  'parameters of the line function will be computed.']};

phase.type    = 'entry';
phase.name    = 'Phase';
phase.tag     = 'ph';
phase.strtype = 'e';
phase.num     = [Inf Inf];
phase.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.ph';
phase.help    = {['The interpretation of this parameter varies with its ' ...
                 'size. It can be'], ...
                ['1-by-1, 1-by-size(t,2): one line, with possibly changing ' ...
                 'parameter value over the line.'], ...
                ['M-by-1, M-by-size(t,2): multiple lines with different ' ...
                 'settings of this parameter. All combinations of all ' ...
                  'parameters of the line function will be computed.']};

offset.type    = 'entry';
offset.name    = 'Offset';
offset.tag     = 'off';
offset.strtype = 'e';
offset.num     = [Inf Inf];
offset.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.off';
offset.help    = {['The interpretation of this parameter varies with its ' ...
                 'size. It can be'], ...
                ['1-by-1, 1-by-size(t,2): one line, with possibly changing ' ...
                 'parameter value over the line.'], ...
                ['M-by-1, M-by-size(t,2): multiple lines with different ' ...
                 'settings of this parameter. All combinations of all ' ...
                  'parameters of the line function will be computed.']};

linear.type  = 'branch';
linear.tag   = 'linear';
linear.name  = 'Linear: f(t) = a*t + off';
linear. val  = {lina,offset};

tanhp.type  = 'branch';
tanhp.tag   = 'tanhp';
tanhp.name  = 'Tanh: f(t) = tanh(f*t + ph) + off';
tanhp. val  = {amp, freq, phase, offset};

sinp.type  = 'branch';
sinp.tag   = 'sinp';
sinp.name  = 'Sin: f(t) = sin(f*t + ph) + off';
sinp. val  = {amp, freq, phase, offset};

data.type    = 'entry';
data.name    = 'Coordinate points';
data.tag     = 'data';
data.strtype = 'e';
data.num     = [Inf Inf];
data.help    = {'A #lines-by-size(t,2) array of data points.'};

ffun.type   = 'choice';
ffun.values = {data,linear,tanhp,sinp};
ffun.help   = {['Specification of fibers. Each fiber is parameterised by ' ...
                'three functions x(t), y(t) and z(t). All combinations of ' ...
                'x-, y- and z-line functions are computed.']};

fxfun = ffun;
fxfun.name = 'Line function (X)';
fxfun.tag  = 'fxfun';

fyfun = ffun;
fyfun.name = 'Line function (Y)';
fyfun.tag  = 'fyfun';

fzfun = ffun;
fzfun.name = 'Line function (Z)';
fzfun.tag  = 'fzfun';

t.type    = 'entry';
t.name    = 'Parametrisation points for line';
t.tag     = 't';
t.strtype = 'e';
t.num     = [1 Inf];
t.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.t';

iso.type    = 'entry';
iso.name    = 'Ratio of isotropic diffusion';
iso.tag     = 'iso';
iso.strtype = 'e';
iso.num     = [1 1];
iso.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.iso';

fwhm.type    = 'entry';
fwhm.name    = 'Exponential decay of non-isotropic diffusion';
fwhm.tag     = 'fwhm';
fwhm.strtype = 'e';
fwhm.num     = [1 1];
fwhm.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.fwhm';

D.type    = 'entry';
D.name    = 'Diffusion coefficient';
D.tag     = 'D';
D.strtype = 'e';
D.num     = [1 1];
D.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.D';

lines.type = 'branch';
lines.name = 'Line specification';
lines.tag  = 'lines';
lines.val  = {fxfun fyfun fzfun t iso fwhm D};

alllines.type   = 'repeat';
alllines.name   = 'Line specifications';
alllines.tag    = 'alllines';
alllines.num    = [1 Inf];
alllines.values = {lines};

fname = prefix;

dim.type    = 'entry';
dim.name    = 'Output image dimensions';
dim.tag     = 'dim';
dim.strtype = 'n';
dim.num     = [1 3];
dim.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.dim';

res.def  = 'tools.vgtbx_Diffusion.dti_dw_generate.res';

movprms.type    = 'entry';
movprms.name    = 'Movement parameters';
movprms.tag     = 'movprms';
movprms.strtype = 'e';
movprms.num     = [Inf 6];
movprms.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.movprms';
movprms.help    = {['Enter a 1-by-6 or #directions-by-6 array of movement ' ...
                    'parameters to simulate phantom movement. Images will '...
                    'be simulated in transversal orientation, but the ' ...
                    'phantom may move in and out the initial bounding ' ...
                    'box.']};
                   
b.type    = 'entry';
b.name    = 'B value';
b.tag     = 'b';
b.strtype = 'e';
b.num     = [1 1];
b.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.b';

i0.type    = 'entry';
i0.name    = 'B0 intensity';
i0.tag     = 'i0';
i0.strtype = 'e';
i0.num     = [1 1];
i0.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.i0';

nr.type    = 'entry';
nr.name    = 'B0 noise ratio';
nr.tag     = 'nr';
nr.strtype = 'e';
nr.num     = [1 1];
nr.def     = 'tools.vgtbx_Diffusion.dti_dw_generate.nr';

dw_generate.type = 'branch';
dw_generate.name = 'Generate diffusion weighted images';
dw_generate.tag  = 'dti_dw_generate';
dw_generate.val  = {alllines fname swd dim res movprms b i0 nr};
dw_generate.prog = @dti_dw_generate;
dw_generate.vfiles = dti_dw_generate('vfiles');
dw_generate.help = vgtbx_help2cell('dti_dw_generate');

%-Main menu level
%=======================================================================
opt.type = 'repeat';
opt.name = 'Diffusion toolbox';
opt.tag  = 'vgtbx_Diffusion';
opt.values = {init_dti_data realign reorient_gradient adc dt_adc dt_regress ...
              warp_tensors dt_eig indices saliencies disp_grad extract_dirs hosvd recalc ...
              dw_generate dt_time3 dt_tracepath};
opt.num  = [0 Inf];
opt.help = vgtbx_help2cell(mfilename);

%-Add defaults
%=======================================================================
global defaults;
% Nearest Neighbour interpolation
%-----------------------------------------------------------------------
defaults.tools.vgtbx_Diffusion.interp = 0;
defaults.tools.vgtbx_Diffusion.extract_dirs.saveinf = 0;
defaults.tools.vgtbx_Diffusion.extract_dirs.sep = 1;
defaults.tools.vgtbx_Diffusion.extract_dirs.ltol = 10;
defaults.tools.vgtbx_Diffusion.extract_dirs.dtol = .95;
defaults.tools.vgtbx_Diffusion.dti_dt_regress.sep = 0;
defaults.tools.vgtbx_Diffusion.dti_dt_regress.ltol = 10;
defaults.tools.vgtbx_Diffusion.dti_dt_regress.dtol = 0;
defaults.tools.vgtbx_Diffusion.dti_dt_regress.spatsm = 0;
defaults.tools.vgtbx_Diffusion.dti_disp_grad.axbgcol = [0 0 0];
defaults.tools.vgtbx_Diffusion.dti_disp_grad.fgbgcol = [.2 .2 .2];
defaults.tools.vgtbx_Diffusion.dti_disp_grad.res = 100;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.dim = [Inf Inf Inf];
defaults.tools.vgtbx_Diffusion.dti_dw_generate.res = .2;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.movprms = [0 0 0 0 0 0];
defaults.tools.vgtbx_Diffusion.dti_dw_generate.b   = 750;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.i0  = 400;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.D   = 4e-3;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.nr  = .1;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.t   = 1:10;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.iso = .1;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.fwhm= 3;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.a   = 0;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.r   = 1;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.f   = 1;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.ph  = 0;
defaults.tools.vgtbx_Diffusion.dti_dw_generate.off = 0;
defaults.tools.vgtbx_Diffusion.dti_reorient_gradient.useaff.rot   = 1;
defaults.tools.vgtbx_Diffusion.dti_reorient_gradient.useaff.zoom  = 1;
defaults.tools.vgtbx_Diffusion.dti_reorient_gradient.useaff.shear = 0;

if nargout > 0
        varargout{1}=opt;
end;

% vfiles functions
%=======================================================================

function vfiles = vfiles_dti_classify(job)
vfiles={};
if ~isempty(job.e1img)
        [p n e v] = fileparts(job.e1img{1});
        vfiles{1} = fullfile(p, [job.prefix n e v]);
end;

function vfiles = vfiles_dti_compare(job)
vfiles={};
if ~isempty(job.dtimg)
        [p n e v] = fileparts(job.dtimg{1});
        for k = 1:6
                vfiles{k} = fullfile(p,[job.prefix sprintf('%02d_',k+3) n e v]);
        end;
end;

function vfiles = vfiles_dti_evec_rot(job)
vfiles={};
for k = 1:numel(job.e1img)
        [p n e v] = fileparts(job.e1img{k});
        vfiles{k} = fullfile(p, ['adc_' n e v]);
end;

function vfiles = vfiles_dti_adc(job)
vfiles={};
for k = 1:numel(job.files1)
        [p n e v] = fileparts(job.files1{k});
        vfiles{k} = fullfile(p, ['adc_' n e v]);
end;

function vfiles = vfiles_dti_dt_adc(job)
vfiles={};
if ~isempty(job.files)
        [p n e v]=fileparts(job.files{1});
        if n(1:4) == 'adc_'
                n=n(5:end);
        end;
        dirs={'xx','xy','xz','yy','yz','zz'};
        for k=1:6
                vfiles{k} = fullfile(p, sprintf('D%s_%s%s%s',dirs{k}, n, e, v));
        end;
end;

function vfiles = vfiles_dti_reorient_gradient(job)
vfiles = job.tgtimgs;

function vfiles = vfiles_dti_dt_regress(job)
persistent dtorder Hind mult fdirs
vfiles=cell(1,(job.dtorder+1)*(job.dtorder+2)/2+1);
cswd = spm_select('cpath',job.swd{1});
vfiles{end}=fullfile(cswd,'SPM.mat');
% get beta filename stub
[p betafname e v] = fileparts(job.srcimgs{1});
if isempty(dtorder) || (dtorder ~= job.dtorder)
    dirs = 'xyz';
    [Hind mult] = dti_dt_order(job.dtorder);
    dtorder = job.dtorder;
    for j=1:(job.dtorder+1)*(job.dtorder+2)/2
        fdirs{j}=dirs(Hind(:,j));
    end;
end;
for j=1:(job.dtorder+1)*(job.dtorder+2)/2
        vfiles{j}=fullfile(cswd,...
                               sprintf('D%s_%s.img,1',...
                                       fdirs{j},betafname));
end;

% mean regressor included by spm_config_factorial design.m
vfiles{end+1} = fullfile(cswd,sprintf('lnA0_%s.img,1', betafname));

function vfiles = vfiles_dti_eig(job)
vfiles={};
[p n e v]=fileparts(job.dtimg{1});
    
if ~isempty(regexp(n,'^((dt[1-6])|(D[x-z][x-z]))_.*'))
        n = n(5:end);
end;
    
cdir=['x','y','z'];
  
if any (job.dteigopts=='v')
        for j=1:3
                for k=1:3
                        vfiles{end+1} = ...
                            fullfile(p, ...
                                     [sprintf('evec%d%s_',k,cdir(j)) n e v]);
                end;
        end;
end;
if any(job.dteigopts=='l')
        for j=1:3
                vfiles{end+1} = fullfile(p,[sprintf('eval%d_',j) n e v]);
        end;
end;
if any(job.dteigopts=='a')
        for j=1:3
                vfiles{end+1} = fullfile(p,[sprintf('euler%d_',j) n e v]);
        end;
end;

function vfiles = vfiles_dti_indices(job)
vfiles={};
[p n e v]=fileparts(job.dtimg{1});
    
if ~isempty(regexp(n,'^((dt[1-6])|(D[x-z][x-z]))_.*'))
        n = n(5:end);
end;
    
if any (job.option=='f')
        vfiles{end+1} = fullfile(p,['fa_' n e v]);
end;
if any (job.option=='v')
        vfiles{end+1} = fullfile(p,['va_' n e v]);
end;
if any (job.option=='d')
        vfiles{end+1} = fullfile(p,['ad_' n e v]);
end;

function vfiles = vfiles_dti_saliencies(job)
[p n e v]=fileparts(job.limg{1});
    
if length(n)>6 & n(1:4) == 'eval' 
        n=n(7:end);
end;
    
vfiles{1} = fullfile(p,['sc_' n e v]);
vfiles{2} = fullfile(p,['sp_' n e v]);
vfiles{3} = fullfile(p,['ss_' n e v]);

function vfiles = vfiles_dti_hosvd(job)
vfiles = {};
for k=1:numel(job.dtimg)
        [p n e v] = fileparts(job.dtimg{k});
        if n(1)=='D'
                n(1)='S';
        else
                n = ['S' n];
        end;
        vfiles{end+1} = fullfile(p, [n e v]);
end;
[p n e v] = fileparts(job.dtimg{1});
if ~isempty(regexp(n, sprintf('^D%s_.*', repmat('[x-z]',1,job.dtorder))))
        n = n(job.dtorder+2:end);
end;
for k=1:3
        for l=1:3
                vfiles{end+1} = fullfile(p, [sprintf('U%d%s_%s',l,dirs(k),n) e v]);
        end;
end;

function vfiles = vfiles_dti_dt_time3(job)
vfiles = {};
return;
% Currently unused 
function str = check_dti_reorient_gradient(job)
if numel(job.srcimgs) ~= numel(job.tgtimgs)
    str = '# source images must match # target images.';
else
    str = '';
end;
return;
