function x = qf(p,a,b)
%QF       The F inverse distribution function
%
%         x = qf(p,df1,df2)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

x = qbeta(p,a/2,b/2);
x = x.*b./((1-x).*a);
