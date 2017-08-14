function x = qchisq(p,a)
%QCHISQ   The chisquare inverse distribution function
%
%         x = qchisq(p,DegreesOfFreedom)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end
if any(any(a<=0))
   error('DegreesOfFreedom is wrong')
end

x = qgamma(p,a*0.5)*2;
