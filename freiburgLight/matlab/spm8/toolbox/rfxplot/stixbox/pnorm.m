function  p = pnorm(x,m,s)
%PNORM 	  The normal distribution function
%
%         p = pnorm(x,Mean,StandardDeviation)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if nargin<3, s=1; end
if nargin<2, m=0; end
p = (1+erf((x-m)./(sqrt(2).*s)))/2;
