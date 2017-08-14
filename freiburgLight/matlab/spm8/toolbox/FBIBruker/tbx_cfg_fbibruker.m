function bruker2nifti = tbx_cfg_fbibruker
% 'Convert Bruker to NIfTI' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2011-01-14 15:10:56.

if ~isdeployed
    addpath(fileparts(mfilename('fullpath')));
end

% ---------------------------------------------------------------------
% infiles Bruker 2dseq File
% ---------------------------------------------------------------------
infiles         = cfg_files;
infiles.tag     = 'infiles';
infiles.name    = 'Bruker 2dseq File';
infiles.help    = {'Enter the name of a Bruker 2dseq file. All information will be read from this file and its accompanying header files.'};
infiles.filter = '.*';
infiles.ufilter = '2dseq';
infiles.num     = [1 Inf];
% ---------------------------------------------------------------------
% outdir Output Directory
% ---------------------------------------------------------------------
outdir         = cfg_files;
outdir.tag     = 'outdir';
outdir.name    = 'Output Directory';
outdir.help    = {'Enter the directory where converted files should be placed.'};
outdir.filter = 'dir';
outdir.ufilter = '.*';
outdir.num     = [1 1];
% ---------------------------------------------------------------------
% newsubdir New Subdirectory Name
% ---------------------------------------------------------------------
newsubdir         = cfg_entry;
newsubdir.tag     = 'newsubdir';
newsubdir.name    = 'New Subdirectory Name';
newsubdir.help    = {'Enter the name of the subdirectory.'};
newsubdir.strtype = 's';
newsubdir.num     = [1  Inf];
% ---------------------------------------------------------------------
% usefilepath Generate from File Path
% ---------------------------------------------------------------------
usefilepath         = cfg_const;
usefilepath.tag     = 'usefilepath';
usefilepath.name    = 'Generate from File Path';
usefilepath.val = {true};
usefilepath.help    = {'Place files in the selected directory, do not create a new subdirectory.'};
% ---------------------------------------------------------------------
% useoutdir Use selected Output Directory
% ---------------------------------------------------------------------
useoutdir         = cfg_const;
useoutdir.tag     = 'useoutdir';
useoutdir.name    = 'Use selected Output Directory';
useoutdir.val = {true};
useoutdir.help    = {'Place files in the selected directory, do not create a new subdirectory.'};
% ---------------------------------------------------------------------
% createsubdir Create new Output Directory?
% ---------------------------------------------------------------------
createsubdir         = cfg_choice;
createsubdir.tag     = 'createsubdir';
createsubdir.name    = 'Create new Output Directory?';
createsubdir.values  = {newsubdir usefilepath useoutdir };
% ---------------------------------------------------------------------
% dt NIfTI Image Datatype
% ---------------------------------------------------------------------
dt         = cfg_menu;
dt.tag     = 'dt';
dt.name    = 'NIfTI Image Datatype';
dt.labels = arrayfun(@spm_type,spm_type','uniformoutput',false);
dt.values = arrayfun(@spm_type,spm_type','uniformoutput',false);
% ---------------------------------------------------------------------
% bruker2nifti Convert Bruker to NIfTI
% ---------------------------------------------------------------------
bruker2nifti         = cfg_exbranch;
bruker2nifti.tag     = 'bruker2nifti';
bruker2nifti.name    = 'Convert Bruker to NIfTI';
bruker2nifti.val     = {infiles outdir createsubdir dt };
bruker2nifti.prog = @(job)tbx_fbi_bruker2nifti('run',job);
bruker2nifti.vout = @(job)tbx_fbi_bruker2nifti('vout',job);
