function [kk,aa] = qqweib(x, psym)
%QQWEIB    Weibull probability plot
% 
%          [k,a] = qqweib(x)
% 
%          Plot of log(data) on x-axis and  log(-log(1-(i-1/2)/n))  
%	   on y-axis. Returns the the scale parameter a and the shape 
%	   parameter k, estimated from the plot by the least-squares 
%	   method.

%        Copyright (c) Halfdan Grage, Anders Holtsberg

if nargin<2, psym = '.'; end
x = x(:);

if any(any(x<=0))
   error('Hey! Nonpositive data is meaningless!')
end

x = sort(x);
n = max(size(x));
F = ([1:n]'-0.5)/n;
xt = log(x);
Ft = log(-log(1-F));
plot(xt,Ft,psym)
U = [ones(size(xt)) xt];
b = U\Ft;
c = b(2);
a = exp(-b(1)/c);
hold on
plot(xt,U*b,'--')
hold off
xlabel('log(data)')
ylabel('log(-log(1-(i-1/2)/n))')
title('Weibull Probability Plot')

if nargout > 0
   aa = a;
   kk = c;
end
