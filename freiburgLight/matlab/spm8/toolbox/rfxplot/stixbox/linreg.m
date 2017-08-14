function [b, Ib, e, s, Is] = linreg(y,x,C,sym,pmax)
%LINREG   Linear or polynomial regression
%
%	  linreg(y,x)
%         [b, Ib, e, s, Is] = linreg(y,x,C,sym,pmax)
%
%         The output  b  is the point estimate of the parametars 
%         in the model  y = b(1)*x + b(2) + error.
%         The columns of  Ib  are the corresponding confidence 
%         intervals. The residuals are in  e. The standard deviation 
%	  of the residuals is  s.
%
%         A pointwise confidence band for the expected y-value is
%         plotted, as well as a dashed line which indicates the
%         prediction interval given x. The input  C  is the confidence
%	  which is 0.95 by default. C = []  gives no plotting
%         of confidence band or prediction band.
%
%	  Input sym is plotting symbol, with 'o' as default. For 
%	  polynomial regression give input  pmax  a desired value,  
%	  the model is then  y = [x^pmax, ... x^2, x, 1] * b' + error.
%
%         See also LSFIT and LSSELECT.

%       GPL Copyright (c) Anders Holtsberg, 1995, 1998

if nargin < 3, C = 0.95; end
if nargin < 4 | ~exist('sym'), sym = 'o'; end
if isempty(sym), sym = 'o'; end
if nargin < 5, pmax = 1; end

y = y(:);  
x = x(:);
if length(x) ~= length(y)
   error('Error in input format to linreg')
end
n = length(x);

X = ones(n,pmax+1);
for i = pmax:-1:1
    X(:,i) = x .* X(:,i+1);
end

[b, Ib, e, s, Is] = lsfit(y,X,C);

mn = 1.1*min(x)-0.1*max(x);
mx = 1.1*max(x)-0.1*min(x);
xx = linspace(mn,mx,50)';

V = xx(:,ones(1,pmax+1));
V = V .^ (ones(length(xx),1)*(pmax:-1:0));
yy = V*b;

h = ishold;
plot(x,y,sym)
hold on
plot(xx,yy)

if ~isempty(C)
   R = chol(X'*X);
   E = V/R;
   t = qt(1-(1-C)/2, n-pmax);
   d = sum((E.*E)')';

   dd = t*s*sqrt(d);
   ym = yy - dd;
   yp = yy + dd;

   dd1 = t*s*sqrt(1+d);
   ym1 = yy - dd1;
   yp1 = yy + dd1;

   plot(xx,ym)
   plot(xx,yp)
   plot(xx,ym1,'--')
   plot(xx,yp1,'--')
end

if ~h, hold off; end
