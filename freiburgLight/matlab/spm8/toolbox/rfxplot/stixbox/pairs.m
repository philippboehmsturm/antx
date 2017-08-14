function J = pairs(X,plotsymbol)
%PAIRS    Pairwise scatter plots.
%
%	  pairs(X)
%         pairs(X,plotsymbol)
%
%	  The columns of X are plotted versus each other. An optional
%	  second argument is plotting symbol. In the diagonal there is
%	  a normal probability plot for every variable.

%       Copyright (c) Anders Holtsberg

clf
[n,p] = size(X);
X = X - ones(n,1)*min(X);
X = X ./ (ones(n,1)*max(X));
X = X*0.8 + 0.1;
if nargin<3
   diagonal = 0;
end
if nargin<2
   plotsymbol = '.';
end

Z = zeros(p*p*n,2);
for i = 1:p
   for j = 1:p
      k = ((i-1)+(j-1)*p)*n+1;
      if i~=j
         Z(k:k+n-1, 1) = X(:,i) + i-1;
         Z(k:k+n-1, 2) = X(:,j) + p-j;
      else
         Z(k:k+n-1, 1) = sort(X(:,i)) + i-1;
         xx = ((1:n)-1/2)'/n;
         Z(k:k+n-1, 2) = erfinv(2*xx-1)/7 + 0.5 + p-j;
      end
   end
end

hold off
plot(Z(:,1), Z(:,2), plotsymbol)
axis([0 p 0 p])
hold on
for i = 0:p
   plot([0,p],[i,i],'-')
   plot([i,i],[0,p],'-')
end
hold off
