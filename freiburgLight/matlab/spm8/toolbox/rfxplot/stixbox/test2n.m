function [pval, cimean, cisigma] = test2n(x,y,cl)
%TEST2N   Tests and confidence intervals based on two normal samples
%         with common variance.
%         
%         [pval, cidiffmean, cisigma] = test2n(x,y,CL)
%         
%         Input CL is confidence level for the confidence intervals,
%         with default 0.95. Output pval is the probability that the 
%         difference of the means of x and y is as far from 0 as it 
%	  is, or further away, cimean and cisigma are confidence inter-
%	  vals for the difference and for the common standard deviation 
%	  respectively. These are of the form [LeftLimit, PointEstimate,...
%	  RightLimit].
%
%	  See also TEST2R.

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

x = x(:);
y = y(:);
if nargin<3, cl = 0.95; end
nx = length(x);
ny = length(y);
mx = mean(x);
my = mean(y);
m = mx - my;
df = nx + ny - 2;
s = sqrt(((nx-1)*var(x)+(ny-1)*var(y))/df);
d = s*sqrt(1/nx+1/ny);
T = m/d;
pval = (1-pt(abs(T),df))*2;
t = qt(1-(1-cl)/2,df);
cimean = [m-t*d, m, m+t*d];
cisigma = s*[sqrt(df/qchisq(1-(1-cl)/2,df)), 1,... 
             sqrt(df/qchisq((1-cl)/2,df))];
