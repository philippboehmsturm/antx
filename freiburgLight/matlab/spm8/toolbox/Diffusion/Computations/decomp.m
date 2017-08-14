function varargout = decomp(varargin)
% decompose tensor in rank-1 components
% FORMAT [x, l] = decomp(t,N)
% ======
% Input argument
%   t - full tensor
% Output arguments
%   x - 3-by-N matrix of generating vectors for rank-1 supersymmetric tensors
%   l - 1-by-N vector of scaling factors (Generalised Raleigh Quotient)
%
% This routine uses a greedy decomposition strategy to fit N rank-1 
% tensors to a given supersymmetric tensor. Starting estimates for the 
% rank-1 fit are obtained from hosvd.
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: decomp.m 677 2009-09-02 08:07:46Z glauche $

t = varargin{1}; % tensor
N = varargin{2};

ocnv = Inf;
order = ndims(t);
st1 = sum(t(:).^2);
for k=1:N
  [S U] = hosvd(t);
  [x{k} l(k)] = fitr1(t,U(:,1));
  % try to deal with negative lambdas
  if rem(sum(sign(x{k}(1,:))>0),2) == 1
    x{k} = repmat(x{k}(:,1),[1 order]);
    l(k) = -l(k);
  end;
  t = t - l(k)*tensor_gop(x{k});%repmat(x{k},[1 order]));
  cnv = sum(t(:).^2)/st1;
  disp([cnv l(k)]);
  if cnv>ocnv
    break;
  end;
  ocnv = cnv;
end;

[tmp ind] = sort(-l);
if nargout > 0
  varargout{1} = x(ind);
end;
if nargout > 1
  varargout{2} = l(ind);
end;
