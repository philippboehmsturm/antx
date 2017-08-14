function f = dchisq(x,a)
%DCHISQ   The chisquare density function
%
%         f = dchisq(x,DegreesOfFreedom)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

if any(any(a<=0))
   error('DegreesOfFreedom is wrong')
end

f = dgamma(x/2,a*0.5)/2;