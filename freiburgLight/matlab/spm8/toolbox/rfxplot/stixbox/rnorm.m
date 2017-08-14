function  X = rnorm(n,m,s)
%RNORM 	  Normal random numbers
%
%         p = rnorm(Number,Mean,StandardDeviation)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if nargin<3, s=1; end
if nargin<2, m=0; end
if nargin<1, n=1; end
if size(n)==1
   n = [n 1];
   if size(m,2)>1, m = m'; end
   if size(s,2)>1, s = s'; end
end

X = randn(n).*s + m;
