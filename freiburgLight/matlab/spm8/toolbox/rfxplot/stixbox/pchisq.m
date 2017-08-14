function F = pchisq(x,a)
%PCHISQ   The chisquare distribution function
%
%         F = pchisq(x,DegreesOfFreedom)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

if any(any(a<=0))
   error('DegreesOfFreedom is wrong')
end

F = pgamma(x/2,a*0.5);