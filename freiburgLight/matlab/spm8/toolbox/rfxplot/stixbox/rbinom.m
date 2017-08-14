function  X = rbinom(num,n,p)
%RBINOM  Random numbers from the binomial distribution
%
%        X = rbinom(num,n,p)

%       Anders Holtsberg, 16-03-95
%       Copyright (c) Anders Holtsberg

if length(num)==1
   num = [num 1];
end
X = qbinom(rand(num),n,p);

