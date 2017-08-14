function get_orig_coord = spm_cfg_get_orig_coord
% Determine corresponding co-ordinate in un-normalised image.
% MATLABBATCH interface file for spm_get_orig_coord.
% Inputs:
% cmd - one of 'run','vout'. Either run the job or return dependency
%       object.
% job - job struct. Contains fields .snfile, .coords, .refimg
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Volkmar Glauche
% $Id: spm_cfg_get_orig_coord.m 217 2009-09-29 10:11:31Z volkmar $
% ---------------------------------------------------------------------
% snfile Normalisation Parameters
% ---------------------------------------------------------------------
snfile         = cfg_files;
snfile.tag     = 'snfile';
snfile.name    = 'Normalisation Parameters';
snfile.help    = {'Select the normalisation parameter .mat file.'};
snfile.filter = 'mat';
snfile.ufilter = '.*sn\.mat$';
snfile.num     = [1 1];
% ---------------------------------------------------------------------
% coords Coordinates
% ---------------------------------------------------------------------
coords         = cfg_entry;
coords.tag     = 'coords';
coords.name    = 'Coordinates';
coords.help    = {'Enter N coordinates to be transformed as a N-by-3 array.'};
coords.strtype = 'r';
coords.num     = [Inf    3];
% ---------------------------------------------------------------------
% refimg Reference image
% ---------------------------------------------------------------------
refimg         = cfg_files;
refimg.tag     = 'refimg';
refimg.name    = 'Reference image';
refimg.help    = {'If a reference image is specified, transformed coordinates will be in voxel space of this image. Otherwise, they will be in mm space.'};
refimg.filter = 'image';
refimg.ufilter = '.*';
refimg.num     = [0 1];
% ---------------------------------------------------------------------
% get_orig_coord Transform coordinates
% ---------------------------------------------------------------------
get_orig_coord         = cfg_exbranch;
get_orig_coord.tag     = 'get_orig_coord';
get_orig_coord.name    = 'Transform coordinates';
get_orig_coord.val     = {snfile coords refimg };
get_orig_coord.help    = {'Transform coordinates according to the normalisation parameter files. Note that the transformation parameter file for the "opposite" transformation must be specified. I.e. to transform coordinates from MNI into subject space, one has to specify the normalisation parameters that transform an image from subject to MNI space.'};
get_orig_coord.prog = @(job)spm_run_get_orig_coord('run',job);
get_orig_coord.vout = @(job)spm_run_get_orig_coord('vout',job);
