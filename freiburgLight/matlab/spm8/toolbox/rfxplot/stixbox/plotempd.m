function  plotempd(x,method)
%PLOTEMPD Plot empirical distribution.
%
%         plotempd(x)
%         plotempd(x, method)
%	  
%	  The method (default 3) is
%	  1. Interpolation so that F(X_(k)) == (k-0.5)/n.
%	  2. Interpolation so that F(X_(k)) == k/(n+1).
%	  3. The empirical distribution.
%
%	  If input  x  is a matrix then every column is treated
%	  as a separate distribution and plotted independently.

%       Copyright (c) Anders Holtsberg, 1998

if nargin < 2
   method = 3; 
end
h = ishold;

if size(x,1) == 1
   x = x';
end
n = size(x,1);
x = sort(x);

if method == 1 | method == 2
   if method == 1
      p = (0.5:n-0.5)/n;
   else
      p = (1:n)/(n+1);
   end
   for i = 1:size(x,2)
      plot(x(:,i),p)
      hold on
   end
elseif method == 3
   x = [x(1,:); x];
   p = (0:n)/n;
   for i = 1:size(x,2)
      stairs(x(:,i),p)
      hold on
   end
else
   error('Hey, argument 2 is not a method!')
end
if h, hold on, else hold off, end
