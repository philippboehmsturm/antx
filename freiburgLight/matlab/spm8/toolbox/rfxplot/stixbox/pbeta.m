function F = pbeta(x,a,b)
%PBETA    The beta distribution function
%
%         F = pbeta(x,a,b)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any((a<=0)|(b<=0)))
   error('Parameter a or b is nonpositive')
end

Ii = find(x>0&x<1);
Il = find(x<=0);
Iu = find(x>=1);
F = 0*(x+a+b); % Stupid allocation trick
F(Il) = 0*Il;
F(Iu) = 0*Iu + 1;
if length(Ii) > 0 
   F(Ii) = betainc(x(Ii),a,b);
end

