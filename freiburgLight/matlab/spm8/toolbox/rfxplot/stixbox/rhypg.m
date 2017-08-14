function  X = rhypg(num,n,K,N)
%RHYPGEO  Random numbers from the hypergeometric distribution
%
%        X = rhypg(num,n,K,N)

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

if length(num)==1
   num = [num 1];
end
X = qhypg(rand(num),n,K,N);


