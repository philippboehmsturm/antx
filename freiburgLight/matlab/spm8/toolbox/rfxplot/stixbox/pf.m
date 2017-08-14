function F = pf(x,a,b)
%PF       The F distribution function
%
%         F = pf(x,df1,df2)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

x = x./(x+b./a);
F = pbeta(x,a/2,b/2);

