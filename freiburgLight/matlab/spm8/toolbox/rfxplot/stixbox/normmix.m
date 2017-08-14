function theta = normmix(x, opt1, opt2, opt3, opt4, opt5)
%NORMMIX  Estimate a mixture of normal distributions.
%
%	  theta = normmix(x)
%	  theta = normmix(x, opt1, opt2, opt3, opt4, opt5)
%
%	  In the output theta the first column has the
%	  estimated means, the second column the estimated 
%	  standard deviations and the third column the 
%	  mixture weights (the probabilities). 
%  
%	  opt1
%         The input opt1 is either the number of normal
%	  distributions or the complete matrix (n x 3) of
%	  starting values in the same format as the output.
%	  Default is 2.
%
%         opt2
%	  0: no plot (default if nargout)
%	  1: plot after convergence (default if no nargout)
%	  2: plot after every iteration
%
%         opt3 
%         is 'r' for plot of sum of the normal distributions
%	  with red et c, [] for no plot of mixed density.
%
%	  opt4 
%	  is number of bins in the histogram.
% 
%	  opt5 
%	  is the maximum number of iterations (a negative number
%	  means the forced number of iterations). 
%
%	  This function uses the EM algorithm and no convergence
%	  accelleration, therefore it is slow!

if nargin < 2 | isempty(opt1)
   opt1 = 2;
end
if nargin < 3 | isempty(opt2)
   if nargout > 0
      opt2 = 0;
   else
      opt2 = 1;
   end
end
if nargin < 4 | isempty(opt3)
   opt3 = [];
end
if nargin < 5 | isempty(opt4)
   opt4 = [];
end
if nargin < 6 | isempty(opt5)
   opt5 = 0;
end

if min(size(x)) == 1, 
   x = x(:);
else
   error('Multivariate distribution is not implemented')
end
x = sort(x);
n = length(x);

% === Starting values =======================================
if length(opt1) == 1
   m = mean(x);
   s = std(x);
   m = m + s*(-(opt1-1):2:(opt1-1))';
   s = s*ones(opt1,1);
   p = ones(opt1,1)/opt1;
else
   m = opt1(:,1);
   s = opt1(:,2);
   p = opt1(:,3);
end

% === Iteration =============================================
k = length(m);
m0 = inf*m;
s0 = inf*s;
p0 = inf*p;
L0 = inf;
L = inf;
w = zeros(k,n);
iter = 0;
breakcond = 0;

while ~breakcond

% === Shift parameters ======================================
   m0 = m;
   s0 = s;
   p0 = p; 
   L0 = L;

% === E-step ================================================

   for i=1:k
      r = dnorm(x, m(i), s(i)); 
      w(i,:) = p(i)*r';
      d(i,:) = r';
   end
   w = w./(ones(k,1)*sum(w));
   p = mean(w')';

% === M-step ================================================

   for i=1:k
      ww(i,:) = p(i)*d(i,:);
   end
   L = sum(log(sum(ww)));
   w = ww./(ones(k,1)*sum(ww));
   p = mean(w')';

   m = (sum((w.*x(:, ones(1,k))')')./sum(w'))';
   s = sqrt(sum(w'.*((x(:,ones(1,k))-m(:,ones(n,1))').^2)) ./ sum(w'))';

   iter = iter + 1;

% === Break criterion =======================================
   dif = [m; s; p] - [m0; s0; p0];
   if opt5 < 0 
      if iter == -opt5
         breakcond = 1;
      end
   else
      if abs(dif) < eps*10000 | iter == opt5
         breakcond = 1; 
      end
   end

% === Plotting ==============================================
   if opt2 == 2 | (breakcond & opt2 == 1)
      hold off
      bw = histo(x, opt4, 0);
      z = linspace(min(x), max(x))';
      hold on
      for i=1:k
         pww(i,:) = p(i)*dnorm(z, m(i), s(i))';
      end
      plot(z, bw*n*pww, 'r')
      if ~isempty(opt3)
         plot(z, bw*n*sum(pww), opt3)
      end
      pause(0)
   end

end

% === Post processing =======================================
theta = [m, s, p];
