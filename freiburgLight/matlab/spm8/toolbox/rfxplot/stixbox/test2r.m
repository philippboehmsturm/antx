function  [pval, r] = test2r(x,y,method)
%TEST2R   Test for equal location of two samples using rank test
%         
%         [pval, ranksum] = test2r(x,y)
%         
%         This is the Wilcoxon-Mann-Whitney test. It is two sided. 
%         If you want a one sided alternative then devide pval by 2.
%	  The pvalue is computed using exact distribution, not
%	  normal approximation.
%
%	  The probability is exact and might take time to
%         compute unless a third argument 'n' is given, in 
%         case a normal approximation is used for the distribution
%         of the ranksum.

%	  See also TEST2N.

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if nargin < 3
  method = 'exact';
end

x = x(:);
y = y(:);
n = length(x);
m = length(y);
[z, I] = sort([x;y]);

% --- Check for ties

J = find(diff(z)==0);
if ~isempty(J)
   if any((I(J) <= n) ~= (I(J+1) <= n))
      fprintf('\nWarning: ties in data.\n');
      fprintf('Method used is to remove all tied pairs.\n');
      fprintf('This is not a sophisticated method.\n');
      xx = x; yy = y;
      for i = 1:length(xx)
         j = min(find(yy == xx(i)));
         if ~isempty(j)
            xx(i) = NaN;
            yy(j) = NaN;
         end
      end
      xx(find(isnan(xx))) = [];
      yy(find(isnan(yy))) = [];
      [pval, r] = test2r(xx,yy);
      return
   end
end

J = find(diff(z)<100000*eps*max(z));
if ~isempty(J)
   if any((I(J) <= n) ~= (I(J+1) <= n))
      fprintf('\nWarning: Nearly tie!\n');
   end
end

% --- Compute the ranks of the x's

R = 1:m+n;
r = sum(R(find(I<=n)));
r = r - n*(n+1)/2;
r = min(r,m*n-r);

if method(1) == 'e'

   mP = ceil((m*n+1)/2);
   P = zeros(mP,n+1);
   P(1,:) = P(1,:) + 1;
   for i=1:m
      for j = 1:n
         P(:,j+1) = (P(:,j+1)*i + [zeros(min(i,mP),1); P(1:mP-i,j)]*j)/(i+j);
      end
   end
   P = P(:,n+1);
   pval = min(2*sum(P(1:r+1)),1);

else

   % see B W Lindgren page 521
   Z = (r + 0.5 - m*n/2) / sqrt(m*n*(m+n+1)/12);
   pval = min(1, 2*pnorm(Z));

end
