function x = rt(n,df)
%RT       Random numbers from the student t distribution
%
%         x = rt(n,DegreesOfFreedom)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if any(any(df<=0))
   error('DegreesOfFreedom is wrong')
end

if size(n)==1
   n = [n 1];
end

x = qt(rand(n),df);
