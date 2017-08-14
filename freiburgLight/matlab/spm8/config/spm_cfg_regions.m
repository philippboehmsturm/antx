function regions = spm_cfg_regions
% This function is deprecated and will be removed from future releases of
% SPM(Freiburg). Please use "Batch->Util->Volume of Interest" instead.

% 'VOI extraction (eigenvariate)' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2009-04-28 13:15:17.
% ---------------------------------------------------------------------
% spmmat Select SPM.mat
% ---------------------------------------------------------------------
spmmat         = cfg_files;
spmmat.tag     = 'spmmat';
spmmat.name    = 'Select SPM.mat';
spmmat.help    = {'Select the SPM.mat file that contains the design specification.'};
spmmat.filter = 'mat';
spmmat.ufilter = '^SPM\.mat$';
spmmat.num     = [1 1];
% ---------------------------------------------------------------------
% contrasts Contrast
% ---------------------------------------------------------------------
contrasts         = cfg_entry;
contrasts.tag     = 'contrasts';
contrasts.name    = 'Contrast';
contrasts.check   = @(job)spm_run_regions('check','contrasts',job);
contrasts.help    = {'Index of contrast(s). If more than one number is entered, analyse a conjunction hypothesis.'};
contrasts.strtype = 'n';
contrasts.num     = [1  Inf];
% ---------------------------------------------------------------------
% threshdesc Threshold type
% ---------------------------------------------------------------------
threshdesc         = cfg_menu;
threshdesc.tag     = 'threshdesc';
threshdesc.name    = 'Threshold type';
threshdesc.val     = {'FWE'};
threshdesc.labels = {
                     'FWE'
                     'none'
                     }';
threshdesc.values = {
                     'FWE'
                     'none'
                     }';
% ---------------------------------------------------------------------
% thresh Threshold
% ---------------------------------------------------------------------
thresh         = cfg_entry;
thresh.tag     = 'thresh';
thresh.name    = 'Threshold';
thresh.val     = {0.05};
thresh.strtype = 'r';
thresh.num     = [1  1];
% ---------------------------------------------------------------------
% extent Extent
% ---------------------------------------------------------------------
extent         = cfg_entry;
extent.tag     = 'extent';
extent.name    = 'Extent';
extent.val     = {0};
extent.strtype = 'w';
extent.num     = [1  1];
% ---------------------------------------------------------------------
% contrasts Contrast(s) for Masking
% ---------------------------------------------------------------------
contrasts1         = cfg_entry;
contrasts1.tag     = 'contrasts';
contrasts1.name    = 'Contrast(s) for Masking';
contrasts1.check   = @(job)spm_run_regions('check','contrasts',job);
contrasts1.help    = {'Index of contrast(s) for masking - leave empty for no masking.'};
contrasts1.strtype = 'n';
contrasts1.num     = [1  Inf];
% ---------------------------------------------------------------------
% thresh Mask threshold
% ---------------------------------------------------------------------
thresh1         = cfg_entry;
thresh1.tag     = 'thresh';
thresh1.name    = 'Mask threshold';
thresh1.val     = {0.05};
thresh1.strtype = 'r';
thresh1.num     = [1  1];
% ---------------------------------------------------------------------
% mtype Nature of mask
% ---------------------------------------------------------------------
mtype         = cfg_menu;
mtype.tag     = 'mtype';
mtype.name    = 'Nature of mask';
mtype.labels = {
                'Inclusive'
                'Exclusive'
                }';
mtype.values = {
                0
                1
                }';
% ---------------------------------------------------------------------
% mask Mask definition
% ---------------------------------------------------------------------
mask         = cfg_branch;
mask.tag     = 'mask';
mask.name    = 'Mask definition';
mask.val     = {contrasts1 thresh1 mtype };
% ---------------------------------------------------------------------
% masking Masking
% ---------------------------------------------------------------------
masking         = cfg_repeat;
masking.tag     = 'masking';
masking.name    = 'Masking';
masking.values  = {mask };
masking.num     = [0 1];
% ---------------------------------------------------------------------
% conspec Contrast query
% ---------------------------------------------------------------------
conspec         = cfg_branch;
conspec.tag     = 'conspec';
conspec.name    = 'Contrast query';
conspec.val     = {contrasts threshdesc thresh extent masking };
% ---------------------------------------------------------------------
% inmask All inmask voxels
% ---------------------------------------------------------------------
inmask         = cfg_const;
inmask.tag     = 'inmask';
inmask.name    = 'All inmask voxels';
inmask.val = {true};
inmask.help    = {'Extract data from all inmask voxels that fall into the VOI.'};
% ---------------------------------------------------------------------
% smask Data source&mask
% ---------------------------------------------------------------------
smask         = cfg_choice;
smask.tag     = 'smask';
smask.name    = 'Data source&mask';
smask.help    = {'Data can be extracted from voxels surviving a certain analysis threshold (as in the SPM GUI) or from all inmask voxels.'};
smask.values  = {conspec inmask };
% ---------------------------------------------------------------------
% srcspm Source SPM
% ---------------------------------------------------------------------
srcspm         = cfg_branch;
srcspm.tag     = 'srcspm';
srcspm.name    = 'Source SPM';
srcspm.val     = {spmmat smask };
srcspm.check   = @(job)spm_run_regions('check','srcspm',job);
% ---------------------------------------------------------------------
% xyz centre of VOI {mm}
% ---------------------------------------------------------------------
xyz         = cfg_entry;
xyz.tag     = 'xyz';
xyz.name    = 'centre of VOI {mm}';
xyz.help    = {'Enter the coordinates of the centre of the VOI to be extracted.'};
xyz.strtype = 'r';
xyz.num     = [3  1];
% ---------------------------------------------------------------------
% name Name of VOI
% ---------------------------------------------------------------------
name         = cfg_entry;
name.tag     = 'name';
name.name    = 'Name of VOI';
name.help    = {'A label for this VOI.'};
name.strtype = 's';
name.num     = [1  Inf];
% ---------------------------------------------------------------------
% Ic Contrast# used to adjust data
% ---------------------------------------------------------------------
Ic         = cfg_entry;
Ic.tag     = 'Ic';
Ic.name    = 'Contrast# used to adjust data';
Ic.help    = {
              'The data can be adjusted w.r.t. a (pre-defined) F contrast to remove signal that is modelled by the reduced design of this contrast.'
              'Enter zero (0) for no adjustment or the index number of the desired F contrast.'
              }';
Ic.strtype = 'w';
Ic.num     = [1  1];
% ---------------------------------------------------------------------
% Sess Session index
% ---------------------------------------------------------------------
Sess         = cfg_entry;
Sess.tag     = 'Sess';
Sess.name    = 'Session index';
Sess.help    = {'Enter the Session# for which to extract data.'};
Sess.strtype = 'n';
Sess.num     = [1  1];
% ---------------------------------------------------------------------
% sphere Sphere: VOI radius {mm}
% ---------------------------------------------------------------------
sphere         = cfg_entry;
sphere.tag     = 'sphere';
sphere.name    = 'Sphere: VOI radius {mm}';
sphere.help    = {'Enter the radius of the sphere in mm units.'};
sphere.strtype = 'r';
sphere.num     = [1  1];
% ---------------------------------------------------------------------
% box Box: VOI dimensions [x y z] {mm}
% ---------------------------------------------------------------------
box         = cfg_entry;
box.tag     = 'box';
box.name    = 'Box: VOI dimensions [x y z] {mm}';
box.help    = {''};
box.strtype = 'r';
box.num     = [3  1];
% ---------------------------------------------------------------------
% mask Mask: VOI image
% ---------------------------------------------------------------------
mask         = cfg_files;
mask.tag     = 'mask';
mask.name    = 'Mask: VOI image';
mask.filter = 'image';
mask.ufilter = '.*';
mask.num     = [1 1];
% ---------------------------------------------------------------------
% cluster Cluster: VOI in current cluster
% ---------------------------------------------------------------------
cluster         = cfg_const;
cluster.tag     = 'cluster';
cluster.name    = 'Cluster: VOI in current cluster';
cluster.val = {true};
cluster.help    = {'The VOI will include all voxels in the cluster at the VOI centre as defined by the current results query.'};
% ---------------------------------------------------------------------
% voi VOI type
% ---------------------------------------------------------------------
voi         = cfg_choice;
voi.tag     = 'voi';
voi.name    = 'VOI type';
voi.help    = {'Data will be extracted from all voxels that are in the defined VOI and also belong to the supra-threshold or inmask voxels of the choosen SPM result.'};
voi.values  = {sphere box mask cluster };
% ---------------------------------------------------------------------
% xY VOI specification
% ---------------------------------------------------------------------
xY         = cfg_branch;
xY.tag     = 'xY';
xY.name    = 'VOI specification';
xY.val     = {xyz name Ic Sess voi };
% ---------------------------------------------------------------------
% xYs VOI specifications
% ---------------------------------------------------------------------
xYs         = cfg_repeat;
xYs.tag     = 'xYs';
xYs.name    = 'VOI specifications';
xYs.values  = {xY };
xYs.num     = [1 Inf];
% ---------------------------------------------------------------------
% regions VOI extraction (eigenvariate)
% ---------------------------------------------------------------------
regions         = cfg_exbranch;
regions.tag     = 'regions';
regions.name    = 'VOI extraction (eigenvariate)';
regions.val     = {srcspm xYs };
regions.help    = {'This function is deprecated and will be removed from future releases of SPM(Freiburg). Please use "Batch->Util->Volume of Interest" instead.',...
                   'Extract filtered&adjusted eigenvariate data (as returned by spm_regions) from one or more ROIs in a SPM analysis.'};
regions.prog = @(job)spm_run_regions('run',job);
regions.vout = @(job)spm_run_regions('vout',job);
regions.hidden = true;