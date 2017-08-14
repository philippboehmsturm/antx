function [h,f,xx] = plotdens(x,h,positive,kernel)
%PLOTDENS Draw a nonparametric density estimate. 
%
%         plotdens(X)
%
%	  A density estimate is plotted using a kernel density
%	  estimate. A longer form plotdens(X,h,P,K) may be used
%	  where h is the kernel bandwidth, P is 1 if the density
%	  is known to be 0 for negative X, and K is
%
%	  1 Gaussian (the default)
%	  2 Epanechnikov 
%	  3 Biweight
%	  4 Triangular
%
%	  Below the density estimate a jittered plot of the obser-
%	  vations is shown.
%
%	  See also HISTO.

%       GPL Copyright (c) Anders Holtsberg, 1999-04-26

x = x(:);
n = length(x);
if nargin < 4, kernel = 1; end
if nargin < 3, positive = 0; end
if nargin < 2, h = []; end
if isempty(h)
   h = 1.06 * std(x) * n^(-1/5);  % Silverman page 45
end
if positive & any(x < 0)
   error('There is a negative element in X')
end

mn1 = min(x);
mx1 = max(x);
mn = mn1 - (mx1-mn1)/3;
mx = mx1 + (mx1-mn1)/3;
gridsize = 256;
xx = linspace(mn,mx,gridsize)';
d = xx(2) - xx(1);
xh = zeros(size(xx));
xa = (x-mn)/(mx-mn)*gridsize;
for i=1:n
   il = floor(xa(i));
   a  = xa(i) - il;
   xh(il+[1 2]) = xh(il+[1 2])+[1-a, a]';
end

% --- Compute -------------------------------------------------

xk = [-gridsize:gridsize-1]'*d;
if kernel == 1
   K = exp(-0.5*(xk/h).^2);
elseif kernel == 2 
   K = max(0,1-(xk/h).^2/5);
elseif kernel == 3
   c = sqrt(1/7);
   K = (1-(xk/h*c).^2).^2 .* ((1-abs(xk/h*c)) > 0);
elseif kernel == 4 
   c = sqrt(1/6);
   K = max(0,1-abs(xk/h*c));
end
K = K / (sum(K)*d*n);
f = ifft(fft(fftshift(K)).*fft([xh ;zeros(size(xh))]));
f = real(f(1:gridsize));

if positive & min(xx) < 0
   m = sum(xx<0);
   f(m+(1:m)) = f(m+(1:m)) + f(m:-1:1);
   f(1:m) = zeros(size(f(1:m)));
   xx(m+[0 1]) = [0 0];
end

% --- Plot it -------------------------------------------------

plot(xx,f)
if ~ishold
   hold on
   d = diff(get(get(gcf,'CurrentAxes'),'Ylim'))/100;
   plot(x,(-rand(size(x))*6-1)*d,'.')
   plot([mn mx],[0 0])
%   plot([mn mx],-[1 1]*d*8)
   axis([mn mx -0.2*max(f) max(f)*1.2])
   hold off
end
