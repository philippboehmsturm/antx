function t = tensor_gop(varargin)
% generalised outer product
% FORMAT t = tensor_gop(u1,u2,...uN)
% ======
% Input arguments
%   - u1,..,uN - generating vectors
%   or
%   - U        - udim-by-N matrix of generating vectors U(:,1) ... U(:,N)
% Output argument
%   - t        - generated tensor
%
% Computes t(i1,i2,...,iN) = u1(i1)*u2(i2)*...*uN(iN), thus creating a 
% rank-1 tensor of order n with dimensionality [length(u1), length(u2), 
% ... length(uN)].
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tensor_gop.m 677 2009-09-02 08:07:46Z glauche $

rev = '$Revision: 677 $';

if nargin > 1
  szt = zeros(1,nargin);
  for k=1:nargin
    szt(k) = numel(varargin{k});
  end;
  
  t = varargin{1};
  for k=2:nargin
    t = kron(varargin{k},t);
  end;
else
  szt = repmat(size(varargin{1},1),[1,size(varargin{1},2)]);

  t = varargin{1}(:,1);
  for k=2:size(varargin{1},2)
    t = kron(varargin{1}(:,k),t);
  end;
end;  
t=reshape(t,szt);

function obsolete
t1=t;
t=zeros(szt);
ind=zeros(nargin,1);
indstr = sprintf('ind(%d),',1:nargin);
sub2indstr = sprintf('[%s] = ind2sub(szt,k);',indstr(1:end-1));
vaindstr = sprintf('varargin{%d}(ind(%d))*',kron(1:nargin,[1,1]));
prodstr = sprintf('t(%s) = %s;', indstr(1:end-1), vaindstr(1:end-1));
for k = 1:numel(t)
  eval(sub2indstr);
  eval(prodstr);
end;

keyboard
