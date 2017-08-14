function  p = dbinom(k,n,p)
%DBINOM  The binomial probability function
%
%        p = dbinom(k,n,p)

%       Anders Holtsberg, 16-03-95
%       Copyright (c) Anders Holtsberg

if any(any( k<0 | k>n | p<0 | p>1 ));
   error('Strange input arguments');
end

p = bincoef(k,n) .* p.^k .* (1-p).^(n-k);
