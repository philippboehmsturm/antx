function [p,a] = qqgamma(x,ps)

%QQGAMMA   Gamma probability plot
% 
%          [p,a] = qqgamma(x)
% 
%          Returns the parameters p (form parameter) and a (scale 
%	   parameter), estimated by the method of moments.

if nargin<2, ps = '.'; end
x = x(:);
if any(any(x<=0))
   error('Hey! Nonpositive data is meaningless!')
end
xmin = min(x);
xmax = max(x);
m = mean(x);
s2 = std(x)^2;
a = s2/m;
p = m^2/s2;
x = sort(x);
n = max(size(x));
F = ([1:n]'-0.5)/n;
q = qgamma(F,p)*a;
plot(x,q,ps)
Yticks=qgamma([0.01,0.05,0.10,0.20,0.30,0.40,0.50,...
   0.60,0.70,0.80,0.90,0.95,0.99]',p)*a;
YticLab=['0.01';'0.05';'0.10';'0.20';'0.30';'0.40';'0.50';...
   '0.60';'0.70';'0.80';'0.90';'0.95';'0.99'];
set(gca,'YTick',Yticks,'YTickLabel',YticLab);
grid;
hold on;
plot([xmin xmax],[xmin xmax],'--')
hold off;
title('Gamma Probability Plot')
xlabel('Data')
ylabel('Probability')
