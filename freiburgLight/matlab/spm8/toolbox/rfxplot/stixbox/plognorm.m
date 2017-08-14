function f = plognorm(x,lambda,zeta)
%PLOGNORM  The log-normal distribution function
% 
%          f = plognorm(x, lambda, zeta)

%        Copyright (c) Halfdan Grage, Anders Holtsberg

if any(any(zeta<=0))
   error('Parameter zeta is wrong')
end

neg = find(x <= 0);
[n1,n2] = size(neg);
x(neg) = ones(n1,n2);
f = pnorm(log(x),lambda,zeta);
f(neg) = zeros(n1,n2);
