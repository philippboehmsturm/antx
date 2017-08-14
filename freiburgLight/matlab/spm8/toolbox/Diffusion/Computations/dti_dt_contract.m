function DC=dti_dt_contract(D)
% contract higher order tensor by 1 dimension
% Input argument:
%   D - higher order tensor
% Output argument:
%   DC - contracted tensor
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_dt_contract.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';

order = ndims(D);
szD = size(D);
DC = zeros([3*ones(1,order-2),prod(1:order)/2]);
selstr0=repmat(':,',1,order);
selstr0=selstr0(1:end-1); 
for st1 = 1:(order-1)
  for st2 = st1+1:order
    selstr = selstr0;
    for d = 1:3
      selstr(2*st1-1)=num2str(d);
      selstr(2*st2-1)=num2str(d);
      eval(sprintf('DC(%s%d) = DC(%s%d) + squeeze(D(%s));', ...
                   repmat(':,',1,order-2), st1*st2, ...
                   repmat(':,',1,order-2), st1*st2, selstr)); 
    end;
  end;
end;
DC = unique(reshape(DC,3^(order-2),prod(1:order)/2)','rows')';
zsel = all(DC==0);
DC = DC(:,~zsel);
ndc = size(DC,2);
DC=reshape(DC,[3*ones(1,order-2),ndc]);
