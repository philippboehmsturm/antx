function res = dti_recalc(bch)
% recalculate DTI input Data from given tensor and b-matrix data 
% (i.e. adjusted data).
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Compute filtered/adjusted DW images';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

load(bch.srcspm{1});
opwd=pwd;
cd(SPM.swd);

res.files = cell(size(SPM.xY.P));
for k=1:numel(SPM.xY.P)
  [p n e]   = spm_fileparts(SPM.xY.P{k});
  if strcmp(n(1:3),'ln_')
          n = n(4:end);
  end;
  try
      V = spm_vol(fullfile(p,[n e]));
  catch
      V = SPM.Vbeta(1);
  end
  V.fname = fullfile(p,[bch.prefix n e]);
  V = spm_create_vol(V);
  bm = SPM.xX.X(k,:);
  V = spm_imcalc(SPM.Vbeta,V,'exp(bm*X)',{1},bm);
  res.files{k} = V.fname;
end;

cd(opwd);