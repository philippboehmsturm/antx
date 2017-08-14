function [mm, ss] = qqnorm(x,ps,ps2);
%QQNORM   Normal probability paper
%
%         qqnorm(x)
%         qqnorm(x, symbol)
%
%         Data on x-axis and  qnorm((i-1/2)/n)  on y-axis.
%	  The second optonal argument is the plot symbol, e g '+'.
%	  In the three parameter version is also accepted.
%
%         qqnorm(x, c, s)
%
%	  The second argument,  c, is then a vector of category 
%	  numbers and the third argument is a string of plot
%	  symbols. The length of  c  must be the same as the
%	  length of  x. The length of  s  is the same as the
%	  number of different categories.
%
%         See also QQPLOT

% Modified to work with many plotsymbols simultaneously. 981211.

[x, I] = sort(x);
n = length(x);
if nargin<2
   if n > 50
      ps = '.'; 
   else
      ps = 'o';
   end
end
if nargin == 3
   ps = ps2(ps - min(ps) + 1);   
   ps = ps(I);
end

X = ((1:n)-1/2)/n;
Y = sqrt(2)*erfinv(2*X-1);
if length(ps) == n
   pss = ps;
   while length(pss) > 0
      s = pss(1);
      j = find(ps == s);
      if any(s == 'ymcrbgwk')
         plot(x(j),Y(j),[s, 'o'])
      else
         plot(x(j),Y(j),s)
      end
      hold on
      pss = pss(find(pss ~= s));
   end
else
   plot(x,Y,ps)
end
xlabel('Data')
ylabel('Quantile')

z0 = pnorm([-1 1]/2);
z1 = quantile(x,z0,2);
m = mean(z1);
s = diff(z1);
hold on
plot([x(1) x(n)], ([x(1), x(n)]-m)/s,'--')
title('Normal probability plot')
hold off

if nargout > 0
   mm = m;
   ss = s;
end
