function varargout = fitmr1(varargin)
% fit rank-1 tensor to general tensor
% FORMAT [x, l] = fitmr1(t, x0)
% ======
% Input argument
%   t  - full tensor
%   x0 - cell array of starting estimates for x, defaults to {[1;0;0]};
% Output arguments
%   x - matrix of generating vectors for rank-1 tensors
%   l - vector of scaling factors (Generalised Raleigh Quotient)
%
% References:
%/*\cite{lathauwer00a}*/
% [dLdM00]     de Lathauwer, Lieven, Bart de Moor and Joos Vandewalle. On the
%              best Rank-1 and Rank-(R1, R2, ..., Rn) Approximation of
%              higher-order Tensors. SIAM Journal of Matrix Analysis
%              Applications, 21(4):1324--1342, 2000.
%/*\cite{zhang2001}*/
% [ZG01]       Zhang, Tong and Gene H Golub. Rank-one approximation to high
%              order tensors. SIAM Journal of Applied Matrix Analysis,
%              23(2):534--550, 2001.
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: fitmr1.m 712 2010-06-30 14:20:19Z glauche $

t = varargin{1}; % tensor

xo = [0 0 0]';
% starting estimate
if nargin > 1
  xin = varargin{2};
else
  xin{1} = [1 0 0]'; 
end;

order = ndims(t);
szt   = size(t);
xind = 1:order;
for k=1:numel(xin)
  x{k}=repmat(xin{k},1,order);
end;
tsub.type = '()';
[tsub.subs{1:order}] = deal(':');
tflat.type = '()';
tflat.subs = {':'};

ldx = Inf;
for cv = 1:numel(x)
  gx{cv} = tensor_gop(x{cv});
  l(cv) = sum(t(:).*gx{cv}(:));
end;  
% iterate
while sum(ldx)/numel(x) > .001 
  ldx = zeros(numel(x),1);
% ??? warum l oben initialisiert?
%  l = zeros(numel(x),1);
  % td needs to be re-initialised after x has been updated
  td = t;
  for cv = 1:numel(x)
% ??? td == t, da l==0    
    td = td - l(cv)*gx{cv};
  end;  
  for cv = 1:numel(x)
    xo = x{cv}(:,1);
    % incremental update of td after x{cv} has changed instead
    % of recomputing all of td each time
% ??? l(cv) == 0
    td = td + l(cv)*gx{cv};
    for co = 1:order
      tx = tensor_gop(x{cv}(:,xind~=co));
      for k=1:3
        tsub.subs{k} = k;
        x{cv}(k,co) = sum(subsref(subsref(td,tsub),tflat).*tx(:));
        tsub.subs{k} = ':';
      end;
      x{cv}(:,co)=x{cv}(:,co)./sqrt(sum(x{cv}(:,co).^2));
      ldx(cv) = sqrt(sum((x{cv}(:,1)-xo).^2));
    end;
    gx{cv} = tensor_gop(x{cv});
    l(cv) = sum(td(:).*gx{cv}(:));
    % incremental update of td after x{cv} has changed instead
    % of recomputing all of td each time
% ??? hier wird neues l(cv) abgezogen ?    
    td = td - l(cv)*gx{cv};
  end;
  xa = zeros(3,numel(x));
  for cv = 1:numel(x)
    xa(:,cv) = x{cv}(:,1);
  end;
  % co-directionality without self-co-directionality
  xd = abs(xa'*xa)-eye(numel(x));
  ind = true(1,numel(x));
  for cv=1:numel(x)
    for cv1=(cv+1):numel(x)
      ind(cv1) = ind(cv1) & xd(cv,cv1)<.98;
    end;
  end;
  x = x(ind);
  ldx = ldx(ind);
  l = l(ind);
  disp([sum(ldx)/numel(x) numel(x)])
end;

% canonicalise x and l
for k = 1:numel(x)
  % try to deal with negative lambdas
  if rem(sum(sign(x{k}(1,:))>0),2) == 1
    x{k} = repmat(x{k}(:,1),[1 order]);
    l(k) = -l(k);
  end;
end;

[tmp ind] = sort(-l);
if nargout > 0
  varargout{1} = x(ind);
end;

if nargout > 1
  varargout{2} = l(ind);
end;
