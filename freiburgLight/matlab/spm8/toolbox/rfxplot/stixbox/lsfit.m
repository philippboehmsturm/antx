function [b, Ib, e, s, Is] = lsfit(y,x,C,warning);
%LSFIT	  Fit a multiple regression model.
%
%     	  [b, Ib, e, s, Is] = lsfit(y,X,C)
%
% 	  Output b is vector of point estimates, Ib is confidence 
%	  intervals, s is estimated standard deviation of error
%	  with confidence interval Is, and e is residuals. Input C 
%	  is confidence level for the confidence intervals, default 
%	  is 0.95.
%
%         If an intercept is not included in X it is automatically  
%         added as an extra column. A fourth argument can be given
%	  as 1 (default) to tell that an intercept is added, 0 to add
%         it without warning, and -1 to avoid adding intercept.
%
%	  See also LINREG and LSSELECT.

%       Anders Holtsberg, 14-12-94
%       Copyright (c) Anders Holtsberg

if nargin<4
   warning = 1;
end
if nargin<3 | isempty(C)
   C = 0.95;
end
if size(y,2)>1
   error('Input y must be column vector');
end
n = length(y);
one = ones(n,1);
if (warning >= 0) & (any((one-x*(x\one))>100*n*eps))
   if warning
      fprintf('   Intercept column added \n')
   end
   x = [x, ones(n,1)];
end
nb = size(x,2);

b  = x\y;
if nargout<2, return, end
yh = x*b;
e  = y-yh;
d2  = sum(e.^2)/(n-nb);
sb = sqrt(diag(inv(x'*x))*d2);
if n-nb < 200
   t  = qt(1-(1-C)/2,n-nb); 
else
   t = qnorm(1-(1-C)/2);
end
Ib = [b-t*sb, b+t*sb];

if nargout<4, return, end
s = sqrt(d2);
pupper = 1-(1-C)/2;
plower = (1-C)/2;
Is = sqrt((n-nb) ./ qchisq([pupper plower],n-nb))*s;
