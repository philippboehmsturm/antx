function ci = ciquant(x,p,C);
%CIQUANT  Nonparametric confidence interval for quantile
%
%	  ci = ciquant(x,p,C);
%
%         Input C is confidence level for the interval, with default 
%	  0.95, p is the probability. The interval is of the form
%         [LeftLimit, PointEstimate, RightLimit]'. The interval is
%	  constructed conservatively in both ends, that is 
%	  P(q<LeftLimit) <= C/2 and similarly for the upper limit.
%	  If x is a matrix the procedure is colonwise.
%
%	  See also QUANTILE.

if size(x,1) == 1, x = x'; end
[n,m] = size(x);
x = [-Inf*ones(1,m); sort(x); Inf*ones(1,m)];
pr = [pbinom(0:n-1,n,p)];
a = (1-C)/2;
J = pr >= a & pr <= (1-a);
L = x(min(find(J==1)),:);
H = x(max(find(J==1))+2,:);
ci = [L;quantile(x,p,2);H];
