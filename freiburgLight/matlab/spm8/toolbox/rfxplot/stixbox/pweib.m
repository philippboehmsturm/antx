function  f = pweib(x,k,a)
%PWEIB    The Weibull distribution function
%
%         f = pweib(x,k,a)
%
%	  If the scale parameter a is left out it is assumed
%	  to be 1. 

if nargin < 3
   a = 1;
end
if any(any(a<=0))
   error('Parameter a is wrong')
end
if any(any(k<=0))
   error('Parameter k is wrong')
end

neg = find(x <= 0);
[n1,n2] = size(neg);
x(neg) = ones(n1,n2);
f = 1-exp(-(x./a).^k);
f(neg) = zeros(n1,n2);
