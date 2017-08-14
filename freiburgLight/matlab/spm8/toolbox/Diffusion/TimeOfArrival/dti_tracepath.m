function varargout=dti_tracepath(bch)

% Backtrace path to starting ROI
%
% This routine computes a path from a region of interest back to the
% source of tracking from dti_dt_time3. The region of interest may
% contain multiple voxels, which need not be connected.
%
% FORMAT [res bchdone]=dti_tracepath(bch)
% ======
% Input argument:
%   bch - struct array with batch descriptions, containing the following
%         fields:
%         .sroi    - starting ROI (image filename or 3D array)
%         .trace   - trace (image filename or 3D array)
%         .prefix  - output image prefix
% Output arguments:
%   res     - results structure
%   bchdone - filled batch structure
% Output filename will be constructed by prefixing trace filename with a
% customisable prefix. If trace is a 3D array, then sroi filename will be
% tried instead. The filename will be returned in res.path. If both sroi
% and trace are 3D arrays or bch.prefix is empty, res.path will be a 3D
% array containing the traced paths.
%
% This function is part of the diffusion toolbox for SPM5. For general help
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Trace path';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

if iscellstr(bch.trace)
    VT = spm_vol(bch.trace{1});
    tr = spm_read_vols(VT);
    VP = rmfield(VT,'pinfo');
    MT = VT.mat;
    dimT = VT.dim;
else
    tr = bch.trace;
    VP = [];
    MT = eye(4);
    dimT = size(tr);
end;

if iscellstr(bch.sroi)
    VR = spm_vol(bch.sroi{1});
    roi = spm_read_vols(VR);
    if isempty(VP)
        VP = rmfield(VR, 'pinfo');
    end;
else
    roi = bch.sroi;
end;
roi(~isfinite(roi))=0;
if ndims(tr) ~= ndims(roi) || ~all(size(tr)==size(roi))
    error('vgtbx_Diffusion:TimeOfArrival:TracePath', 'Trace and ROI do not have same dimensions.');
end;

path = zeros(dimT);
cind = 1;
res.ind(cind,:) = find(roi(:)&isfinite(tr(:)))';

while any(res.ind(cind,:)) && any(isfinite(res.ind(cind,:)))
    ind1=find(res.ind(cind,:)&isfinite(res.ind(cind,:)));
    path(res.ind(cind,ind1)) = path(res.ind(cind,ind1))+1;
    if all(res.ind(cind,ind1) == tr(res.ind(cind,ind1)))
        warning('vgtbx_Diffusion:dti_tracepath:loop','Loop in path detected.');
        break;
    end;
    res.ind(cind+1,ind1) = tr(res.ind(cind,ind1));
    cind=cind+1;
end;

if isempty(VP) || isempty(bch.prefix)
    res.path = path;
else
    [p n e v] = spm_fileparts(VP.fname);
    VP.fname = fullfile(p,[bch.prefix n e v]);
    spm_write_vol(VP,path);
    res.path{1} = VP.fname;
end;

for k=1:size(res.ind,2)
    res.lines(k) = struct('xyzvx',[],'xyzmm',[]);
    [x y z] = ind2sub(dimT(1:3),res.ind(:,k));
    res.lines(k).xyzvx = [x(x>0&isfinite(x)), y(x>0&isfinite(x)),...
        z(x>0& isfinite(x))]';
    tmp = MT*[res.lines(k).xyzvx; ones(1,size(res.lines(k).xyzvx,2))];
    res.lines(k).xyzmm = tmp(1:3,:);
end;

if nargout>0
    varargout{1}=res;
end;

if nargout>1
    varargout{2}=bch;
end;
