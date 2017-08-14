function z = lodds(p)
%LODDS    Log odds function.
%
%	  z = lodds(p)
%
%	  The function is log(p/(1-p)). 

%       Anders Holtsberg, 14-12-94
%       Copyright (c) Anders Holtsberg

if any(any(abs(2*p-1)>=1))
   error('A probability input please')
end
z = log(p./(1-p));
