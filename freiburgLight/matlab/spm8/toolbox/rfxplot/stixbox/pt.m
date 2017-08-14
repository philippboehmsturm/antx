function F = pt(x,df)
%PT       The student t cdf
%
%         F = pt(x,DegreesOfFreedom)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any(df<=0))
   error('DegreesOfFreedom is wrong')
end

df = min(df,1000000); % make it converge and also accept Inf.

neg = x<0;
F = pf(x.^2,1,df);
F = 1-(1-F)/2;
F = F + (1-2*F).*neg;
