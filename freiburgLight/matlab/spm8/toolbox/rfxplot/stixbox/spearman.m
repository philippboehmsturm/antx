function rho = spearman(x,y)
%SPEARMAN Spearman's rank correlation coefficient.
%
%	  rho = spearman(x,y)
%
%	  This is the correlation coefficient between rank
%	  transformed data. 

if nargin < 2
   rho = corr(ranktrf(x));
else
   rho = corr(ranktrf(x),ranktrf(y));
end