function [Q, I, B, BB] = lsselect(y,x,crit,how,pmax,level);
%LSSELECT Select a predictor subset for regression
%
%     	  [Q, I, B, BB] = lsselect(y,x,crit,how,pmax,level)
%
%	  Selects a good subset of regressors in a multiple linear 
%	  regression model. The criterion is one of the following 
%	  ones, determined by the third argument, crit. 
%
%	    'HT'   Hypothesis Test (default level = 0.05)
%	    'AIC'  Akaike's Information Criterion 
%	    'BIC'  Bayesian Information Criterion
%	    'CMV'  Cross Model Validation (inner criterion RSS)
%
%	  The forth argument, how, choses between 
%
%	    'AS'   All Subsets
%	    'FI'   Forward Inclusion
%	    'BE'   Backward Elimination
%
%	  The fifth argument, pmax, limits the number of included
%	  parameters. The returned Q is the criterion as a function of 
%	  the number of parameters; it might be interpreted as an 
%	  estimate of the prediction standard deviation. For the method
%	  'HT' the reported Q is instead the successive p-values for
%	  inclusion or elimination.
%
%	  The last column of the prediction matrix x must be an intercept 
%	  column, ie all elements are ones. This column is never excluded 
%	  in the search for a good model. If it is not present it is added.  
%	  The output I contains the index numbers of the included columns.
%	  For the method 'HT' the optional input argument "level" is the 
%	  p-value reference used for inclusion or deletion. Output B is
%	  the vector of coefficients, ie the suggested model is 
%	  Y = X*B. Column p of BB is the best B of parameter size p. 
%
%	  This function is not highly optimized for speed but rather for
%	  flexibility. It would be faster if 'all subsets' were in a 
%	  separate routine and 'forward' and 'backward' were in another
%	  routine, especially for CMV.
%
%         See also LSFIT and LINREG.

%       Anders Holtsberg, 14-12-94
%       Copyright (c) Anders Holtsberg

n = length(y);
nc = size(x,2);

if nargin<5 
   pmax = nc;
elseif isempty(pmax)
   pmax = nc;
end
if nargin<4
   how = 'FI';
   fprintf('   Default is forward selection\n');
end
if nargin<3
   crit = 'CMV';
   fprintf('   Default criterion is CMV\n');
end
if strcmp(how,'BE')
   pmax = nc;
end
if nargin<6 & strcmp(crit,'HT') 
   level = 0.05;
   fprintf('   Default level is 0.05\n');
end

if any(x(:,nc)~=1)
   fprintf('   An intercept column added')
   x = [x ones(n,1)];
   nc = nc + 1;
   pmax = pmax + 1;
end
if nc<2, disp('only one model'), return, end 

if ~(strcmp(crit,'HT')|strcmp(crit,'AIC')|...
     strcmp(crit,'BIC')|strcmp(crit,'CMV'))
  error('Third argument error');
end
if ~(strcmp(how,'BE')|strcmp(how,'FI')|strcmp(how,'AS'))
  error('Forth argument error');
end
      
Qsml = NaN*ones(pmax,1);

XX = x'*x;
XY = x'*y; 
YY = y'*y;  

% === If all subsets then set up an all-subsets-indicator-matrix ====

if strcmp(how,'AS')
   C = [];
   for i = 1:nc-1
      d = max(1,size(C,1));
      C = [zeros(d,1) C; ones(d,1) C];
      H = C * ones(size(C,2),1);
      J = find(H<pmax);
      C = C(J,:);
   end
   H = H(J);
   [S,I] = sort(H);
   C = C(I,:);
   C = [C ones(size(C,1),1)];
   AllSubsets = C;
   AllSubsetsH = sum(C')';
end

% === This is for CMV ===============================================

if strcmp(crit,'CMV')
   dataloopend = n + 1;
   Qcmv = zeros(pmax,1);
   XXs = XX;
   XYs = XY;
   YYs = YY;
else
   dataloopend = 1;
end

for idata = 1:dataloopend
   
   if strcmp(crit,'CMV')
      fprintf('\n %3.0f:', idata*(idata ~= dataloopend))
      if idata == dataloopend
         XX = XXs;
         XY = XYs;
         YY = YYs;
      else
         xi = x(idata,:);
         yi = y(idata);
         XX = XXs - xi'*xi;
         XY = XYs - xi'*yi;
         YY = YYs - yi^2; 
      end
   end

% === Now we begin to loop over model sizes =========================

   if strcmp(how,'BE')
      p = nc;
      loopto = 1;
      C = ones(1,nc);
   else
      p = 1;
      loopto = pmax;
      C = [zeros(1,nc-1) 1];
   end
   BB = zeros(nc,pmax);

   fprintf('  ');

   while 1;

% === The whole loop over the models of size p  ======================
     
      fprintf('%2.0f ', p)
      qmin = 1e99;
      for k = 1:size(C,1)
         Jk = find(C(k,:));
         q = YY - XY(Jk)'*(XX(Jk,Jk)\XY(Jk));               
         if q < qmin
            qmin = q;
            Cbest = C(k,:);
         end
      end
      Qsml(p) = qmin;
      I = find(Cbest);
      BB(I,p)  = XX(I,I)\XY(I);
   
% === And a piece for CMV only ======================================

      if strcmp(crit,'CMV') & idata < n + 1
         Jk = find(Cbest);
         q = yi - xi(Jk)*(XX(Jk,Jk)\XY(Jk));               
         Qcmv(p) = Qcmv(p) + q^2;
      end

% === Next parameter size ===========================================
   
      if p == loopto, break, end

      if strcmp(how,'FI')
         p = p + 1;
         C = [];
         for i = 1:nc-1
            if Cbest(i)==0
               Cnew = Cbest;
               Cnew(i) = 1;
               C = [C; Cnew];
            end
         end

      elseif strcmp(how,'BE')
         p = p - 1;
         C = [];
         for i = 1:nc-1
            if Cbest(i)==1
               Cnew = Cbest;
               Cnew(i) = 0;
               C = [C; Cnew];
            end
         end
   
      elseif strcmp(how,'AS')
         p = p + 1;
         C = AllSubsets(find(AllSubsetsH==p),:);
      end
   
   end
end

% === Finished at last ===============================================

if strcmp(crit,'CMV') 
   Q = sqrt(Qcmv/n);
end
if strcmp(crit,'AIC') 
   Q = sqrt(Qsml/n).*exp((1:pmax)'/n);
end;
if strcmp(crit,'BIC')
   Q = sqrt(Qsml/n).*exp((1:pmax)'/n*log(n)/2);
end

if strcmp(crit,'HT')
   Qsml = sqrt(Qsml/n);
   Fvals = (Qsml(1:pmax-1).^2 - Qsml(2:pmax).^2) ...
            ./ (Qsml(2:pmax).^2 ./ (n-(2:pmax))' );
   Q = 1-pf(Fvals,1,(n-(2:pmax))');
   i = find(Q>level);
   if strcmp(how,'BE')
      i = [1; Q<level];
      i = find(i);
      i = i(length(i));
   else
      i = [Q>level; 1];
      i = find(i);
      i = i(1);
   end
else
   [S,i] = sort(Q);
   i = i(1);
end

B = BB(:,i);
I = find(B);

fprintf('\n');
