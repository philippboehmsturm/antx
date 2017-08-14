function dicom = tbx_cfg_fbi_dicom
% SPM Configuration file
% automatically generated by the MATLABBATCH utility function GENCODE
% Modified version for FBIDicom conversion - needs to be kept in sync
% with spm_cfg_dicom.m
%_______________________________________________________________________
% Copyright (C) 2008 Freiburg Brain Imaging

% $Id: tbx_cfg_fbi_dicom.m,v 1.8 2008-06-02 11:40:50 vglauche Exp $

rev = '$Rev: 1517 $';

% add path to toolbox
p = fileparts(mfilename('fullpath'));
addpath(p);

% ---------------------------------------------------------------------
% files DICOM files
% ---------------------------------------------------------------------
files         = cfg_files;
files.tag     = 'files';
files.name    = 'DICOM files';
files.help    = {'Select the DICOM files to convert.'};
files.filter = '.*';
files.ufilter = '.*';
files.num     = [1 Inf];
% ---------------------------------------------------------------------
% dirs DICOM directory tree(s)
% ---------------------------------------------------------------------
dirs      = cfg_files;
dirs.name = 'DICOM directory tree(s)';
dirs.tag  = 'dirs';
dirs.filter = 'dir';
dirs.num  = [1 Inf];
dirs.help = {['Select the root(s) of the DICOM directory tree(s) to convert. '...
             'The conversion will recursively search each directory for ' ...
             'files to convert.']};
% ---------------------------------------------------------------------
% dicomdirs DICOMDIR files
% ---------------------------------------------------------------------
dicomdirs         = cfg_files;
dicomdirs.tag     = 'dicomdirs';
dicomdirs.name    = 'DICOMDIR files';
dicomdirs.help    = {'Select the DICOMDIR file(s) to read.'};
dicomdirs.filter = '.*';
dicomdirs.ufilter = '^dicomdir$';
dicomdirs.num     = [1 Inf];
% ---------------------------------------------------------------------
% data Select what (files or directories)?
% ---------------------------------------------------------------------
data      = cfg_choice;
data.name = 'Select what (files or directories)?';
data.tag  = 'data';
data.values = {files dirs dicomdirs};
data.help = {['Choose ''DICOM directory tree(s)'' if your DICOM data is organised ' ...
             'in a directory tree. The conversion will then look recursively ' ...
             'in each subdirectory to collect the files.'],...
             'Alternatively, select the individual DICOM files to convert.'};
% ---------------------------------------------------------------------
% root Directory structure for converted files
% ---------------------------------------------------------------------
root         = cfg_menu;
root.tag     = 'root';
root.name    = 'Directory structure for converted files';
root.help    = {
                'Choose root directory of converted file tree. The options are:'
                ''
                '* /projects/<ProjectName>/<StudyDate-StudyTime>: Automatically determine the project name from the DICOM patient name and try to convert into the projects directory.'
                ''
                '* Output directory: ./<ProjectName>/<StudyDate-StudyTime>: Automatically determine the project name and try to convert into the output directory, starting with a ProjectName subdirectory.'
                ''
                '* Output directory: ./<StudyDate-StudyTime>: Automatically determine the project name and try to convert into the output directory, starting with a StudyDate-StudyTime subdirectory. This option is useful if automatic project recognition fails and one wants to convert data into a project directory.'
                ''
                '* Output directory: ./<PatientID>: Convert into the output directory, starting with a PatientID subdirectory.'
                ''
                '* Output directory: ./<PatientName>: Convert into the output directory, starting with a PatientName subdirectory.'
                '* No directory hierarchy: Convert all files into the output directory, without sequence/series subdirectories'
}';
root.labels = {
               'Output directory: ./<StudyDate-StudyTime>/<ProtocolName>'
               'Output directory: ./<PatientID>/<ProtocolName>'
               'Output directory: ./<PatientID>/<StudyDate-StudyTime>/<ProtocolName>'
               'Output directory: ./<PatientName>/<ProtocolName>'
               'Output directory: ./<ProtocolName>'
               'No directory hierarchy'
}';
root.values = {
               'date_time'
               'patid'
               'patid_date'
               'patname'
               'series'
               'flat'
}';
root.def    = @(val)spm_get_defaults('dicom.root', val{:});
% ---------------------------------------------------------------------
% outdir Output directory
% ---------------------------------------------------------------------
outdir         = cfg_files;
outdir.tag     = 'outdir';
outdir.name    = 'Output directory';
outdir.help    = {'Select a directory where files are written. Default is current directory.'};
outdir.filter = 'dir';
outdir.ufilter = '.*';
outdir.num     = [1 1];
% ---------------------------------------------------------------------
% protfilter Protocol name filter
% ---------------------------------------------------------------------
protfilter         = cfg_entry;
protfilter.tag     = 'protfilter';
protfilter.name    = 'Protocol name filter';
protfilter.help    = {'A regular expression to filter protocol names. DICOM images whose protocol names do not match this filter will not be converted.'};
protfilter.strtype = 's';
protfilter.num     = [0 Inf];
protfilter.val     = {'.*'};
% ---------------------------------------------------------------------
% format Output image format
% ---------------------------------------------------------------------
format         = cfg_menu;
format.tag     = 'format';
format.name    = 'Output image format';
format.help    = {
                  'DICOM conversion can create separate img and hdr files or combine them in one file. The single file option will help you save space on your hard disk, but may be incompatible with programs that are not NIfTI-aware.'
                  'In any case, only 3D image files will be produced.'
}';
format.labels = {
                 'Two file (img+hdr) NIfTI'
                 'Single file (nii) NIfTI'
}';
format.values = {
                 'img'
                 'nii'
}';
format.def    = @(val)spm_get_defaults('images.format', val{:});
% ---------------------------------------------------------------------
% icedims Use ICEDims in filename
% ---------------------------------------------------------------------
icedims         = cfg_menu;
icedims.tag     = 'icedims';
icedims.name    = 'Use ICEDims in filename';
icedims.help    = {'If image sorting fails, one can try using the additional SIEMENS ICEDims information to create unique filenames. Use this only if there would be multiple volumes with exactly the same file names.'};
icedims.labels = {
                  'No'
                  'Yes'
}';
icedims.values = {false true};
icedims.val    = {false};
% ---------------------------------------------------------------------
% convopts Conversion options
% ---------------------------------------------------------------------
convopts         = cfg_branch;
convopts.tag     = 'convopts';
convopts.name    = 'Conversion options';
convopts.val     = {format icedims };
convopts.help    = {''};
% ---------------------------------------------------------------------
% dicom DICOM Import
% ---------------------------------------------------------------------
dicom         = cfg_exbranch;
dicom.tag     = 'fbi_dicom';
dicom.name    = 'FBI DICOM Import (SPM)';
dicom.val     = {data root outdir protfilter convopts };
dicom.help    = {'DICOM Conversion.  Most scanners produce data in DICOM format. This routine attempts to convert DICOM files into SPM compatible image volumes, which are written into the current directory by default. Note that not all flavours of DICOM can be handled, as DICOM is a very complicated format, and some scanner manufacturers use their own fields, which are not in the official documentation at http://medical.nema.org/'};
dicom.prog = @tbx_run_fbi_dicom;
dicom.vout = @vout;
% ---------------------------------------------------------------------

% ---------------------------------------------------------------------
function dep = vout(job)
dep            = cfg_dep;
dep.sname      = 'Converted Images';
dep.src_output = substruct('.','files');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});


%% Currently unused configuration for tbxmp_convert_rp
function unused
% ---------------------------------------------------------------------
% srcimg Text file with image comments
% ---------------------------------------------------------------------
srcimg         = cfg_files;
srcimg.tag     = 'srcimg';
srcimg.name    = 'Text file with image comments';
srcimg.help    = {''};
srcimg.filter = '*.txt';
srcimg.ufilter = '.*';
srcimg.num     = [1 1];
% ---------------------------------------------------------------------
% convert_rp Convert realignment parameters
% ---------------------------------------------------------------------
convert_rp         = cfg_exbranch;
convert_rp.tag     = 'convert_rp';
convert_rp.name    = 'Convert realignment parameters';
convert_rp.val     = {srcimg };
convert_rp.help    = {
                      'Import realignment parameters documented by the Freiburg spm_dicom_convert'
                      'FORMAT tbxvol_import_rp(bch)'
                      '======'
                      'Two input files are necessary: one listing the filenames, the other'
                      'listing the image comments'
                      ''
                      'This function is part of the volumes toolbox for SPM5. For general help about this toolbox, bug reports, licensing etc. type'
                      'spm_help vgtbx_config_Volumes'
                      'in the matlab command window after the toolbox has been launched.'
                      '_______________________________________________________________________'
                      ''
                      '@(#) $Id: tbx_cfg_vgtbx_MedPhysConvert.m,v 1.1 2008-04-14 08:53:15 vglauche Exp $'
}';
convert_rp.prog = @tbxmp_convert_rp;