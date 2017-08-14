function varargout = dti_sphere_nb(varargin)
% Proximity of points on a unit sphere to a 6-, 18-, 26-neighbourhood
%
% Batch processing:
% FORMAT bchdefaults = dti_sphere_nb('defaults')
% ======
% returns the default batch structure as described below. This structure 
% can be used as a skeleton to fill in necessary values for batch processing.
%
% FORMAT [res bchdone]=dti_sphere_nb(bch)
% ======
% Input argument:
%   bch - struct array with fields
%         .res - sphere resolution on a grid [-1:bch.res:1]
%         .nb  - one of 6,18, 26: neighbourhood size and shape
%         .dim - optional: size of 3D-array to base linear index on
% Output arguments:
% res - struct array with fields
%       .nbhood - neighbourhood definition (NOT normalised to unit length)
%       .nbind  - if input has .dim set, return index offsets for linear 
%                 indexing
%       .F, .V  - faces and vertices of isosurface as produced by MATLABs 
%                 isosurface function
%       .ind    - nearest neighbour direction for each vertex (minimum 
%                 euklidean distance between .V and normalised .nbhood)
%       .Vd     - cell array of vertices, belonging to each neighbourhood 
%                 direction (this is merely a copy of V, but for 
%                 performance reasons in dti_dt_time3 we want this precomputed)
% bchdone - filled input struct
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_sphere_nb.m 712 2010-06-30 14:20:19Z glauche $

  rev = '$Revision: 712 $';

  % defaults
  mydefaults = struct('res',.05, 'nb',26);
  if nargin==1 && ischar(varargin{1}) && strcmpi(varargin{1},'defaults')
    varargout{1} = mydefaults;
    return;
  end;
  % Check input arguments
  if (nargin==1) && isstruct(varargin{1})
    bch = fillstruct(mydefaults,varargin{1});
  else
    bch = mydefaults;
  end;

  for ns = 1:numel(bch)
    [x y z] = ndgrid(-1:bch(ns).res:1);
    [res(ns).F res(ns).V]=isosurface(x,y,z,x.^2+y.^2+z.^2,1);
    switch(bch(ns).nb)
     case 6,
      nbhood = kron(eye(3),[1; -1]);
     case 18,
      for j = 1:3
        for k = 1:3
          for l = 1:3
            nbhood(sub2ind([3 3 3],j,k,l),1:3)=[j-2 k-2 l-2];
          end,
        end;
      end;
      nbhood = nbhood(sum(abs(nbhood),2)~=0&~all(nbhood,2),:);    
     case 26,
      for j = 1:3
        for k = 1:3
          for l = 1:3
            nbhood(sub2ind([3 3 3],j,k,l),1:3)=[j-2 k-2 l-2];
          end,
        end;
      end;
      nbhood = nbhood(sum(abs(nbhood),2)~=0,:);
     otherwise,
      error('unknown neighbourhood');
    end;
    res(ns).nbhood = nbhood;
    res(ns).num = 1:bch(ns).nb;
    res(ns).ones= ones(bch(ns).nb,1);
    nbhood = nbhood./(sqrt(sum(nbhood.^2,2))*ones(1,3));
    for k=1:size(nbhood,1)
      dist(k,:) = sqrt(sum((res(ns).V -...
                            ones(size(res(ns).V,1),1)*nbhood(k,:)).^2, ...
                           2))';
      res(ns).inum(k) = find(all(nbhood==-res(ns).ones*nbhood(k,:),2));
    end;
    [tmp res(ns).ind] = min(dist);
    for k=1:size(nbhood,1)
      res(ns).Vd{k} = res(ns).V(res(ns).ind==k,:);
    end;
  end;
  varargout{1}=res;
  varargout{2}=bch;

function visualise(res)
  col=abs(res.nbhood);
  figure;
  for k=1:size(res.nbhood,1)
    V1=res.V;
    V1(res.ind~=k,:)=NaN;
    h(k)=patch('Faces',res.F, 'Vertices',V1, 'FaceColor',col(k,:), ...
               'EdgeColor','none'); 
    hold on;
  end
  view(3);
  daspect([1 1 1]);
