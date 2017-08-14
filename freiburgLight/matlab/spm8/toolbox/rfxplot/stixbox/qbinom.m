function  k = qbinom(pr,n,p)
%QBINOM  The binomial inverse cdf
%
%        k = qbinom(pr,n,p)

%       Anders Holtsberg, 16-03-95
%       Copyright (c) Anders Holtsberg

% The algorithm contains a nice vectorization trick which
% relies on the fact that if two elements in a vector
% are exactely the same then matlab's routine SORT sorts them
% into the order they had. Do not change this, Mathworks!

if max([length(n) length(p)]) > 1
   error('Sorry, this is not implemented');
end
if any(pr(:)>1) | any(pr(:)<0)
   error('A probability should be 0<=p<=1, please!')
end

kk = (0:n)';
cdf = max(0,min(1,cumsum(dbinom(kk,n,p))));
cdf(n+1) = 1;
[pp,J] = sort(pr(:));
np = length(pp);
[S,I] = sort([pp;cdf]);
I = find(I<=np) - (1:np)'; 
J(J) = (1:np)';
pr(:) = I(J);
k = pr;
