function out = tbxvol_rescale_min_max(bch)
% Rescale SPM images to min=scale(1), max=scale(2)
% FORMAT tbxvol_rescale(bch)
% ======
% Rescale images to have an intensity range between scale(1) and
% scale(2). Output images will be written with the same data type as the
% input, but with new scaling factors.
%
% Input argument:
%   bch - struct with batch descriptions. Possible fields are:
%         .srcimgs   - cell array of file names
%         .prefix    - prefix for rescaled files
%         .oldscale  - [min max] of old intensity range. If either of
%                      them is non-finite, then determine it from the
%                      data. Image intensities will be clipped to this
%                      range before scaling.
%         .newscale  - [min max] of new intensity range.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_rescale.m 142 2006-08-24 11:50:59Z glauche $

rev = '$Revision: 142 $';
funcname = '(Re)Scale Images to [min max]';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

spm_progress_bar('init', numel(bch.srcimgs), ...
    funcname, 'volumes completed');

out.scimgs = cell(size(bch.srcimgs));
for k=1:numel(bch.srcimgs)
    V = spm_vol(bch.srcimgs{k});
    V1= V;
    V1.pinfo(1:2)=inf;
    [p n e v] = spm_fileparts(V.fname);
    [out.scimgs{k} V1.fname] = deal(fullfile(p,[bch.prefix, n, e, v]));    
    X = spm_read_vols(V);
    oldscale = bch.oldscale;
    if any(isfinite(X(:)))
        if isfinite(oldscale(1))
            X(X<oldscale(1)) = oldscale(1);
        else
            oldscale(1) = min(X(isfinite(X)));
        end;
        if isfinite(oldscale(2))
            X(X>oldscale(2)) = oldscale(2);
        else
            oldscale(2) = max(X(isfinite(X)));
        end;
    else
        warning('tbxvolRescaleMinMax:nonFinite', ...
            'No finite values in image ''%s''.', ...
            V.fname);
    end
    spm_write_vol(V1, (X-oldscale(1))/(oldscale(2)-oldscale(1)) ...
        * (bch.newscale(2)-bch.newscale(1)) + bch.newscale(1));
    spm_progress_bar('set',k);
end;
spm_progress_bar('clear');
