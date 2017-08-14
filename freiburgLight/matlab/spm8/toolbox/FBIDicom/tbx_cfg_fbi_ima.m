function tbx_fbi_ima = tbx_cfg_fbi_ima
% 'Convert .ima to NIfTI' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2009-04-06 21:41:36.
% ---------------------------------------------------------------------
% imaFileList Ima files
% ---------------------------------------------------------------------
imaFileList         = cfg_files;
imaFileList.tag     = 'imaFileList';
imaFileList.name    = 'Ima files';
imaFileList.help    = {'Select the .ima files to be converted. Note that only images of one series can be converted at once (e.g. a single 3D volume or a series of mosaic volumes).'};
imaFileList.filter = '.*\.(ima)|(IMA)$';
imaFileList.ufilter = '.*';
imaFileList.num     = [1 Inf];
% ---------------------------------------------------------------------
% imgFilename Output filename
% ---------------------------------------------------------------------
imgFilename         = cfg_entry;
imgFilename.tag     = 'imgFilename';
imgFilename.name    = 'Output filename';
imgFilename.help    = {'Enter the output filename. If a series of mosaic images is converted, a running index is appended to the filename. If no extension is given or the extension is none of ''.img'' or ''.nii'', the files will be saved as ''.nii''.'};
imgFilename.strtype = 's';
imgFilename.num     = [1  Inf];
% ---------------------------------------------------------------------
% odir Output directory
% ---------------------------------------------------------------------
odir         = cfg_files;
odir.tag     = 'odir';
odir.name    = 'Output directory';
odir.help    = {'The output files will be written to this directory.'};
odir.filter = 'dir';
odir.ufilter = '.*';
odir.num     = [1 1];
% ---------------------------------------------------------------------
% interleaved Interleaved
% ---------------------------------------------------------------------
interleaved         = cfg_menu;
interleaved.tag     = 'interleaved';
interleaved.name    = 'Interleaved';
interleaved.help    = {'Indicate whether the 3D volume was acquired interleaved or not.'};
interleaved.labels = {
                      'No'
                      'Yes'
                      }';
interleaved.values = {
                      false
                      true
                      }';
% ---------------------------------------------------------------------
% tbx_fbi_ima Convert .ima to NIfTI
% ---------------------------------------------------------------------
tbx_fbi_ima         = cfg_exbranch;
tbx_fbi_ima.tag     = 'tbx_fbi_ima';
tbx_fbi_ima.name    = 'Convert .ima to NIfTI';
tbx_fbi_ima.val     = {imaFileList imgFilename odir interleaved };
tbx_fbi_ima.help    = {'This utility tries to convert SIEMENS .ima files into NIfTI images. The code is based on visionToSPM (c) Sebastian Thees, Charite Berlin. There is no guarantee that this program works as expected. The image orientation (especially R-L flips) must be checked by the user.'};
tbx_fbi_ima.prog = @(job)tbx_run_fbi_ima('run',job);
tbx_fbi_ima.vout = @(job)tbx_run_fbi_ima('vout',job);
