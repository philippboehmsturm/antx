function varargout = dti_get_snaffine(varargin)
% Get rotation, zoom, shear from affine normalisation transformation 
% matrix. This routine tries to guess for SPM99 data, assuming that 
% normalised images were written in SPM99 standard convention (i.e. L=L 
% after normalisation).
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_get_snaffine.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';

if isempty(varargin{1})
  snAffine=eye(4);
  pref = '';
else
  sn3d = load(varargin{1});
  if isfield(sn3d,'VG') % SPM5 normalised data
    snAffine = sn3d.VG(1).mat/sn3d.Affine/sn3d.VF.mat;
    pref = 'w';
  else % try SPM99 format
    snAffine = diag([-1 1 1 1])*sn3d.MG/sn3d.Affine/sn3d.MF; % assume images are written flipped
    pref = 'n';
  end;
end;    

varargout{1} = snAffine;
if nargout > 1
  varargout{2} = pref;
end;
