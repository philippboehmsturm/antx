function x = qt(p,a)
%QT       The student t inverse distribution function
%
%         x = qt(p,DegreesOfFreedom)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

s = p<0.5; 
p = p + (1-2*p).*s;
p = 1-(2*(1-p));
x = qbeta(p,1/2,a/2);
x = x.*a./((1-x));
x = (1-2*s).*sqrt(x);
