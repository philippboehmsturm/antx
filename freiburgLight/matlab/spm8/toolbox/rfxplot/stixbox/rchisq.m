function x = rchisq(n,a)
%RCHISQ   Random numbers from the chisquare distribution
%
%         x = rchisq(n,DegreesOfFreedom)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

if any(any(a<=0))
   error('DegreesOfFreedom is wrong')
end

x = rgamma(n,a*0.5)*2;
