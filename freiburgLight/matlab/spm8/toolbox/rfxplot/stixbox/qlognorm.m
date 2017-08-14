function x = qlognorm(p,lambda,zeta)
%QLOGNORM  The inverse log-normal distribution function
% 
%          x = plognorm(p, lambda, zeta)

%        Copyright (c) Anders Holtsberg

if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end
if any(any(zeta<=0))
   error('Parameter zeta is wrong')
end

x = exp(erfinv(2*p-1).*sqrt(2).*zeta + lambda);
