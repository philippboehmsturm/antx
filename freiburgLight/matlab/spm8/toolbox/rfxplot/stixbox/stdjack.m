function [C,y] = stdjack(x,theta,p1,p2,p3,p4,p5,p6,p7,p8,p9)
%STDJACK  Jackknife estimate of the standard deviation of a parameter 
%	  estimate.
%
%	  C = stdjack(X,'T')
%	  
%	  The function is equal to sqrt(diag(covjack(X,'T')))

%       Anders Holtsberg, 28-02-95
%       Copyright (c) Anders Holtsberg

arglist = [];
for i = 3:nargin
   arglist = [arglist, ',p', num2str(i-2)];
end

C = sqrt(diag(eval(['covjack(x,theta',arglist,')'])));
