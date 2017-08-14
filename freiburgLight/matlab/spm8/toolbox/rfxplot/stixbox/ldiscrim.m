function  [v, c, e1, e2] = ldiscrim(y,x,a3,a4);
%LDISCRIM Compute a linear discriminant by logistic regression. 
%
%     	  [v, c, e1, e2] = ldiscrim(x1, x2)
%
%         A good linear discriminator is found through logistic
%	  regression. An observation is classified as belonging to
%	  the first group if  v*x < c. The outputs  e1  and  e2
%	  are the misclassification rates on the given training set.
%	  One might also call the function with the form
%
%      	  [v, c, e1, e2] = ldiscrim(group, x)
%
%	  where  group  is a column vector with only 2 different
%	  kinds of elements - e g 1 and 2 - for group indication.
%
%	  If a third and a fourth argument are given they are taken 
%	  as plot symbols, and a plot is drawn.

%       GPL Copyright (c) Anders Holtsberg, 1999-04-13

% ------------------------------------------------- Rebuild ---

if size(y,2) > 1 | ~(all(y == min(y) | y == max(y)))
   if (size(x,2) ~= size(y,2))
      error('input format is wrong')
   end
   n1 = size(y,1);
   n2 = size(x,1);
   x = [y; x];
   y = [zeros(n1,1); ones(n2,1)];
end

% ------------------------------------------------- Check y ---

if size(y,2) ~= 1 | size(y,1) ~= size(x,1)
   error('input format is wrong')
end
y = y == max(y);
n1 = sum(y==0);
n2 = sum(y==1);

% ---------------------------------------------- Do the job ---

b = logitfit(y, [x, ones(size(x,1),1)]);
v = b(1:length(b)-1);
c = b(length(b));
c = -c/norm(v);
v = v./norm(v);
e1 = sum(x(1:n1,:)*v >= c) / n1;
e2 = sum(x(n1+(1:n2),:)*v < c) / n2;

% ---------------------------------------------------- Plot ---

if nargin == 4
   xx = x - (x*v)*v';
   m = mean(xx);
   s = std(xx);
   z = stdize(xx);
   CC = z'*z;
   [vn, e] = eig(CC);
   [dummy, I] = sort(diag(e));
   v2 = vn(:,I(size(x,2))) ./ s';
   l1 = x*v;
   l2 = x*v2;
   h = ishold;
   plot(l1(y==0), l2(y==0), a3)
   hold on
   plot(l1(y==1), l2(y==1), a4)
   a = axis;
   plot([c c], a([3, 4]), 'k');
   grid
   if ~h, hold off, end
end

