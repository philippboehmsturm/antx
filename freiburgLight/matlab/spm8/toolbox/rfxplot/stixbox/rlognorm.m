function x = rlognorm(n,lambda,zeta)
%RLOGNORM  Log-normal random numbers
% 
%          x = rlognorm(n, lambda, zeta)

%       Copyright (c) Anders Holtsberg

if any(any(zeta<=0))
   error('Parameter zeta is wrong')
end

if size(n)==1
   n = [n 1];
end

x = exp(randn(n).*zeta + lambda);
