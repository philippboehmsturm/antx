function varargout = tbxvol_laterality(bch)
% Compute laterality index of images with range [0,1]
% FORMAT tbxvol_laterality(bch)
% ======
% Input arguments:
% bch.srcimg - file name of input image
%
% This routine computes the laterality index for images with positive
% data range as (normal-flipped)./(normal+flipped) using spm_imcalc.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_laterality.m 724 2012-01-24 13:26:05Z glauche $

rev = '$Revision: 724 $';
funcname = 'Compute laterality index';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

out.files = cellfun(@(src)prepend(src, bch.prefix), bch.srcimgs, 'UniformOutput', false);
cellfun(@(srcimg,oimg)comp_laterality(srcimg, oimg, bch.dtype, bch.interp), bch.srcimgs, out.files);
if nargout > 0
    varargout{1} = out;
end
end

function comp_laterality(srcimg, oimg, dtype, interp)
Vo = rmfield(spm_vol(srcimg),'private');
V = [Vo Vo];
% flip 2nd image by pre-multiplying its coordinate transformation
V(2).mat = diag([-1 1 1 1])*V(2).mat;
% create output filename
Vo.fname = oimg;
Vo.n = [1 1];
if dtype ~= 0
    Vo.dt(1) = dtype;
end;
Vo.pinfo = [Inf; 0; 0];
spm_imcalc(V, Vo, '(i1-i2)./(i1+i2)', {0, 0, interp});
end

function ofile = prepend(ifile, prefix)
[p n e v] = spm_fileparts(ifile);
ofile     = fullfile(p,[prefix n e]);
end