function  [b, Ib, Vb] = logitfit(y,x,C);
%LOGITFIT Fit a logistic regression model.
%
%     	  [b, Ib, Vb] = logitfit(y,X,C)
%
%	  Fit the model log(p/(1-p)) = X*b, where p is the probability 
%	  that y is 1 and not 0. Output b is vector of point estimates,  
%	  Ib is confidence intervals, and Vb is the estimated variance 
%	  matrix of b. Input C is confidence level for the confidence 
%	  intervals, default is 0.95.
%
%         If an intercept is not included in X it is automatically added 
%         as an extra column. Note that the intercept is then the last
%         coefficient, not the first!
%
%	  See also LODDS and LODDSINV.

%       Anders Holtsberg, 14-12-94
%       Copyright (c) Anders Holtsberg

if nargin<3 
   C = 0.95;
end
if size(y,2)>1
   error('Input y must be column vector');
end
n = length(y);
if sum(y==1|y==0) < n
   error('Hey, only 0 or 1 as response varable y')
end
one = ones(n,1);
if any(abs(one-x*(x\one)) > 1e-10)
   fprintf('   Intercept column added \n')
   x = [x, ones(n,1)];
end
nb = size(x,2);

b  = x\(4*y-2);

for i=1:50
   z  = x*b;
   g1 = 1+exp(-z);
   g0 = 1+exp(+z);
   df1 = -1 ./ g0;
   df0 = +1 ./ g1;
   df = sum(((y.*df1+(1-y).*df0)*ones(1,nb)) .* x)';
   ddf = (((1 ./ (g0+g1))*ones(1,nb)) .* x)'*x;
   b = b - (ddf\df);
   if all(abs(df)<0.0001), break; end;
end

if i== 50, error('No convergence'), end

logL = y.*log(g1) + (1-y).*log(g0);
Vb = inv(ddf);
lamda = qnorm(1-(1-C)/2);
Ib = lamda*sqrt(diag(Vb));
Ib = [b-Ib, b+Ib];

