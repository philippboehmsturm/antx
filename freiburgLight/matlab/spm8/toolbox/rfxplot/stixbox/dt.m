function f = dt(x,df)
%DT       The student t density function
%
%         f = dt(x,DegreesOfFreedom)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any(df<=0))
   error('DegreesOfFreedom is wrong')
end

f = gamma((df+1)/2)./sqrt(df*pi)./gamma(df/2).*(1+x.^2./df).^(-(df+1)/2);