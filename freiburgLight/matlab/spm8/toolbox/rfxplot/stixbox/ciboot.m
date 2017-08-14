function  [ci, y] = ciboot(x,theta,method,C,B,p1,p2,p3,p4,p5,p6,p7,p8,p9)
%CIBOOT   Bootstrap confidence interval.
%
%	  ci = ciboot(x,'T',method,C,B)
%	  
%	  Compute a bootstrap confidence interval for T(X) with level
%	  C. Default for C is 0.90. Number of resamples is B, with default
%	  that is different for different methods. The method is
%
%	  1.  Normal approximation (std is bootstrap).
%	  2.  Simple bootstrap principle (bad, don't use).
%	  3.  Studentized, std is computed via jackknife (If T is
%	      'mean' this done the fast way via the routine TEST1B).
%	  4.  Studentized, std is 30 samples' bootstrap.
%	  5.  Efron's percentile method.
%	  6.  Efron's percentile method with bias correction (BC).
%
%	  Default method is 5. Often T(X) is a number but it may also 
%	  be a vector or even a matrix. Every row of the result ci 
%	  is of the form 
%	  
%	      [LeftLimit, PointEstimate, RightLimit]
%
%	  and the corresponding element of T(X) is found by noting 
%	  that t = T(X); t = t(:); is used in the routine. Try for 
%	  example X = rand(13,2), C = cov(X), ci = ciboot(X,'cov').
%
%	  See also STDBOOT and STDJACK.
 
%       Anders Holtsberg, 1994, 1998
%       Copyright (c) Anders Holtsberg

if nargin < 5, B = []; end
if nargin < 4, C = []; end
if nargin < 3, method = []; end
arglist = [];
for i = 6:nargin
   arglist = [arglist, ',p', num2str(i-5)];
end
if min(size(x)) == 1
   x = x(:);
end
if isempty(method)
   method = 5;
end
if isempty(C)
   C = 0.9;
end
alpha = (1-C)/2;
[n,nx] = size(x);

% === 1 ================================================

if method == 1 
   if isempty(B), B = 500; end
   s = eval(['stdboot(x,theta,B',arglist,')']);
   s = s(:);
   t0 = eval([theta,'(x',arglist,')']);
   t0 = t0(:);
   z = qnorm(1-(1-C)/2);
   ci = [t0-z*s, t0, t0+z*s];
   return;
end

% === 2 5 6 ==============================================

if method == 2 | method == 5 | method == 6
   if isempty(B), B = 500; end
   [s,y] = eval(['stdboot(x,theta,B',arglist,')']);
   t0 = eval([theta,'(x',arglist,')']);
   t0 = t0(:);
   if method == 2 | method == 5
      q = quantile(y',[alpha, 1-alpha]',1);
      if method == 2
         ci = [2*t0-q(2,:)', t0, 2*t0-q(1,:)'];
      else
         ci = [q(1,:)', t0, q(2,:)'];
      end
   else
      t00 = t0(:,ones(size(y,2),1));
      J = ((y<t00)+(y<=t00))/2;
      z0 = qnorm(mean(J'));
      beta = pnorm(qnorm([alpha,1-alpha]')*...
             ones(1,length(z0))+2*ones(2,1)*z0);
      q = zeros(2,length(z0));
      for i=1:length(z0)
         q(:,i) = quantile(y(i,:),beta(:,i),1);
      end
      ci = [q(1,:)', t0, q(2,:)'];   
   end
   return
end

% === 3 'mean' ===========================================

if method == 3 & strcmp(theta,'mean')
   if isempty(B), B = 1000; end
   [dummy1,ci,dummy2,y] = test1b(x,C,B);
   return
end

% === 3 4 ================================================

if method == 3 | method == 4
   if isempty(B), B = 200; end
   evalstring1 = [theta,'(xb',arglist,')'];
   if method == 3 
      evalstring2 = ['stdjack(xb,theta',arglist,')'];
   else
      evalstring2 = ['stdboot(xb,theta,30',arglist,')'];
   end
   xb = x;
   t0 = eval(evalstring1);
   s0 = eval(['stdboot(xb,theta,200',arglist,')']);
   t0 = t0(:);
   s0 = s0(:);
   y = zeros(length(t0(:)),B);
   tic
   nfl = flops;
   fprintf(' B-i      flops\n')
   for i = 1:B
      xb = rboot(x);
      tb = eval(evalstring1);
      sb = eval(evalstring2);
      tb = tb(:);
      sb = sb(:);
      y(:,i) = (tb-t0) ./ sb;
      if toc > 1, tic, fprintf('%4.0f %10.0f\n',B-i,flops-nfl), end
   end
   q = quantile(y',[alpha, 1-alpha]',1);
   ci = [t0-s0.*q(2,:)', t0, t0-s0.*q(1,:)'];
   return
end