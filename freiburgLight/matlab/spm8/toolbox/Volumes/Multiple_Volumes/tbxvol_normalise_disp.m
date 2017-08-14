function tbxvol_normalise_disp(bch)

% Display normalisation parameters
% FORMAT tbxvol_normalise_disp
% ======
% 
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_normalise_disp.m 160 2007-09-26 08:16:01Z glauche $

rev = '$Revision: 160 $';
funcname = 'Display normalisation params';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

for k = 1:numel(bch.params)
    prm{k} = load(bch.params{k});
    V(2*(k-1)+1) = prm{k}.VG(1);
    V(2*(k-1)+2) = prm{k}.VF(1);
    % apply affine registration parameters before CheckReg
    V(2*(k-1)+2).mat = prm{k}.VG(1).mat/prm{k}.Affine;
end;

spm_check_registration(V);
global st;

% modify spm_orthviews structure to call spm_ov_normalise_disp on redraw

for k = 1:numel(bch.params)
    st.vols{2*(k-1)+1}.normalise_disp.prm   = prm{k};
    st.vols{2*(k-1)+1}.normalise_disp.fname = bch.params{k};
    st.vols{2*(k-1)+1}.normalise_disp.type  = 'template';
    st.vols{2*(k-1)+2}.normalise_disp.prm   = prm{k};
    st.vols{2*(k-1)+2}.normalise_disp.fname = bch.params{k};
    st.vols{2*(k-1)+2}.normalise_disp.type  = 'source';
end;

spm_orthviews('redraw');
