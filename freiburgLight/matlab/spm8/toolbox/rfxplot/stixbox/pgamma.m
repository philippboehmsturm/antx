function F = pgamma(x,a)
%PGAMMA   The gamma distribution function
%
%         F = pgamma(x,a)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any(a<=0))
   error('Parameter a is wrong')
end

F = gammainc(x,a);
I0 = find(x<0);
F(I0) = zeros(size(I0));
