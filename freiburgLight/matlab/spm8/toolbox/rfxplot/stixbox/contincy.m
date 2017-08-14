function [p, t] = contincy(observed, method)
%CONTINCY  Compute the p-value for contigency table row/col independence.
%
%	   p = contincy(observed, method)
%
%	   The table  observed  is a count, the  method  is
%
%	   'chi2': Pearson chi2-distance 
%	   'logL': Log likelihood quote distance
%
%	   with default method 'chi2'. The p-value is computed through 
%	   approximation with chi-2 distribution under the null hypothesis
%	   for both methods.
%
%          See also CAT2TBL

%       GPL Copyright (c) Anders Holtsberg, 1999

if nargin < 2
   method = 'chi2';
end

if any(any(observed~=round(observed) | observed<0))
   error('CONTINCY expects counts, that is nonnegative integers')
end

rowsum = sum(observed')';
colsum = sum(observed);
n = sum(rowsum);
expected = rowsum * colsum ./ n;

if strcmp(method, 'chi2')
   t = sum(sum((expected-observed).^2 ./ expected));
elseif strcmp(method, 'logL')
   I = find(observed>0);
   t = 2 * sum(observed(I) .* (log(observed(I)./expected(I))));
else
   error('unknown method')
end

p = 1 - pchisq(t, (length(rowsum)-1) * (length(colsum)-1));
