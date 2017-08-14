function  x = qnorm(p,m,s)
%QNORM 	  The normal inverse distribution function
%
%         x = qnorm(p,Mean,StandardDeviation)

%       Anders Holtsberg, 13-05-94
%       Copyright (c) Anders Holtsberg

if nargin<3, s=1; end
if nargin<2, m=0; end

if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end
if any(any(s<=0))
   error('Parameter s is wrong')
end

x = erfinv(2*p-1).*sqrt(2).*s + m;

