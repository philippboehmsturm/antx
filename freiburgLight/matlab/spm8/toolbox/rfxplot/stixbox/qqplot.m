function qqplot(x,y,ps);
%QQPLOT   Plot empirical quantile vs empirical quantile 
%
%         qqplot(x,y,ps)
%
%         If two distributions are the same (or possibly linearly 
%	  transformed) the points should form an approximately straight 
%	  line. Data is x and y. Third argument ps is an optional plot 
%	  symbol.
%
%         See also QQNORM

if nargin<3, ps = '*'; end
x = sort(x);
y = sort(y);
if length(x) < length(y)
   n = length(x);
   plot(x, quantile(y, ((1:n)-0.5)/n, 1), ps)
elseif length(y) < length(x)
   n = length(y);
   plot(quantile(x, ((1:n)-0.5)/n, 1), y, ps)
else
   plot(x,y,ps)
end
xlabel('Data X')
ylabel('Data Y')
