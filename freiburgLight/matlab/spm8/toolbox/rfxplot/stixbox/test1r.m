function [pval, r] = test1r(x, method)
%TEST1R   Test for median equals 0 using rank test
%         
%         [pval, ranksum] = test1r(x)
%         
%         This is called the Wilcoxon signed rank test. It is two 
%	  sided. If you want a one sided alternative then devide 
%	  pval by 2. The probability is exact and might take time
%	  to compute unless a second argument 'n' is given, in 
%	  case a normal approximation is used for the distribution
%	  of the ranksum.
%
%	  Ties are presently not properly handled.

%       Anders Holtsberg, 18-11-93, 14-Aug-1998, 16-Dec-1998
%       Copyright (c) Anders Holtsberg      

x = x(:);

if nargin < 2
  method = 'exact';
end

I = find(x==0);
if ~isempty(I)
   fprintf('\nWarning: zeros in data.\n');
   fprintf('Method used is to remove all zeros.\n');   
   x(I) = [];
end
n = length(x);

s = x > 0;
[x I] = sort(abs(x));
J = find(s(I));
r = ranktrf(abs(x));
r = sum(r(J));
r = min(r,n*(n+1)/2-r);

if method(1) == 'e'
   F = zeros(1,ceil((n*(n+1)/2+1)/2));
   F(1) = 1;
   for i=1:n
      B = [0.5 zeros(1,i-1) 0.5];
      F = filter(B,1,F);
   end
   pval = min(2*sum(F(1:ceil(r)+1)),1);
else
   % See B W Lindgren page 509, with continuity correction
   m = n*(n+1)/4;
   v = n*(n+1)*(2*n+1)/24;
   pval = min(1, 2*pnorm((r+0.5-m)/sqrt(v)));
end