function  f = dnorm(x,m,s)
%DNORM 	  The normal density function
%
%         f = dnorm(x,Mean,StandardDeviation)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if nargin<3, s=1; end
if nargin<2, m=0; end
f = exp(-0.5*((x-m)./s).^2)./(sqrt(2*pi)*s);
