function  x = qweib(p,k,a)
%QWEIB	  The Weibull inverse distribution function
%
%         p = qweib(p, k, a)
%
%	  If the scale parameter a is left out it is assumed
%	  to be 1. 

%       Copyright (c) Anders Holtsberg

if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end
if nargin < 3
   a = 1;
end
if any(any(a<=0))
   error('Parameter a is wrong')
end
if any(any(k<=0))
   error('Parameter k is wrong')
end

x = a.*(-log(1-p)).^(1./k);
