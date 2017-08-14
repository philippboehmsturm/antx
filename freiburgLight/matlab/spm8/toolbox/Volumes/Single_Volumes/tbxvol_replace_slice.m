function tbxvol_replace_slice(bch)
% Replaces a single slice in an image volume by averaging its neighbours 
% in space
% FORMAT replace_slice(bch)
% ======
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_replace_slice.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Replace slice';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

V = spm_vol(bch.srcimg{1});

if (bch.repslice < 2) || (bch.repslice > V.dim(3) -1)
  error('Slice %d out of image range (2:%d)', bch.repslice, V.dim(3)-1);
end;

spm('pointer','watch');
X = spm_read_vols(V);
X(:,:,bch.repslice) = (X(:,:,bch.repslice-1)+X(:,:,bch.repslice+1))/2;

[p n e v] = spm_fileparts(V.fname);
if ~bch.overwrite
        V.fname = fullfile(p,[bch.prefix num2str(bch.repslice) '-' n e v]);
        V = spm_create_vol(V);
end;
V = spm_write_vol(V,X);
spm('pointer','arrow');
