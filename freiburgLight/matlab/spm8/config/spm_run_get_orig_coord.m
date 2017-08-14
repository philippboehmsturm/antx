function out = spm_run_get_orig_coord(cmd,job)
% Determine corresponding co-ordinate in un-normalised image.
% MATLABBATCH interface file for spm_get_orig_coord.
% Inputs:
% cmd - one of 'run','vout'. Either run the job or return dependency
%       object.
% job - job struct. Contains fields .snfile, .coords, .refimg
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Volkmar Glauche
% $Id: spm_run_get_orig_coord.m 217 2009-09-29 10:11:31Z volkmar $

switch lower(cmd)
    case 'run'
        if isempty(char(job.refimg))
            out.coords = spm_get_orig_coord(job.coords, ...
                                            char(job.snfile));
        else
            out.coords = spm_get_orig_coord(job.coords, char(job.snfile), ...
                                            char(job.refimg));
        end
    case 'vout'
        out = cfg_dep;
        out.sname = 'Transformed Coordinates';
        out.src_output = substruct('.','coords');
        out.tgt_spec = {{'strtype','r'}};
end