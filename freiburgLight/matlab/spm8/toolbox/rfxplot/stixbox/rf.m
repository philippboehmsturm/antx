function x = rf(n,a,b)
%RF       Random numbers from the F distribution
%
%         x = rf(n,df1,df2)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

x = rbeta(n,a/2,b/2);
x = x.*b./((1-x).*a);

