function tbxvol_correct_ec_SPM(bch)
% Create covariance components for a Within-Subjects-Anova Model when 
% there are unequal # of scans per subject (i.e. some subjects have 
% missing conditions). Only unequal variances over one factor are 
% considered, errors are assumed to be independent.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_correct_ec_SPM.m 128 2006-03-16 16:20:04Z glauche $

rev = '$Revision: 128 $';
funcname = 'Correct SPM.mat error covariances';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

load(bch.srcspm{1});
nVi = max(SPM.xX.I(:,bch.nfactor));
for cVi = 1:nVi
        SPM.xVi.Vi{cVi} = sparse(diag(SPM.xX.I(:,bch.nfactor)==cVi));
end;
save(bch.srcspm{1},'SPM');