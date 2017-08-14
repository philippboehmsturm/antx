function tbxvol_extract_subvol(bch)
% Extract sub-volume while keeping correct coregistration information
% FORMAT tbxvol_extract_subvol(bch)
% ======
% This tool extracts a part of an 3D analyze image as specified with the 
% bbox parameter into a new file. Spatial coregistration of the extracted 
% image with the original image is preserved.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_extract_subvol.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Extract subvolume';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

Vi = spm_vol(char(bch.srcimgs));
spm_input('!DeleteInputObj');

nimg = numel(Vi);
spm_progress_bar('init', nimg, 'Extraction', 'Images completed');
for k=1:nimg
  [p n e v] = spm_fileparts(Vi(k).fname);
  X=spm_read_vols(Vi(k));
  off=Vi(k).mat*[bch.bbox([1 3 5])'-1; 1];
  IExt(k)=Vi(k);
  IExt(k).fname=fullfile(p,[bch.prefix n e v]);
  IExt(k).dim=bch.bbox([2 4 6])-bch.bbox([1 3 5])+1;
  IExt(k).mat=[Vi(k).mat(:,1:3), off];
  spm_write_vol(IExt(k), X(bch.bbox(1):bch.bbox(2), bch.bbox(3):bch.bbox(4), bch.bbox(5):bch.bbox(6)));
  spm_progress_bar('set',k);
end;
spm_progress_bar('clear');

