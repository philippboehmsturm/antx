function f = dlognorm(x,lambda,zeta)
%DLOGNORM  The log-normal density function
% 
%          f = dlognorm(x,lambda,zeta)

%       Copyright (c) Halfdan Grage, Anders Holtsberg

if any(any(zeta<=0))
   error('Parameter zeta is wrong')
end

neg = find(x <= 0);
[n1,n2] = size(neg);
x(neg) = ones(n1,n2);
f = dnorm(log(x),lambda,zeta)./x;
f(neg) = zeros(n1,n2);
