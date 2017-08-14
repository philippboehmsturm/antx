function d = dbeta(x,a,b)
%DBETA    The beta density function
%
%         f = dbeta(x,a,b)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any((a<=0)|(b<=0)))
   error('Parameter a or b is nonpositive')
end

I = find((x<0)|(x>1));

d = x.^(a-1) .* (1-x).^(b-1) ./ beta(a,b);
d(I) = 0*I;
