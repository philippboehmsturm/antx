function x = qbeta(p,a,b)
%QBETA    The beta inverse distribution function
%
%         x = qbeta(p,a,b)

%       Anders Holtsberg, 27-07-95
%       Copyright (c) Anders Holtsberg

if any(any((a<=0)|(b<=0)))
   error('Parameter a or b is nonpositive')
end
if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end
b = min(b,100000);

x = a ./ (a+b);
dx = 1;
while any(any(abs(dx)>256*eps*max(x,1)))
   dx = (betainc(x,a,b) - p) ./ dbeta(x,a,b);
   x = x - dx;
   x = x + (dx - x) / 2 .* (x<0);
   x = x + (1 + (dx - x)) / 2 .* (x>1);
end


