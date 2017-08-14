function  p = dhypg(k,n,K,N)
%DHYPGEO  The hypergeometric probability function
%
%        p = dhypg(k,n,K,N)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any( n>N | K>N | K<0 ));
   error('Incompatible input arguments');
end

z = k<0 | n-k<0 | k>K | n-k>N-K;
i = find(~z);
if length(k)>1, k = k(i); end
if length(K)>1, K = K(i); end
if length(n)>1, n = n(i); end
if length(N)>1, N = N(i); end
pp = bincoef(k,K) .* bincoef(n-k,N-K) ./ bincoef(n,N);
p = z*0;
p(i) = pp(:);
