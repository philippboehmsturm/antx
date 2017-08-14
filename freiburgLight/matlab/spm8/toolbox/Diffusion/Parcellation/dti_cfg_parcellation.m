function dti_parcellation = dti_cfg_parcellation
% 'GM Parcellation' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2008-10-23 15:14:28.
% ---------------------------------------------------------------------
% tracts Fibre tract images
% ---------------------------------------------------------------------
tracts         = cfg_files;
tracts.tag     = 'tracts';
tracts.name    = 'Fibre tract images';
tracts.help    = {'Select the tracts as NIfTI images.'};
tracts.filter = 'image';
tracts.ufilter = '.*';
tracts.num     = [1 Inf];
% ---------------------------------------------------------------------
% mask Mask image
% ---------------------------------------------------------------------
mask         = cfg_files;
mask.tag     = 'mask';
mask.name    = 'Mask image';
mask.help    = {'This image describes the regions of the tracts that are considered in clustering.'};
mask.filter = 'image';
mask.ufilter = '.*';
mask.num     = [1 1];
% ---------------------------------------------------------------------
% nc Number of clusters
% ---------------------------------------------------------------------
nc         = cfg_entry;
nc.tag     = 'nc';
nc.name    = 'Number of clusters';
nc.help    = {'Enter the number of clusters to be found.'};
nc.strtype = 'n';
nc.num     = [1  1];
% ---------------------------------------------------------------------
% init Initialisation Method
% ---------------------------------------------------------------------
init         = cfg_menu;
init.tag     = 'init';
init.name    = 'Initialisation Method';
init.help    = {'Select initialisation method.'};
init.labels = {
               'Uniform'
               'Points'
               'Fixed Points (1...k)'
               'Random'
               }';
init.values = {
               'uniform'
               'points'
               'fixed-points'
               'random'
               }';
% ---------------------------------------------------------------------
% retcov Return covariances
% ---------------------------------------------------------------------
retcov         = cfg_menu;
retcov.tag     = 'retcov';
retcov.name    = 'Return covariances';
retcov.labels = {
                 'Yes'
                 'No'
                 }';
retcov.values = {
                 true
                 false
                 }';
% ---------------------------------------------------------------------
% clustering Clustering options
% ---------------------------------------------------------------------
clustering         = cfg_branch;
clustering.tag     = 'clustering';
clustering.name    = 'Clustering options';
clustering.val     = {nc init retcov };
% ---------------------------------------------------------------------
% maskstruct Maskstruct File
% ---------------------------------------------------------------------
maskstruct         = cfg_files;
maskstruct.tag     = 'maskstruct';
maskstruct.name    = 'Maskstruct File';
maskstruct.help    = {'Select the maskstruct file that contains the seed regions.'};
maskstruct.filter = 'mat';
maskstruct.ufilter = '.*';
maskstruct.num     = [1 1];
% ---------------------------------------------------------------------
% ind Mask numbers
% ---------------------------------------------------------------------
ind         = cfg_entry;
ind.tag     = 'ind';
ind.name    = 'Mask numbers';
ind.help    = {'Enter the index numbers of the masks or "Inf" to select all masks in the file.'};
ind.strtype = 'n';
ind.num     = [1  Inf];
% ---------------------------------------------------------------------
% rois Mask source
% ---------------------------------------------------------------------
rois         = cfg_branch;
rois.tag     = 'rois';
rois.name    = 'Mask source';
rois.val     = {maskstruct ind };
% ---------------------------------------------------------------------
% noreco Don't reconstruct
% ---------------------------------------------------------------------
noreco         = cfg_const;
noreco.tag     = 'noreco';
noreco.name    = 'Don''t reconstruct';
% ---------------------------------------------------------------------
% reco Reconstruct parcellation images
% ---------------------------------------------------------------------
reco         = cfg_choice;
reco.tag     = 'reco';
reco.name    = 'Reconstruct parcellation images';
reco.values  = {rois noreco };
% ---------------------------------------------------------------------
% dti_parcellation GM Parcellation
% ---------------------------------------------------------------------
dti_parcellation         = cfg_exbranch;
dti_parcellation.tag     = 'dti_parcellation';
dti_parcellation.name    = 'GM Parcellation';
dti_parcellation.val     = {tracts mask clustering reco };
dti_parcellation.prog = @(job)dti_run_parcellation('run',job);
dti_parcellation.vout = @(job)dti_run_parcellation('vout',job);
