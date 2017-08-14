function [pval,cimean,cistd,Z] = test1b(x,cl,B)
%TEST1B   Bootstrap t test and confidence interval for the mean.
%          
%         [pval, cimean, cistd] = test1b(x,CL,B)
%          
%         Input CL is confidence level for the confidence intervals,
%         with default 0.95. Output pval is twice the one sided 
%	  observed p-value, cimean and cisigma are confidence intervals 
%	  for the mean and for the standard deviation respectively. 
%	  These are of the form [LeftLimit, PointEstimate, RightLimit]. 
%	  Another name for the bootstrap t is studentized bootstrap.
%	  The number of bootstrap samples is B, with default 2000.
%
%	  See also TEST1N and TEST1R.

%       Anders Holtsberg, 27-07-95
%       Copyright (c) Anders Holtsberg

x = x(:);
if nargin<2, cl = 0.95; end
if nargin<3, B = 2000; end
n = length(x);
m = mean(x);
s = std(x);

xB = zeros(n,B);
J = ceil(rand(n*B,1)*n);
xB(:) = x(J); 
mB = mean(xB);
sB = std(xB);
Z = (mB-m)./sB;
t = quantile(Z,[(1-cl)/2,1-(1-cl)/2]);
cimean = [m-t(2)*s, m, m-t(1)*s];

tt = m/s;
if tt>0
   pval = 2 * sum((mB-tt*sB)>=m)/B;
else
   pval = 2 * sum((mB-tt*sB)<=m)/B;
end

if nargout>2
   d = quantile(sB/s,[(1-cl)/2,1-(1-cl)/2]);
   cistd = [s/d(2), s, s/d(1)];
end

