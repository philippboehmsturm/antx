function [pval, cimean, cisigma] = test1n(x,cl)
%TEST1N   Tests and confidence intervals based on a normal sample
%         
%         [pval, cimean, cisigma] = test1n(x,CL)
%         
%         Input CL is confidence level for the confidence intervals,
%         with default 0.95. Output pval is the probability that the 
%	  mean of x is as far from 0 as it is, or further away, cimean  
%	  and cisigma are confidence intervals for the mean and for the 
%	  standard deviation respectively. These are of the form 
%	  [LeftLimit, PointEstimate, RightLimit].
%
%	  See also TEST1R and TEST1C.

%       Anders Holtsberg, 01-11-95
%       Copyright (c) Anders Holtsberg

x = x(:);
if nargin<2, cl = 0.95; end
n = length(x);
m = mean(x);
s = sqrt(var(x));
T = m/s*sqrt(n);
pval = (1-pt(abs(T),n-1))*2;
t = qt(1-(1-cl)/2,n-1);
cimean = [m-t*s/sqrt(n), m, m+t*s/sqrt(n)];
cisigma = s*[sqrt((n-1)/qchisq(1-(1-cl)/2,n-1)), 1,... 
             sqrt((n-1)/qchisq((1-cl)/2,n-1))];
