function f = dgamma(x,a)
%DGAMMA   The gamma density function
%
%         f = dgamma(x,a)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any(a<=0))
   error('Parameter a is wrong')
end

f = x .^ (a-1) .* exp(-x) ./ gamma(a);
I0 = find(x<0);
f(I0) = zeros(size(I0));
