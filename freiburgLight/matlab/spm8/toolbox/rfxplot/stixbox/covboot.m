function [C,y] = covboot(x,theta,B,p1,p2,p3,p4,p5,p6,p7,p8,p9)
%COVBOOT  Bootstrap estimate of the variance of a parameter estimate.
%
%	  C = covboot(X,'T')
%	  
%	  Computes the T(X) many times using resampled data and  
%	  uses the result to compute an estimate of the variance  
%         of T(X) assuming that X is a representative sample from  
%         the underlying distribution of X. If T is multidimensional 
%         then the covariance matrix is estimated. An optional third 
%	  input argument sets the number of resamples, default is 200.
%
%	  See also COV, COVJACK, and CIBOOT.

%       Anders Holtsberg, 11-01-95
%       Copyright (c) Anders Holtsberg

arglist = [];
for i = 4:nargin
   arglist = [arglist, ',p', num2str(i-3)];
end
if nargin < 3
   B = 200;
end
if min(size(x)) == 1
   x = x(:);
end

% Now, for functions that are known to produce columnwise 
% results it is faster to avoid the forloop! Note that
% there are functions that cannot be included, i e "cov".

colWiseFun = strcmp(theta,'mean') | ...
	     strcmp(theta,'std') | ...
	     strcmp(theta,'median') | ...
	     strcmp(theta,'quantile');
	     
[n,nx] = size(x);
evalstring = [theta,'(xb',arglist,')'];
xb = rboot(x);
s = eval(evalstring);
y = [s(:) zeros(length(s(:)),B-1)];
if nx == 1 & colWiseFun
   Bchunk = ceil(40000/n);
   i = 1;
   while i<B
      Bnext = min(B-i,Bchunk);
      xb = rboot(x,Bnext);
      y(:,i+(1:Bnext)) = eval(evalstring);
      i = i + Bnext;
   end
else
   for i = 2:B
      xb = rboot(x);
      yy = eval(evalstring);
      y(:,i) = yy(:);
   end
end

C = cov(y')*(B/(B-1));
