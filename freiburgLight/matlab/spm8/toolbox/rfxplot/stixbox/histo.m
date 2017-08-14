function binwidth = histo(x,N,odd,scale)
%HISTO    Plot a histogram
%
%         histo(X)
%         histo(X,M,odd,scale)
%
%         Data is X, approximate number of bins is M, and odd
%         should be 0 or 1 for placement of bins. Least significant 
%         digit of bin width will always be 1, 2 or 5. Last argument 
%	  should be one for scaling in order to have the area 1 under
%	  the histogram instead of area n.

%       Anders Holtsberg, 14-12-94
%       Copyright (c) Anders Holtsberg

if nargin < 2, N = []; end
if nargin < 3, odd = []; end
if nargin < 4, scale = []; end

if isempty(N)
   N = ceil(4*sqrt(sqrt(length(x))));
end
if isempty(odd)
   odd = 0;
end
if isempty(scale)
   scale = 0;
end

mn = min(x);
mx = max(x);
d = (mx - mn)/N*2;
e = floor(log(d)/log(10));
m = floor(d/10^e);
if m > 5
   m = 5;
elseif m > 2
   m = 2;
end
d = m * 10^e;
mn = (floor(mn/d)-1)*d - odd*d/2;
mx = (ceil(mx/d)+1)*d + odd*d/2;
limits = mn:d:mx;

f = zeros(1,length(limits)-1);
for i = 1:length(limits)-1
   f(i) = sum(x>=limits(i) & x<limits(i+1));
end

xx = [limits; limits; limits];
xx = xx(:);
xx = xx(2:length(xx)-1);
yy = [f*0; f; f];
yy = [yy(:); 0];
if scale, yy = yy/length(x)/d; end

H = ishold;
plot(xx,yy)
hold on
plot(limits,limits*0)
if ~H hold off, end

if nargout > 0
   binwidth = d;
end
