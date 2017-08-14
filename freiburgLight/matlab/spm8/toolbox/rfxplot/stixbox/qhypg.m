function  k = qhypg(p,n,K,N)
%QHYPGEO  The hypergeometric inverse cdf
%
%        k = qhypg(p,n,K,N)
%
%        Gives the smallest integer k so that P(X <= k) >= p.

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

% The algorithm contains a nice vectorization trick which
% relies on the fact that if two elements in a vector
% are exactely the same then matlab's routine SORT sorts them
% into the order they had. Do not change this, Mathworks!

if max([length(n) length(K) length(N)]) > 1
   error('Sorry, this is not implemented');
end
if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end

lowerlim = max(0,n-(N-K));
upperlim = min(n,K);
kk = (lowerlim:upperlim)';
nk = length(kk);
cdf = max(0,min(1,cumsum(dhypg(kk,n,K,N))));
cdf(length(cdf)) = 1;
[pp,j] = sort(p(:));
np = length(pp);
[S,i] = sort([pp;cdf]);
i = find(i<=np) - (1:np)' + lowerlim; 
j(j) = (1:np)';
p(:) = i(j);
k = p;
