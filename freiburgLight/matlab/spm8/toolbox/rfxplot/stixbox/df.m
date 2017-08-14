function f = df(x,a,b)
%DF       The F density function
%
%         f = df(x,df1,df2)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

c = b./a;
xx = x./(x+c);
f = dbeta(xx,a/2,b/2);
f = f./(x+c).^2.*c;

