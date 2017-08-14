function varargout=hosvd(t)
% Compute higher order SVD from tensor
% For details, see
%/*\cite{lathauwer00}*/
% [LdL00]      Lieven de Lathauwer, Bart de Moor and Joos Vandewalle. A
%              Multilinear Singular Value Decomposition. SIAM Journal of
%              Applied Matrix Analysis, 21(4):1253--1278, 2000.
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: hosvd.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';

for dim = 1:ndims(t)
  [U{dim} S V] = svd(unfold(t,dim));
  if dim == 2
    UA = U{dim};
  elseif dim > 2
    UA = kron(UA,U{dim});
  end;
end;
S = ipermute(reshape(U{1}'*unfold(t,1)*UA,size(t)),[1 ndims(t):-1:2]);
varargout{1}=S;
for dim = 1:ndims(t)
  varargout{dim+1}=U{dim};
end;
