function render3D = tbx_cfg_Render3D
% 'Visualisation Utilities' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2008-07-14 14:39:26.
% ---------------------------------------------------------------------
% filemip Source Image
% ---------------------------------------------------------------------
filemip         = cfg_files;
filemip.tag     = 'filemip';
filemip.name    = 'Source Image';
filemip.help    = {'Source image for MIP. Non-NaN voxels in the image will be displayed as MIP. Also, if an image contains only positive voxel values, all zero value voxels will be excluded as well.'};
filemip.filter = 'image';
filemip.ufilter = '.*';
filemip.num     = [1 1];
% ---------------------------------------------------------------------
% Z Z
% ---------------------------------------------------------------------
Z         = cfg_entry;
Z.tag     = 'Z';
Z.name    = 'Z';
Z.help    = {'List of voxel values to be displayed in MIP.'};
Z.strtype = 'e';
Z.num     = [1  Inf];
% ---------------------------------------------------------------------
% XYZ XYZ
% ---------------------------------------------------------------------
XYZ         = cfg_entry;
XYZ.tag     = 'XYZ';
XYZ.name    = 'XYZ';
XYZ.help    = {'List of voxel coordinates in mm (MNI) space.'};
XYZ.strtype = 'e';
XYZ.num     = [3  Inf];
% ---------------------------------------------------------------------
% M M
% ---------------------------------------------------------------------
M         = cfg_entry;
M.tag     = 'M';
M.name    = 'M';
M.help    = {'A 4x4 transformation matrix to transform voxel coordinates into world coordinates.'};
M.strtype = 'e';
M.num     = [4  4];
% ---------------------------------------------------------------------
% spmmip Source Voxel List
% ---------------------------------------------------------------------
spmmip         = cfg_branch;
spmmip.tag     = 'spmmip';
spmmip.name    = 'Source Voxel List';
spmmip.val     = {Z XYZ M };
spmmip.check   = @(subjob)tbxrend_multi_cmip('check','spmmip',subjob);
spmmip.help    = {'Specify a MIP similar to output from e.g. spm_getSPM.'};
% ---------------------------------------------------------------------
% mip MIP Source Type
% ---------------------------------------------------------------------
mip         = cfg_choice;
mip.tag     = 'mip';
mip.name    = 'MIP Source Type';
mip.values  = {filemip spmmip };
% ---------------------------------------------------------------------
% range Range
% ---------------------------------------------------------------------
range         = cfg_entry;
range.tag     = 'range';
range.name    = 'Range';
range.help    = {'Data range to include in MIP projection (min and max). Values outside the range will be treated as missing. Use -Inf or +Inf to set no lower or upper limit. Voxels with exact zero value or NaN will always be treated as missing, regardless of this setting.'};
range.def = @(val)tbxrend_multi_cmip('defaults','range',val{:});
range.strtype = 'r';
range.num     = [1 2];
% ---------------------------------------------------------------------
% bbox Bounding Box
% ---------------------------------------------------------------------
bbox         = cfg_entry;
bbox.tag     = 'bbox';
bbox.name    = 'Bounding Box';
bbox.help    = {'Bounding box to select voxels from (in mm). Enter [xmin ymin zmin; xmax ymax zmax] values. An interval -Inf Inf means no restrictions.'};
bbox.def = @(val)tbxrend_multi_cmip('defaults','bbox',val{:});
bbox.strtype = 'r';
bbox.num     = [2  3];
% ---------------------------------------------------------------------
% colour Colour
% ---------------------------------------------------------------------
colour         = cfg_entry;
colour.tag     = 'colour';
colour.name    = 'Colour';
colour.help    = {'RGB colour for this MIP.'};
colour.def = @(val)tbxrend_multi_cmip('defaults','colour',val{:});
colour.strtype = 'r';
colour.num     = [3  1];
% ---------------------------------------------------------------------
% alpha Opacity
% ---------------------------------------------------------------------
alpha         = cfg_entry;
alpha.tag     = 'alpha';
alpha.name    = 'Opacity';
alpha.help    = {'Minimum and maximum opacity for this MIP.'};
alpha.def = @(val)tbxrend_multi_cmip('defaults','alpha',val{:});
alpha.strtype = 'r';
alpha.num     = [1 2];
% ---------------------------------------------------------------------
% invert Invert Opacity
% ---------------------------------------------------------------------
invert         = cfg_menu;
invert.tag     = 'invert';
invert.name    = 'Invert Opacity';
invert.help    = {'Usually, higher values result in higher opacities. In some cases, the opposite effect is desired.'};
invert.labels  = {
    'No'
    'Yes'
    };
invert.values  = {
    false
    true
    };
invert.def = @(val)tbxrend_multi_cmip('defaults','invert',val{:});
% ---------------------------------------------------------------------
% mips MIP
% ---------------------------------------------------------------------
mips         = cfg_branch;
mips.tag     = 'mips';
mips.name    = 'MIP';
mips.val     = {mip range bbox colour alpha invert};
% ---------------------------------------------------------------------
% unused MIPS
% ---------------------------------------------------------------------
unused         = cfg_repeat;
unused.tag     = 'unused';
unused.name    = 'MIPS';
unused.values  = {mips };
unused.num     = [1 Inf];
% ---------------------------------------------------------------------
% outline Display Outline
% ---------------------------------------------------------------------
outline         = cfg_menu;
outline.tag     = 'outline';
outline.name    = 'Display Outline';
outline.labels  = {
    'No'
    'Yes'
    };
outline.values  = {
    false
    true
    };
outline.def = @(val)tbxrend_multi_cmip('defaults','outline',val{:});
% ---------------------------------------------------------------------
% grid Display Grid
% ---------------------------------------------------------------------
grid         = cfg_menu;
grid.tag     = 'grid';
grid.name    = 'Display Grid';
grid.labels  = {
    'No'
    'Yes'
    };
grid.values  = {
    false
    true
    };
grid.def = @(val)tbxrend_multi_cmip('defaults','grid',val{:});
% ---------------------------------------------------------------------
% bgopts Background Options
% ---------------------------------------------------------------------
bgopts         = cfg_branch;
bgopts.tag     = 'bgopts';
bgopts.name    = 'Background Options';
bgopts.val     = {outline grid};
% ---------------------------------------------------------------------
% units Units
% ---------------------------------------------------------------------
units         = cfg_entry;
units.tag     = 'units';
units.name    = 'Units';
units.check   = @(subjob)tbxrend_multi_cmip('check','units',subjob);
units.def = @(val)tbxrend_multi_cmip('defaults','units',val{:});
units.strtype = 'e';
units.num     = [1  3];
% ---------------------------------------------------------------------
% multi_cmips Coloured MIPs
% ---------------------------------------------------------------------
multi_cmips         = cfg_exbranch;
multi_cmips.tag     = 'multi_cmips';
multi_cmips.name    = 'Coloured MIPs';
multi_cmips.val     = {unused bgopts units };
multi_cmips.help    = {'Overlay one or more MIPs onto the SPM standard glassbrain.'};
multi_cmips.prog = @(job)tbxrend_multi_cmip('run',job);
multi_cmips.vout = @(job)tbxrend_multi_cmip('vout',job);
% ---------------------------------------------------------------------
% render3D Visualisation Utilities
% ---------------------------------------------------------------------
render3D         = cfg_repeat;
render3D.tag     = 'render3D';
render3D.name    = 'Visualisation Utilities';
render3D.help    = {'Various visualisation utilities (not all accessible via GUI).'};
render3D.values  = {multi_cmips };
render3D.num     = [1 Inf];
render3D.forcestruct = true;
% ---------------------------------------------------------------------
% add path to this mfile
% ---------------------------------------------------------------------
addpath(fileparts(mfilename('fullpath')));
