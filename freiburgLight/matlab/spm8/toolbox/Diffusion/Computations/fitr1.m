function varargout = fitr1(varargin)
% fit rank-1 tensor to general tensor
% FORMAT [x, l] = fitr1(t, x0)
% ======
% Input argument
%   t  - full tensor
%   x0 - starting estimate for x, defaults to [1;0;0];
% Output arguments
%   x - matrix of generating vectors for rank-1 tensor
%   l - vector of scaling factors (Generalised Raleigh Quotient)
%
% This routine needs a good starting estimate for x in order to find the 
% global optimum, otherwise it will be caught in a local optimum. This 
% optimised starting estimate may be obtained from e.g. hosvd result U1(:,1).
% For a comment on fitting supersymmetric tensors, see eq. 3.14f in [dLdM00].
%
% References:
%/*\cite{lathauwer00}*/
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
% @(#) $Id: fitr1.m 677 2009-09-02 08:07:46Z glauche $

t = varargin{1}; % tensor

xo = [0 0 0]';
% starting estimate
if nargin > 1
  x = varargin{2};
else
  x = [1 0 0]'; 
end;

order = ndims(t);
szt = size(t);
x=repmat(x,1,order); % FIXME: consider tensors of different dimensionality
xind = 1:order;
tsub.type = '()';
[tsub.subs{1:order}] = deal(':');
tflat.type = '()';
tflat.subs = {':'};

ldx = Inf;
while ldx > .0001 
  xo = x(:,1);
  for co = 1:order
    tx = tensor_gop(x(:,xind~=co));
    for k=1:szt(co) % for-loop seems to be more efficient than
                    % repmat'ting tx
      tsub.subs{k} = k;
      x(k,co) = sum(subsref(subsref(t,tsub),tflat).*tx(:));
      tsub.subs{k} = ':';
    end;
    x(:,co)=x(:,co)./sqrt(sum(x(:,co).^2));
  end;
  ldx = sqrt(sum((x(:,1)-xo).^2));
end;

if nargout > 0
  varargout{1} = x;
end;

if nargout > 1
  tx = tensor_gop(x);
  varargout{2} = sum(t(:).*tx(:));
end;
