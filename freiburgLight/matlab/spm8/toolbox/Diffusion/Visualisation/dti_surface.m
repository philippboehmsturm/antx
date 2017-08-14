function varargout=dti_surface(varargin)
% 3D surface of diffusion tensors
%
% For each tensor, a diffusion surface is displayed. This surface is 
% computed by evaluating the diffusion profile given in the tensor along 
% directions on a unit sphere. The diffusion value is the distance 
% between origin and surface in the evaluated direction.  Although all 
% relevant information is already present in the surfaces, colour 
% coding and transparency are used to encode
% colour       - for ellipsoids
%                RGB colours for main diffusion direction (R=x, G=y, B=z 
%                direction)
%              - for diffusion profiles
%                RGB colours for each point on the surface, showing its 
%                direction from the origin
% transparency - Anisotropy (low anisotropy=high transparency). For 
%                visualisation, the ratio between minimum and maximum 
%                diffusivity (also known as relative anisotropy) is used 
%                as measure of anisotropy.
% A correct visualisation depends on a suitable choice of .res and 
% .scaling parameters. The more points are sampled on the surface, the 
% better the approximation of the tensor shape. In addition, .scaling 
% should be chosen such that the average tensors fill a voxel quite 
% well. Otherwise, poor surface representations with misleading colouring 
% may be produced. For an interpretation of diffusion profiles, see the 
% literature/*\cite{Orszalan2003}*/.
%
% Batch processing:
% FORMAT [res bchdone] = dti_surface(bch)
% ======
% Input argument:
%   bch - Struct array bch with the following fields:
%         .files   - Cell array of diffusion tensor filenames.
%         .data    - If files is empty: a Nelem-by-X-by-Y-by-Z array 
%                    of tensor values. Tensor components are assumed 
%                    to be given in  alphabetical order.
%         .mat     - if .data is given, a 4-by-4 transformation matrix to 
%                    transform voxel coordinates into world coordinates 
%                    (as used by spm_vol and other volume routines) - 
%                    defaults to eye(4)
%         .xyzvx,
%         .xyzmm   - voxel or mm coordinates to be sampled. If no 
%                    coordinates are given, then the whole data set is 
%                    rendered. If both are given, mm coordinates take 
%                    precedence over voxel coordinates, and only one 
%                    surface is rendered per voxel. If none are 
%                    given, voxels are counted starting at (1,1,1).
%         .order    - Tensor order. If data is of order 2, there is a 
%                    choice between two surface types: 
%         .type    - 'profile' diffusion profiles or
%                    'ellipsoid' diffusion ellipsoids
%         .res     - sphere resolution. The sphere is specified on a grid 
%                    with range [-1:bch.res:1].
%         .scaling - scaling factor. A value of 0 means per-tensor scaling.
%         .f       - figure handle to use - missing or empty creates new 
%                    figure
%         .alpha   - Use transparency to encode anisotropy? 
%                    (0 - no, 1 - yes). Warning: "yes" may crash Matlab!
%         .fxbgcol,axbgcol - figure and axis background colours.
% Output arguments:
%   bchdone - filled batch structure
%   res     - results struct with fields
%             .h       - array of surface handles
%             .scaling - if bch.scaling == 0, returns minimum and maximum
%                        per-voxel scaling factors.
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_surface.m 716 2010-09-02 12:14:11Z glauche $

rev = '$Revision: 716 $';
funcname = 'Diffusion surfaces';

% defaults
mydefaults = struct('files',{{}}, 'data',[], 'mat',eye(4),... 
                    'xyzvx',[], 'xyzmm',[], 'type',[], 'scaling',[],...
                    'res',[], 'order',[], 'f',[], 'ax',[],...
                    'axbgcol',[0 0 0], 'fgbgcol',[.2 .2 .2],...
                    'alpha',0);
if nargin>0 && ischar(varargin{1})
  switch lower(varargin{1})
   case 'defaults',
    varargout{1} = mydefaults;
    return;
   case 'menu',
    Menu = uimenu(varargin{2},'Label',funcname,...
                  'Callback',mfilename);
    return;
   case 'hmenu',
    Menu = uimenu(varargin{2},'Label',['Help on ' funcname],...
                  'Callback',['spm_help(''' mfilename ''')']);
    return;
  end;
end;

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

% Check input arguments
if (nargin==1) && isstruct(varargin{1})
  % Check for spmr_pp-batch
  if isfield(varargin{1},'step')
    bch = fillstruct(mydefaults, varargin{1}.step);
  else
    bch = fillstruct(mydefaults, varargin{1});
  end;
  nsub = numel(bch);
else
  nsub   = spm_input('# subjects','!+1','e','');
  bch=repmat(mydefaults,[nsub 1]);
end;

for sub = 1:nsub
  spm_input(sprintf('subject %d', sub),1,'d',funcname);
  if isempty(bch(sub).order)
    bch(sub).order = spm_input('Tensor order', '!+1','e');
  end;
  if bch(sub).order == 2
    if isempty(bch(sub).type)
      bch(sub).type = char(spm_input('Surface type', '!+1', 'm',...
                                {'Diffusion ellipsoid', 'Diffusion profile'},...
                                {'ellipsoid','profile'}, 2));
    else
      bch(sub).type = lower(bch(sub).type);
    end;
  else
    bch(sub).type = 'profile';
    bch(sub).alpha= 0; % MATLAB likes to crash on alpha shaded patches
  end;
  if isempty(bch(sub).files) && isempty(bch(sub).data)
    nimg = (bch(sub).order+1)*(bch(sub).order+2)/2;
    selstr = sprintf('D%s_*IMAGE',repmat('?',1,bch(sub).order));
    bch(sub).files = spm_get(nimg,selstr,...
                             {sprintf('Subject %d -DT images',sub)});
  elseif isstruct(bch(sub).files)
    ftmp = [];
    for k=1:numel(bch(sub).files.dirs)
      ftmp = char(ftmp,spm_get('files',...
				  bch(sub).files.dirs{k},...
				  bch(sub).files.filter));
    end;
    bch(sub).files = cellstr(ftmp);
  end;
  if isempty(bch(sub).scaling)
    bch(sub).scaling = spm_input('Scaling factor (0 for per-tensor scaling)',...
	'!+1','e',0);
  end;
  if isempty(bch(sub).res)
    bch(sub).res = spm_input('Sphere resolution', '!+1','e',.2);
  end;
end;

spm('pointer', 'watch');
for sub = 1:nsub
  if bch(sub).scaling == 0
    res(sub).scaling = [Inf 0];
  else
    res(sub).scaling = [bch(sub).scaling bch(sub).scaling];
  end;
  global defaults;
  try
    if defaults.analyze.flip
      flipx = -1;
    else
      flipx = 1;
    end;
  catch
    warning('spm_tbx_Diffusion:dti_surface_ImageOrient',...
            'Can''t determine image orientation, assuming un-flipped');
    flipx=1;
  end;  

  [xs ys zs] = ndgrid(-1:bch(sub).res:1);
  if strcmp(bch(sub).type,'ellipsoid')
    G = [xs(:) ys(:) zs(:)];
    bsel = zeros(size(xs));
    bsel([1 end],:,:) = 1;
    bsel(:,[1 end],:) = 1;
    bsel(:,:,[1 end]) = 1;
    bsel = logical(bsel(:));
  else
    [F G] = isosurface(xs, ys, zs, xs.^2+ys.^2+zs.^2,1);
  end;
  [Hind mult] = dti_dt_order(bch(sub).order);
  HM = zeros(size(G,1),(bch(sub).order+1)*(bch(sub).order+2)/2);
  for k = 1:(bch(sub).order+1)*(bch(sub).order+2)/2
    HM(:,k) = prod(G(:,Hind(:,k)),2)*mult(k);
  end;

  if isempty(bch(sub).data)
    if bch(sub).order==2
      bch(sub).files = dti_fileorder(bch(sub).files);
    end;
    DTIHandle=spm_vol(char(bch(sub).files));
    tmp = spm_imatrix(DTIHandle(1).mat);
    minvx = min(abs(tmp(7:9)));
  else
    DTIHandle.mat=bch(sub).mat;
    tmp = size(bch(sub).data);
    tmp(end:4)=1;
    DTIHandle.dim = tmp(2:4);
    minvx = 1;
  end;  

  if ~isempty(bch(sub).xyzvx) && ~isempty(bch(sub).xyzmm)
    bch(sub).xyzvx=[];
  end;
  if isempty(bch(sub).xyzvx) && isempty(bch(sub).xyzmm)
    [x y z]=ndgrid(1:DTIHandle(1).dim(1), 1:DTIHandle(1).dim(2), ...
                   1:DTIHandle(1).dim(3));
    bch(sub).xyzvx = [x(:),y(:),z(:)];
  end;
  if isempty(bch(sub).xyzvx) && ~isempty(bch(sub).xyzmm)
    tmp=DTIHandle(1).mat\[bch(sub).xyzmm'; ones(1,size(bch(sub).xyzmm,1))];
    bch(sub).xyzvx=unique(round(tmp(1:3,:)'),'rows');
  end;
  tmp=DTIHandle(1).mat*[bch(sub).xyzvx'; ones(1,size(bch(sub).xyzvx,1))];
  bch(sub).xyzmm=tmp(1:3,:)';
  
  if isempty(bch(sub).data)
    DTIPlane=zeros(numel(DTIHandle),size(bch(sub).xyzvx,1));
    for n=1:numel(DTIHandle)
      DTIPlane(n,:) = spm_sample_vol(DTIHandle(n), bch(sub).xyzvx(:,1), ...
                                     bch(sub).xyzvx(:,2), ...
                                     bch(sub).xyzvx(:,3), 0)';
    end;
  else
    DTIPlane = reshape(bch(sub).data(:,:,:,:), [size(bch(sub).data,1) ...
                        size(bch(sub).xyzvx,1)]);
  end;
  if strcmp(bch(sub).type,'ellipsoid')
    RM = HM*dti_inv(DTIPlane);
  else
    RM = HM*DTIPlane;
  end;
  if bch(sub).scaling == 0
    if strcmp(bch(sub).type,'ellipsoid')
      scal = 2.2*minvx./min(RM(bsel,:));
    else
      scal = .9*minvx./(2*max(RM));
    end;
    %FIXME: sort out "negative" tensors
    scal(scal<0) = NaN;
    res(sub).scaling(1) = min([scal(isfinite(scal)),res(sub).scaling(1)]);
    res(sub).scaling(2) = max([scal(isfinite(scal)),res(sub).scaling(2)]);
  else
    scal = bch(sub).scaling*ones(prod(DTIHandle(1).dim(1:2)));
  end;

  res(sub).h = zeros(prod(DTIHandle(1).dim(1:3)),1);
  if isempty(bch(sub).f)
    bch(sub).f=figure;
  end;
  if isempty(bch(sub).ax)||~ishandle(bch(sub).ax)
    bch(sub).f=figure(bch(sub).f);
    bch(sub).ax=axes('parent',bch(sub).f);
    [az el] = view(3);
  else
    [az el] = view(bch(sub).ax);
    cla(bch(sub).ax);
  end;
  lim(:,1)=DTIHandle(1).mat*.5*ones(4,1);
  lim(:,2)=DTIHandle(1).mat*[DTIHandle(1).dim(1:3)'+.5; 1];
  set(bch(sub).ax,'color',bch(sub).axbgcol, 'xcolor',[.9 .7 .7], ...
         'ycolor',[.7 .9 .7], 'zcolor',[.7 .7 .9], 'box','on',...
         'xlim',[min(lim(1,:))-1 max(lim(1,:))+1], ...
         'ylim',[min(lim(2,:))-1 max(lim(2,:))+1], ...
         'zlim',[min(lim(3,:))-1 max(lim(3,:))+1]);  
  set(bch(sub).f,'color',bch(sub).fgbgcol, 'InvertHardCopy','off');
  view(bch(sub).ax, az,el);
  hold(bch(sub).ax, 'on');

  for l=1:size(RM,2)
    if all(isfinite(RM(:,l)))&&any(RM(:,l)>0)&&isfinite(scal(l))
      if strcmp(bch(sub).type,'ellipsoid')
        R = reshape(RM(:,l),size(xs))*scal(l);
        [F V] = isosurface(flipx*xs,ys,zs,R,1);
      else
        V=G.*(RM(:,l)*[flipx 1 1])*scal(l);
      end;
      if ~isempty(V)
        [almax colind] = max(sum(V.^2,2));
        if strcmp(bch(sub).type,'ellipsoid')
          Vc = abs(V(colind,:));
          Vc = Vc./max(Vc);
          Fc = 'flat';
        else
          Vc = abs(V);
          Vc = Vc./(max(Vc,[],2)*[1 1 1]);
          Fc = 'interp';
        end;
        if bch(sub).alpha
          al = 1-sqrt(min(sum(V.^2,2))/almax);
        else
          al = 1;
        end;
        % translate to world coordinates
        V(:,1) = V(:,1)+bch(sub).xyzmm(l,1);
        V(:,2) = V(:,2)+bch(sub).xyzmm(l,2);
        V(:,3) = V(:,3)+bch(sub).xyzmm(l,3);
        res(sub).h(l) = patch('Faces',F, 'Vertices',V, 'parent',bch(sub).ax,...
                              'FaceVertexCData',Vc, 'FaceColor',Fc,...
                              'FaceAlpha',al, 'EdgeColor','none','HitTest','off'); 
      end;
    end;
  end;
  set(bch(sub).ax,'Tag',mfilename);
  axes(bch(sub).ax); % camlight doesn't accept 'parent' argument
  camlight,
  lighting phong, 
  daspect([1 1 1]),
  axis(bch(sub).ax, 'tight');
  if size(bch(sub).xyzmm,1)>1
    titlestr=sprintf('order-%d tensor',bch(sub).order);
  else
    titlestr=sprintf('order-%d tensor at [%.0f,%.0f,%.0f] vx',...
                     bch(sub).order,bch(sub).xyzvx);
  end;
  title(bch(sub).ax, titlestr,...
        'Fontsize',20,'Fontweight','bold','color','w');
  xlabel(bch(sub).ax, 'X','Fontsize',20,'Fontweight','bold');
  ylabel(bch(sub).ax, 'Y','Fontsize',20,'Fontweight','bold');
  zlabel(bch(sub).ax, 'Z','Fontsize',20,'Fontweight','bold');
  res(sub).h=res(sub).h(res(sub).h~=0);
end;
spm_input('!DeleteInputObj');
if nargout > 0
  varargout{1}=res;
end;
if nargout > 1
  varargout{2}=bch;
end;
spm('pointer', 'arrow');
return;

