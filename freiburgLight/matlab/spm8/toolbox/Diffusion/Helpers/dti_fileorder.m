function ordered=dti_fileorder(files)
% Check file order for 2nd order tensor files
% Old order:
% dt1 - Dxx, dt2 - Dyy, dt3 - Dzz, dt4 - Dxy, dt5 - Dxz, dt6 - Dyz
% New order:
% dt1 - Dxx, dt4 - Dxy, dt5 - Dxz, dt2 - Dyy, dt6 - Dyz, dt3 - Dzz
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_fileorder.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';

% check whether image file names have old or new format
[p n e] = spm_fileparts(files{1});
if n(1) == 'D'
  ordered = files;
else
  ordered = files([1 4 5 2 6 3]);
end;
