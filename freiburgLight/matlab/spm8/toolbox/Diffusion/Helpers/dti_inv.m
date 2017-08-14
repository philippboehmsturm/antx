function it=dti_inv(t)
% Compute inv of 2nd order tensor more efficiently than Matlab would 
% do. This uses a direct solution and knowledge about the tensor 
% arrangements in a 6-by-(dim1-dim2...) array.
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_inv.m 712 2010-06-30 14:20:19Z glauche $

  rev = '$Revision: 712 $';
  
  st = size(t);
  t  = reshape(t,st(1),prod(st(2:end)));
  it = zeros(st(1),prod(st(2:end)));
  t2 = t([2 3 5],:).^2; % square of off-diagonal elements
  dt = t(1,:).*t(4,:).*t(6,:) + 2*t(2,:).*t(3,:).*t(5,:)...
       - t(1,:).*t2(3,:) - t(4,:).*t2(2,:) - t(6,:).*t2(1,:);
  it(1,:) = (t(4,:).*t(6,:)-t2(3,:))./dt;
  it(4,:) = (t(1,:).*t(6,:)-t2(2,:))./dt;
  it(6,:) = (t(1,:).*t(4,:)-t2(1,:))./dt;
  it(2,:) = (t(3,:).*t(5,:)-t(2,:).*t(6,:))./dt;
  it(3,:) = (t(2,:).*t(5,:)-t(3,:).*t(4,:))./dt;
  it(5,:) = (t(2,:).*t(3,:)-t(5,:).*t(1,:))./dt;
  it = reshape(it,st);
  it(~isfinite(it))=NaN;
