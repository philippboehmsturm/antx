function ret = dti_dt_reshape(data,order,varargin)
% reshape between full tensor and component vector
% iHperm as returned by dti_dt_order
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_dt_reshape.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';
funcname = 'Reshape Diffusion Tensor';

% function preliminaries
%Finter=spm_figure('GetWin','Interactive');
%spm_input('!DeleteInputObj');
%Finter=spm('FigName',funcname,Finter);
%SPMid = spm('FnBanner',mfilename,rev);
% function code starts here


if nargin>2
  iHperm = varargin{1};
else
  [Hind mult iHperm] = dti_dt_order(order);
end;

if all(size(data)==3) 
  ret = Inf*ones((order+1)*(order+2)/2,1);
  for p=1:numel(iHperm)
    ret(p) = data(iHperm{p}(1));
  end;
else
  ret= Inf*ones(3*ones(1,order)); 
  for p = 1:numel(iHperm)
    ret(iHperm{p})=data(p);
  end;
end;
