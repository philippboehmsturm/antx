function varargout = dti_dt_recover(varargin)
% FORMAT t = dti_recover(evals, evec)
% ======
% evals - 3-by-N[-by-M]
% evec  - 3-by-3-by-N[-by-M]
% or
% FORMAT t = dti_recover(evals, euler)
% ======
% evals - 3-by-N[-by-M]
% euler - 3-by-N[-by-M]
%
% This function recomputes tensor values from decompositions in 
% eigenvectors or euler angles and eigenvalues. There is no GUI version 
% of this function available at present.
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_dt_recover.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Recover tensor';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

if nargin~=2
  error([mfilename ': Wrong number of input arguments']);
end;

sz1=size(varargin{1});
nd1=ndims(varargin{1});
sz2=size(varargin{2});
nd2=ndims(varargin{2});
if sz1(end) == 1
  sz1 = sz1(1:end-1);
  nd1=nd1-1;
end;
if sz2(end) == 1
  sz2 = sz2(1:end-1);
  nd2=nd2-1;
end;

if (sz1(1)~=3) || nd1 > 3
  error([mfilename ': Eigenvalues must be stored as 3-by-N-by-M']);
end;

if (nd1==nd2)
  if ~all(sz1 == sz2)
    error([mfilename ': Euler angles must be stored as 3-by-N-by-M']);
  end;
elseif (nd1 == nd2-1) 
  if ~all(sz1(2:end) == sz2(3:end))|| any(sz2(1:2)~=3)
    error([mfilename ': Eigenvectors must be 3-by-3-by-N-by-M']);
  end;
else
  error([mfilename ': Wrong input format']);
end;  

dim = [1 1];
dim(1:nd1-1) = sz1(2:nd1);
t = zeros([6 dim]);
if (nd1 == nd2)
  for k=1:dim(1)
    for l=1:dim(2)
      R1 = [1    0                        0;
	    0    cos(varargin{2}(1,k,l))  sin(varargin{2}(1,k,l));
	    0   -sin(varargin{2}(1,k,l))  cos(varargin{2}(1,k,l))];
      
      R2 = [cos(varargin{2}(2,k,l))  0    sin(varargin{2}(2,k,l));
	    0                        1    0;
	    -sin(varargin{2}(2,k,l)) 0    cos(varargin{2}(2,k,l))];
      
      R3 = [cos(varargin{2}(3,k,l))   sin(varargin{2}(3,k,l))  0;
	    -sin(varargin{2}(3,k,l))  cos(varargin{2}(3,k,l))  0;
	    0                         0                        1];
      R=R1*R2*R3;
      tmp = R*diag(varargin{1}(:,k,l))*R';
      t(:,k,l) = [tmp(1,1); tmp(2,2); tmp(3,3); tmp(1,2); tmp(1,3); ...
	tmp(2,3)];
    end;
  end;
elseif (nd1 == nd2-1) 
  for k=1:dim(1)
    for l=1:dim(2)
      tmp = varargin{2}(:,:,k,l)*diag(varargin{1}(:,k,l))*...
	  varargin{2}(:,:,k,l)';
      t(:,k,l) = [tmp(1,1); tmp(2,2); tmp(3,3); tmp(1,2); tmp(1,3); ...
	tmp(2,3)];
    end;
  end;
end;  
varargout{1}=t;
