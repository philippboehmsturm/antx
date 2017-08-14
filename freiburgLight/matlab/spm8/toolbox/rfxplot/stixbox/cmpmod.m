function [p, es, el] = cmpmod(Y, As, Al);
%CMPMOD   Compare small linear model versus large one
%
%         [p, es, el] = cmpmod(Y, Xsmall, Xlarge)
%
%	  The standard hypothesis test of a larger linear regression 
%	  model against a smaller one. The standard F-test is used.
%	  The output is the p-value, the residuals from the smaller 
%	  model, and the residuals from the larger model.
%
%	  See also LSFIT 

%       Anders Holtsberg, 27-07-95
%       Copyright (c) Anders Holtsberg

n = length(Y);
ns = size(As,2);
nl = size(Al,2);
one = ones(n,1);
if any((one-As*(As\one))>10*eps)
   disp('Warning: perhaps you should include an intercept column of ones.')
end
if any(any((As-Al*(Al\As))>500*eps))
   disp('Warning: small model not included in large model, result is rubbish!')
end

ths = As\Y;
Ys = As*ths;
es = Y-Ys;

thl = Al\Y;
Yl = Al*thl;
el = Y-Yl;

Rs = sum(es.^2);
Rl = sum(el.^2);

z = ((Rs-Rl)/(nl-ns)) ./ (Rl/(n-nl));

p = 1-pf(z, nl-ns, (n-nl));
