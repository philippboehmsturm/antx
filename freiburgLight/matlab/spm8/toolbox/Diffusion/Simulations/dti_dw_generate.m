function varargout = dti_dw_generate(bch)
% generate simulated diffusion weighted data
% 
% Batch processing:
% FORMAT function dti_dw_generate(bch)
% ======
% Input argument:
% bch struct with fields
%/*\begin{description}*/
%/*\item[*/     .dim/*]*/    [Inf Inf Inf] or [xdim ydim zdim] dimension of output images
%/*\item[*/     .res/*]*/    sphere resolution (determines number of evaluated 
%             diffusion directions)
%/*\item[*/     .b/*]*/      b Value
%/*\item[*/     .i0/*]*/     Intensity of b0 image
%/*\item[*/     .lines/*]*/  lines substructures
%/*\item[*/     .prefix/*]*/ filename stub
%/*\item[*/     .swd/*]*/    working directory
%/*\end{description}*/
% lines substructure
%/*\begin{description}*/
%/*\item[*/       .t/*]*/    1xN evaluation points for line functions, defaults to [1:10]
%/*\item[*/       .fxfun, .fyfun, .fzfun/*]*/ function specifications
%/*\item[*/       .iso/*]*/  ratio of isotropic diffusion (0 no isotropic diffusion, 
%                1 no directional dependence)
%/*\item[*/       .fwhm/*]*/ exponential weight for non-isotropic diffusion (0 no 
%               weighting, +Inf only signal along line)
%/*\end{description}*/
% This function generates fibres according to the specifications 
% given in its input argument. Each specification describes a line in 3-D 
% space, parameterised by lines.t.
%
% fxfun, fyfun and fzfun can be the following functions that take as 
% input a parameter t and an struct array with additional parameters:
% 'linear'
% ret=a*t + off;
% 'tanhp'
% ret=r*tanh(f*t+ph) + off;
% 'sinp'
% ret=r*sin(f*t+ph) + off;
% 'cosp'
% ret=r*cos(f*t+ph) + off;
%
% fxfun, fyfun, fzfun can alternatively be specified directly as arrays 
% fxfun(t), fyfun(t), fzfun(t) of size nlines-by-numel(t). In that case, 
% no evaluation of fxprm, fyprm, fzprm takes place. It is checked, that 
% the length of each array line matches the length of lines.t.
% All parameters can be specified as 1x1, Mx1, 1xN, or MxN, where N must
% match the number of evaluation points in t. A line will be derived for
% each combination of parameters.
% At each grid point (rounded x(t),y(t),z(t)) the 1st derivative of the 
% line function (i.e. line direction) is computed. The diffusion gradient 
% directions are assumed to lie on a sphere produced by Matlab's 
% isosurface command. The sphere is evaluated on a grid 
% [-1:bch.res:1].
% The diffusivity profile of each line is assumed to depend only on the 
% angle between line direction and current diffusion gradient 
% direction. When multiple lines are running through the same voxel, 
% diffusivities will be averaged.
% A set of diffusion weighted images will be written to disk consisting 
% of a b0 image and one image for each diffusion gradient direction. 
% These images can then be used as input to the tensor estimation 
% routines. If finite dimensions for the images are given, lines will be 
% clipped to fit into the image. Otherwise, the maximum dimensions are 
% determined by the maximum line coordinates.
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_dw_generate.m 706M 2010-04-08 13:53:37Z (lokal) $

rev = '$Revision: 706M $';
funcname = 'DWI generator';

% function preliminaries
if ischar(bch)
    switch lower(bch) 
        case 'vfiles',
            varargout{1} = @vfiles_and_sphere;
            return;
        otherwise
            error('Unknown command option: %s', bch);
    end;
end;

Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

% compute lines from spec
spm_progress_bar('init', numel(bch.lines),...
                 'Computing line coordinates',...
                 'Lines completed');

cul = 1;
for cl = 1:numel(bch.lines)
    tmpx = evalfun(bch.lines(cl).fxfun,bch.lines(cl).t);
    tmpy = evalfun(bch.lines(cl).fyfun,bch.lines(cl).t);
    tmpz = evalfun(bch.lines(cl).fzfun,bch.lines(cl).t);
    % now combine into lines - external counter cul
    for cx = 1:size(tmpx,1)
        for cy = 1:size(tmpy,1)
            for cz = 1:size(tmpz,1)
                res.x{cul} = tmpx(cx,:);
                res.y{cul} = tmpy(cy,:);
                res.z{cul} = tmpz(cz,:);
                lind(cul)  = cl;
                cul = cul+1;
            end;
        end;
    end;
    spm_progress_bar('set',cl);
end;
nl = cul-1;
% differentiate lines
spm_progress_bar('init', nl,...
                 'Computing line differentials',...
                 'Lines completed');
dx = cell(cl,1);
dy = cell(cl,1);
dz = cell(cl,1);
mxx = zeros(cl,1);
mnx = zeros(cl,1);
mxy = zeros(cl,1);
mny = zeros(cl,1);
mxz = zeros(cl,1);
mnz = zeros(cl,1);
for cl = 1:nl
    dx{cl} = diff(res.x{cl});
    dy{cl} = diff(res.y{cl});
    dz{cl} = diff(res.z{cl});
    dl = sqrt(dx{cl}.^2+dy{cl}.^2+dz{cl}.^2);
    dx{cl} = dx{cl}./dl;
    dy{cl} = dy{cl}./dl;
    dz{cl} = dz{cl}./dl;
    % estimate an initial bounding box
    cmx = max(ceil(spm_matrix(bch.movprms(1,:))*...
                   [res.x{cl}; res.y{cl}; res.z{cl}; ...
                    ones(size(res.z{cl}))]),[],2);
    cmn = min(ceil(spm_matrix(bch.movprms(1,:))*...
                   [res.x{cl}; res.y{cl}; res.z{cl}; ...
                    ones(size(res.z{cl}))]),[],2);
    mxx(cl) = cmx(1);
    mxy(cl) = cmx(2);
    mxz(cl) = cmx(3);
    mnx(cl) = cmn(1);
    mny(cl) = cmn(2);
    mnz(cl) = cmn(3);
    spm_progress_bar('set',cl);
end;
spm_progress_bar('clear');
[res.files F g] = vfiles_and_sphere(bch);
% prepend b0 weighting, create b vector
b    = bch.b*ones(size(g,1)+1,1);
b(1) = 0;
g    = [0 0 0; g];
cdim = bch.dim;
mxdim = [min(mnx) min(mny) min(mnz); max(mxx) max(mxy) max(mxz)];
cdim(~isfinite(cdim)) = mxdim(~isfinite(cdim));

% create image information
mat = eye(4);
mat(1:3,4) = cdim(1,:)';
ref = eye(4);

% check movement params
if size(bch.movprms,1) == 1
    movprms = repmat(bch.movprms,size(g,1),1);
elseif size(bch.movprms,1) == size(g,1)
    movprms = bch.movprms;
else
    error('Wrong number of movement parameters');
end;

imdim = ceil(diff(cdim));
% loop over directions
im0 = zeros(imdim);
spm_progress_bar('init', size(g,1),...
                 'Evaluating diffusion profiles',...
                 'Directions completed');
for d = 1:size(g,1)
    im  = zeros(imdim);
    im1 = zeros(imdim);
    wt  = zeros(imdim);
    RM    = spm_matrix(movprms(d,:));
    for cl = 1:nl
        rxyz  = round(mat\RM*[res.x{cl}; res.y{cl}; res.z{cl}; ones(size(res.z{cl}))]);
        limdim = repmat(imdim,size(bch.lines(lind(cl)).t,2),1);
        sel   = all(rxyz(1:3,:)'<=limdim,2) & ...
                all(rxyz(1:3,:)' > 0,2);
        sel   = find(sel(1:end-1));
        imsel = sub2ind(imdim, rxyz(1,sel), rxyz(2,sel), rxyz(3,sel));
        if b(d) > 0
            lg  = repmat(g(d,:),size(bch.lines(lind(cl)).t,2)-1,1);
            rdxyz = RM*[dx{cl}; dy{cl}; dz{cl}; zeros(size(dz{cl}))];
            ang   = abs(sum(rdxyz(1:3,:)' .* lg,2))';
            im(imsel) = im(imsel) + bch.lines(lind(cl)).D* ...
                (bch.lines(lind(cl)).iso + (1-bch.lines(lind(cl)).iso)* ...
                 ang(sel).*exp(-bch.lines(lind(cl)).fwhm*(1-ang(sel)).^2));
            wt(imsel) = wt(imsel)+1;
        else
            im1(imsel) = 1;
        end
    end;
    [p n e v] = spm_fileparts(res.files{d});
    V = struct('fname',fullfile(p,[n e]), ...
               'dim',imdim, 'dt',[spm_type('float32') spm_platform('bigend')], 'mat',mat,...
               'pinfo',[Inf;Inf;0]);
    V = spm_create_vol(V);
    if b(d) > 0
        wt(wt==0)=1;
        im1 = exp(-b(d)*im./wt);
        im1(im==0)=0;
    end
    V = spm_write_vol(V,bch.i0*(bch.nr*rand(imdim)+im1));
    dti_get_dtidata(V.fname, struct('b',bch.b, 'g',g(d,:),'mat',mat,'ref',ref));
    spm_progress_bar('set',d);
end;
spm_progress_bar('clear');
varargout{1} = res;
return;

%-----------------------------------------------------------------------
% Line evaluation
%-----------------------------------------------------------------------
function ret=evalfun(fun,t)
% returns a #parameter-combinations-by-size(t,2) array of line points
if isfield(fun,'data')
    if size(fun.data,2)==size(t,2)
        ret = fun.data;
    else
        error('wrong number of elements in function data');
    end;
else
    funname = fieldnames(fun);
    ret = feval(funname{1}, t, fun.(funname{1}));
end;
return

function ret=linear(t,prm)
na = size(prm.a,1);
no = size(prm.off,1);
ret = zeros(na*no,size(t,2));
for ca = 1:na
    for co = 1:no
        ret((ca-1)*na+co,:)=prm.a(ca,:).*t + prm.off(co,:);
    end;
end;
return;

function ret=tanhp(t,prm)
nr = size(prm.r,1);
nf = size(prm.f,1);
np = size(prm.ph,1);
no = size(prm.off,1);
ret = zeros(nr*nf*np*no,size(t,2));
for cr = 1:nr
    for cf = 1:nf
        for cp = 1:np
            for co = 1:no
                ret((((cr-1)*nr+cf-1)*nf+cp-1)*np+co,:) = ...
                    prm.r(cr,:).*tanh(prm.f(cf,:).*t+prm.ph(cp,:))...
                    + prm.off(co,:);
            end;
        end;
    end;
end;
return;

function ret=sinp(t,prm)
nr = size(prm.r,1);
nf = size(prm.f,1);
np = size(prm.ph,1);
no = size(prm.off,1);
ret = zeros(nr*nf*np*no,size(t,2));
for cr = 1:nr
    for cf = 1:nf
        for cp = 1:np
            for co = 1:no
                ret((((cr-1)*nr+cf-1)*nf+cp-1)*np+co,:) = ...
                    prm.r(cr,:).*sin(prm.f(cf,:).*t+prm.ph(cp,:))...
                    + prm.off(co,:);
            end;
        end;
    end;
end;
return;

%-----------------------------------------------------------------------
% virtual files
%-----------------------------------------------------------------------

function varargout = vfiles_and_sphere(bch)

[xs ys zs] = ndgrid(-1:bch.res:1);
[F g]  = isosurface(xs,ys,zs,xs.^2+ys.^2+zs.^2,1);
g = g./(sqrt(sum(g.^2,2))*[1 1 1]);
fileformat = sprintf('sim%s_%%0%dd.nii,1', bch.prefix, ...
                     floor(log10(size(g,1)))+1);
vf = cell(size(g,1)+1,1);
for k = 0:size(g,1)
    vf{k+1} = fullfile(bch.swd{1},sprintf(fileformat,k));
end;
varargout{1} = vf;
if nargout == 3
    varargout{2} = F;
    varargout{3} = g;
end;
