function x = qgamma(p,a)
%QGAMMA   The gamma inverse distribution function
%
%         x = qgamma(p,a)

%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end
if any(any(a<=0))
   error('Parameter a is wrong')
end

x = max(a-1,0.1);
dx = 1;
while any(any(abs(dx)>256*eps*max(x,1)))
   dx = (pgamma(x,a) - p) ./ dgamma(x,a);
   x = x - dx;
   x = x + (dx - x) / 2 .* (x<0);
end

I0 = find(p==0);
x(I0) = zeros(size(I0));
I1 = find(p==1);
x(I1) = zeros(size(I0)) + Inf;
