function check_reg_adv = spm_cfg_check_reg_adv
% 'Check Reg (Advanced)' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2011-02-25 15:53:56.
% ---------------------------------------------------------------------
% fname Image file
% ---------------------------------------------------------------------
fname         = cfg_files;
fname.tag     = 'fname';
fname.name    = 'Image file';
fname.help    = {'The background image to be displayed.'};
fname.filter = 'image';
fname.ufilter = '.*';
fname.num     = [1 1];
% ---------------------------------------------------------------------
% manual Manual
% ---------------------------------------------------------------------
manual         = cfg_entry;
manual.tag     = 'manual';
manual.name    = 'Manual';
manual.help    = {'Enter minimum and maximum intensity.'};
manual.strtype = 'r';
manual.num     = [1  2];
% ---------------------------------------------------------------------
% auto Automatic
% ---------------------------------------------------------------------
auto         = cfg_const;
auto.tag     = 'auto';
auto.name    = 'Automatic';
auto.val     = {true};
auto.help    = {'Automatic windowing.'};
% ---------------------------------------------------------------------
% window Window
% ---------------------------------------------------------------------
window         = cfg_choice;
window.tag     = 'window';
window.name    = 'Window';
window.help    = {'Restrict intensities in images.'};
window.values  = {manual auto };
% ---------------------------------------------------------------------
% mapping Intensity mapping
% ---------------------------------------------------------------------
mapping         = cfg_menu;
mapping.tag     = 'mapping';
mapping.name    = 'Intensity mapping';
mapping.help    = {'The mapping from voxel values to image intensities.'};
mapping.labels  = {
                   'Linear'
                   'Equalised Histogram'
                   'Equalised log-Histogram'
                   'Equalised squared Histogram'
                  }';
mapping.values  = {
                   'linear'
                   'histeq'
                   'loghisteq'
                   'quadhisteq'
                  }';
% ---------------------------------------------------------------------
% image Image(s)
% ---------------------------------------------------------------------
image         = cfg_files;
image.tag     = 'image';
image.name    = 'Image(s)';
image.help    = {'Blob data will be read from these images. If more than one image is specified, one blob will be added per image. Additional settings (colour, window etc) will be the same for all of these blobs.'};
image.filter = 'image';
image.ufilter = '.*';
image.num     = [1 Inf];
% ---------------------------------------------------------------------
% bsource Blob source
% ---------------------------------------------------------------------
bsource         = cfg_choice;
bsource.tag     = 'bsource';
bsource.name    = 'Blob source';
bsource.help    = {'This is a placeholder. Additional blob sources (e.g. SPM.mat) should be added here.'};
bsource.values  = {image };
% ---------------------------------------------------------------------
% manual Manual
% ---------------------------------------------------------------------
manual         = cfg_entry;
manual.tag     = 'manual';
manual.name    = 'Manual';
manual.help    = {'Enter minimum and maximum intensity.'};
manual.strtype = 'r';
manual.num     = [1  2];
% ---------------------------------------------------------------------
% auto Automatic
% ---------------------------------------------------------------------
auto         = cfg_const;
auto.tag     = 'auto';
auto.name    = 'Automatic';
auto.val     = {true};
auto.help    = {'Automatic windowing.'};
% ---------------------------------------------------------------------
% window Window
% ---------------------------------------------------------------------
window1         = cfg_choice;
window1.tag     = 'window';
window1.name    = 'Window';
window1.help    = {'Restrict intensities in images.'};
window1.values  = {manual auto };
% ---------------------------------------------------------------------
% colour Colour
% ---------------------------------------------------------------------
colour         = cfg_entry;
colour.tag     = 'colour';
colour.name    = 'Colour';
colour.help    = {'Enter the colour for this blob as RGB triplet.'};
colour.strtype = 'r';
colour.num     = [1  3];
% ---------------------------------------------------------------------
% cblob Coloured Blob
% ---------------------------------------------------------------------
cblob         = cfg_branch;
cblob.tag     = 'cblob';
cblob.name    = 'Coloured Blob';
cblob.val     = {bsource window1 colour };
% ---------------------------------------------------------------------
% cblobs Coloured Blob Set
% ---------------------------------------------------------------------
cblobs         = cfg_repeat;
cblobs.tag     = 'cblobs';
cblobs.name    = 'Coloured Blob Set';
cblobs.help    = {'Enter one or more sources for coloured blobs.'};
cblobs.values  = {cblob };
cblobs.num     = [1 Inf];
% ---------------------------------------------------------------------
% image Image(s)
% ---------------------------------------------------------------------
image         = cfg_files;
image.tag     = 'image';
image.name    = 'Image(s)';
image.help    = {'Blob data will be read from these images. If more than one image is specified, one blob will be added per image. Additional settings (colour, window etc) will be the same for all of these blobs.'};
image.filter  = 'image';
image.ufilter = '.*';
image.num     = [1 Inf];
% ---------------------------------------------------------------------
% bsource Blob source
% ---------------------------------------------------------------------
bsource         = cfg_choice;
bsource.tag     = 'bsource';
bsource.name    = 'Blob source';
bsource.help    = {'This is a placeholder. Additional blob sources (e.g. SPM.mat) should be added here.'};
bsource.values  = {image };
% ---------------------------------------------------------------------
% manual Manual
% ---------------------------------------------------------------------
manual         = cfg_entry;
manual.tag     = 'manual';
manual.name    = 'Manual';
manual.help    = {'Enter minimum and maximum intensity.'};
manual.strtype = 'r';
manual.num     = [1  2];
% ---------------------------------------------------------------------
% auto Automatic
% ---------------------------------------------------------------------
auto         = cfg_const;
auto.tag     = 'auto';
auto.name    = 'Automatic';
auto.val     = {true};
auto.help    = {'Automatic windowing.'};
% ---------------------------------------------------------------------
% window Window
% ---------------------------------------------------------------------
window1         = cfg_choice;
window1.tag     = 'window';
window1.name    = 'Window';
window1.help    = {'Restrict intensities in images.'};
window1.values  = {manual auto };
% ---------------------------------------------------------------------
% blob Colourmapped Blob
% ---------------------------------------------------------------------
blob         = cfg_branch;
blob.tag     = 'blob';
blob.name    = 'Colourmapped Blob';
blob.val     = {bsource window1 };
% ---------------------------------------------------------------------
% none None
% ---------------------------------------------------------------------
none         = cfg_const;
none.tag     = 'none';
none.name    = 'None';
none.val     = {true};
none.help    = {'Don''t add blobs.'};
% ---------------------------------------------------------------------
% blobs Blobs
% ---------------------------------------------------------------------
blobs         = cfg_choice;
blobs.tag     = 'blobs';
blobs.name    = 'Blobs';
blobs.help    = {'Blobs can be added either as single coloured blob sets or as a colormapped blob.'};
blobs.values  = {cblobs blob none };
% ---------------------------------------------------------------------
% imdisp Image Display
% ---------------------------------------------------------------------
imdisp         = cfg_branch;
imdisp.tag     = 'imdisp';
imdisp.name    = 'Image Display';
imdisp.val     = {fname window mapping blobs };
% ---------------------------------------------------------------------
% imdisps Image Displays
% ---------------------------------------------------------------------
imdisps         = cfg_repeat;
imdisps.tag     = 'imdisps';
imdisps.name    = 'Image Displays';
imdisps.values  = {imdisp };
imdisps.num     = [1 15];
% ---------------------------------------------------------------------
% check_reg_adv Check Reg (Advanced)
% ---------------------------------------------------------------------
check_reg_adv         = cfg_exbranch;
check_reg_adv.tag     = 'check_reg_adv';
check_reg_adv.name    = 'Check Reg (Advanced)';
check_reg_adv.val     = {imdisps };
check_reg_adv.help    = {'Configure an image display including blobs.'};
check_reg_adv.prog = @(job)spm_run_check_reg_adv('run',job);
check_reg_adv.vout = @(job)spm_run_check_reg_adv('vout',job);
