function rho = corr(x,y)
%CORR     Correlation coefficient.
%
%         rho = corr(x,y)
%
%         The correlation coeffient is computed between all
%	  columns in  x  and all coluns in  y. If only one
%	  argument  x  is given then the correlation matrix
%	  for  x  is returned instead.
%
%	  See also CVAR, SPEARMAN.

%       GPL Copyright (c) Anders Holtsberg, 1998

if nargin < 2
   c = cvar(x);
   s = sqrt(diag(c));
   rho = c ./ (s*s');
   n = size(x,2);
   rho(1:n+1:n^2) = ones(n,1);
else
   cx = cvar(x);
   sx = sqrt(diag(cx));
   cy = cvar(y);
   sy = sqrt(diag(cy));
   c = cvar(x,y);
   rho = c ./ (sx*sy');
end
