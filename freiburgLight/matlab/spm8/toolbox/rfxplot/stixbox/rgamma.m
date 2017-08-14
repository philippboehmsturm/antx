function x = rgamma(nn,a)
%RGAMMA   Random numbers from the gamma distribution
%
%         x = rgamma(n,a)

% GNU Public Licence Copyright (c) Anders Holtsberg 10-05-2000.

% This consumes about a third of the execution time compared to 
% the Mathworks function GAMRND in a third the number of
% codelines. Yihaaa! (But it does not work with different parameters)
%
% The algorithm is a rejection method. The logarithm of the gamma 
% variable is simulated by dominating it with a double exponential.
% The proof is easy since the log density is convex!
% 
% Reference: There is no reference! Send me an email if you can't
% figure it out.

if any(any(a<=0))
   error('Parameter a is wrong')
end

n = prod(nn);
if length(nn) == 1
   nn(2) = 1;
end

y0 = log(a)-1/sqrt(a);
c = a - exp(y0);
m = ceil(n*(1.7 + 0.6*(min(min(a))<2)));

y = log(rand(m,1)).*sign(rand(m,1)-0.5)/c + log(a);
f = a*y-exp(y) - (a*y0 - exp(y0));
g = c*(abs((y0-log(a))) - abs(y-log(a)));
reject = (log(rand(m,1)) + g) > f;
y(reject) = [];
if length(y) >= n
   x = exp(y(1:n));
else
   x = [exp(y); rgamma(n - length(y), a)];
end
x = reshape(x, n/nn(2), nn(2));