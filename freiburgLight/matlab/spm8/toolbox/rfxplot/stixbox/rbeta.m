function x = rbeta(n,a,b)
%RBETA    Random numbers from the beta distribution
%
%         x = rbeta(n,a,b)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any((a<=0)|(b<=0)))
   error('Parameter a or b is nonpositive')
end

if size(n)==1
   n = [n 1];
end

x = qbeta(rand(n),a,b);
