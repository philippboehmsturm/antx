function  p = phypg(k,n,K,N)
%PHYPGEO  The hypergeometric cumulative probability function
%
%         p = phypg(k,n,K,N)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if max([length(n) length(K) length(N)]) > 1
   error('Sorry, this is not implemented');
end

kk = (0:n)';
cdf = max(0,min(1,[0; cumsum(dhypg(kk,n,K,N))]));
cdf(n+2) = 1;
p = k;
p(:) = cdf(max(1,min(n+2,floor(k(:))+2)));

