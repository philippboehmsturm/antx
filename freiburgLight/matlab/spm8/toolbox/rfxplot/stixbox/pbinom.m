function  p = pbinom(k,n,p)
%PBINOM  The binomial cumulative probability function
%
%        p = pbinom(k,n,p)

%       Anders Holtsberg, 27-07-95
%       Copyright (c) Anders Holtsberg

if max([length(n) length(p)]) > 1
   error('Sorry, this is not implemented');
end

kk = (0:n)';
cdf = max(0,min(1,[0; cumsum(dbinom(kk,n,p))]));
cdf(n+2) = 1;
p = k;
p(:) = cdf(max(1,min(n+2,floor(k(:))+2)));
