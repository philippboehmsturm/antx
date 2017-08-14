function x = qgumbel(p,a,u)
%PGUMBEL  The Gumbel inverse distribution function
%
%         x = pgumbel(p, a, u)
%
%	  Defaults are a = 1 and m = 0. The parameter  a  is 
%	  proportional to the inverse of the standard deviation
%	  and the parameter  u  is the position.

%       GPL Copyright (c) Anders Holtsberg, 1999

if any(any(abs(2*p-1)>1))
   error('A probability should be 0<=p<=1, please!')
end
if nargin < 2
   a = 1;
end
if nargin < 3
   u = 0;
end
if any(any(a<=0))
   error('Parameter a is wrong')
end

x = -log(-log(p));
x = (x+u) ./ a;
