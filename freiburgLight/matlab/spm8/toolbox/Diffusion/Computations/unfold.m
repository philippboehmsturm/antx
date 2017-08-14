function tn = unfold(t,n)
% tensor unfolding - see definition 1 in
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
% @(#) $Id: unfold.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';

sz = size(t);
nd = ndims(t);
if n <= nd
  tn = reshape(permute(shiftdim(t,n-1),[1 nd:-1:2]),sz(n),prod(sz)/ ...
               sz(n));
else
  error('illegal unfolding');
end;
