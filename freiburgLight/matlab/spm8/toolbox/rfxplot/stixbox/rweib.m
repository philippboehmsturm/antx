function  x = rweib(n,k,a)
%RWEIB    Weibull random numbers
%
%         x = rweib(n,k,a)
%
%         If the scale parameter a is left out it is assumed
%         to be 1. 

%       Copyright (c) Anders Holtsberg

if nargin < 3
   a = 1;
end
if any(any(a<=0))
   error('Parameter a is wrong')
end
if any(any(k<=0))
   error('Parameter k is wrong')
end

if size(n)==1
   n = [n 1];
end

x = qweib(rand(n), k, a);
